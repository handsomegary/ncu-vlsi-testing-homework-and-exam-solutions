#!/usr/bin/env python3
"""Reproducible checks of preserved student sources, including known defects.

Requires Python 3, Icarus Verilog (iverilog/vvp), and a C++17 compiler.
Generated benches, binaries, and FSDB-free smoke copies live in a temporary folder.
The archived student sources are never modified.
"""
from pathlib import Path
import argparse
import itertools
import json
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent
NODES = list("ABCDEFGHIJKLM")
PATTERNS = ["0001", "1100", "0110", "0011", "1101", "1010", "0101",
            "1110", "0111", "1111", "1011", "1001", "1000", "0100", "0010"]


def hw2_model(bits, fault=None):
    values = {}
    def put(node, value):
        values[node] = int(bool(value)) if fault is None or fault[0] != node else fault[1]
        return values[node]
    for name, bit in zip("ABCDE", bits):
        put(name, int(bit))
    put("G", not (values["C"] or values["D"]))
    put("H", not values["E"])
    put("I", values["B"] and values["G"])
    put("J", values["I"])
    put("K", values["I"])
    put("L", not (values["A"] or values["J"]))
    put("M", values["H"] and values["K"])
    return put("F", values["L"] or values["M"])


def hw3_model(bits, faulty=False):
    a, b, c, d = map(int, bits)
    upper = (a and not b and not c and not d) or (not a and not b and c and not d)
    lower = ((a and b and not c and d) or (not a and b and not c and not d)
             or (not a and b and c and d))
    return int(bool(upper or (lower and not faulty)))


def syndrome_model(bits, fault=None):
    values = {}
    def put(node, bit):
        values[node] = int(bool(bit)) if fault is None or fault[0] != node else fault[1]
        return values[node]
    for node, bit in zip("abcd", bits):
        put(node, bit)
    put("e", values["a"] and values["b"])
    put("f", not (values["c"] and values["d"]))
    return put("z", not (values["e"] or values["f"]))


def signature(stream):
    state = [0, 0, 0, 0]
    for bit in stream:
        state = [int(bit) ^ state[3], state[0] ^ state[3], state[1], state[2]]
    return "".join(map(str, state))


def run(command, cwd, timeout=30):
    result = subprocess.run(list(map(str, command)), cwd=cwd, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout)
    if result.returncode:
        raise RuntimeError(f"Command failed ({result.returncode}): {' '.join(map(str, command))}\n{result.stdout}")
    return result.stdout


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--iverilog", default="iverilog")
    parser.add_argument("--vvp", default="vvp")
    parser.add_argument("--cxx", default="g++")
    parser.add_argument("--json", type=Path)
    args = parser.parse_args()
    for executable in (args.iverilog, args.vvp, args.cxx):
        if shutil.which(executable) is None and not Path(executable).is_file():
            parser.error(f"Required executable not found: {executable}")
    results = {"collection": "Quartz-4b7e", "checks": {}, "known_issues": []}
    with tempfile.TemporaryDirectory(prefix="quartz-vlsi-") as work:
        work = Path(work)
        def sim(name, hw, files, bench):
            bench_path = work / (name + ".v")
            bench_path.write_text(bench, encoding="utf-8")
            output = work / (name + ".vvp")
            run([args.iverilog, "-g2012", "-Wall", "-s", "verify", "-o", output,
                 *[ROOT / hw / "source" / f for f in files], bench_path], work)
            return run([args.vvp, output], work)

        # Full-adder and RCA arithmetic: independently derived integer sums.
        arithmetic = []
        for i in range(8):
            arithmetic.append(f"a={i>>2};b={(i>>1)&1};ci={i&1};#1;if({{co,s}}!==2'd{(i>>2)+((i>>1)&1)+(i&1)}) $fatal(1,\"FA\");")
        seed = 0x4B7E
        for _ in range(256):
            seed = (1664525 * seed + 1013904223) & 0xFFFFFFFF
            x, y, cin = seed & 65535, seed >> 16, (seed >> 7) & 1
            expected = x + y + cin
            injected = ((((x >> 1) + (y >> 1) + 1) << 1) | ((x ^ y ^ cin) & 1))
            arithmetic.append(f"x=16'd{x};y=16'd{y};ci=1'b{cin};test=0;#1;if({{cout,sum}}!==17'd{expected}) $fatal(1,\"RCA normal\");test=1;#1;if({{cout,sum}}!==17'd{injected}) $fatal(1,\"RCA injection\");")
        sim("hw1-arithmetic", "hw1", ["HW1_1_full_adder.v", "HW1_1_RCA.v"],
            "module verify;reg a,b,ci,test;reg[15:0]x,y;wire s,co,cout;wire[15:0]sum;"
            "full_adder fa(a,b,ci,s,co);RCA r(x,y,ci,test,sum,cout);initial begin\n"
            + "\n".join(arithmetic) + '\n$display("ARITHMETIC OK");$finish;end endmodule')
        results["checks"]["hw1_arithmetic"] = 8 + 512

        bist = r'''module verify;
reg reset=1,clk=0,en=0,test=0,cin=0;reg[15:0]x=0,y=0;
wire[15:0]sum;wire pf,cout;
main u(reset,clk,en,test,cin,x,y,sum,pf,cout);
task tick;begin #5;clk=1;#1;clk=0;end endtask
integer j;reg seen;
initial begin
tick;reset=0;x=300;y=59;tick;if(sum!==16'd359)$fatal(1,"normal mode");
test=1;en=1;seen=0;
for(j=0;j<10;j=j+1)begin tick;if(pf===1'b1)seen=1;end
if(!seen||pf!==1'b0)$fatal(1,"expected nonsticky failure behavior changed");
reset=1;tick;reset=0;en=0;
repeat(3)tick;
if(u.bist.counter!==4'd3)$fatal(1,"expected enable pause defect changed");
$display("KNOWN BIST LIMITATIONS REPRODUCED");$finish;
end endmodule'''
        sim("hw1-bist", "hw1", ["HW1_1_full_adder.v", "HW1_1_RCA.v", "HW1_1_BIST.v", "HW1_1_main.v"], bist)
        results["checks"]["hw1_bist_protocol"] = 3
        results["known_issues"] += ["BIST failure indication is not sticky", "BIST counter ignores En"]
        local_inputs = {(0,0,0),(0,1,0),(0,1,1),(1,0,0),(1,0,1),(1,1,1)}
        assert (0,0,1) not in local_inputs and (1,1,0) not in local_inputs
        results["known_issues"].append("BIST patterns miss FA0 input triples 001 and 110")

        q3 = []
        for value in range(8):
            a,b,c = (value>>2)&1,(value>>1)&1,value&1
            q3.append(f"{{a,b,c}}=3'd{value};#1;if(o1!==1'b{a^b^c}||o2!==1'b{int(a+b+c>=2)})$fatal(1,\"Q3\");")
        q3 += ["{a,b,c}=3'b100;#1;if(o1!==1'b1)$fatal; a=0;#1;if(o1!==1'b0)$fatal;",
               "{a,b,c}=3'b001;#1;if(o1!==1'b1)$fatal;force u.w1=0;#1;if(o1!==1'b0)$fatal;release u.w1;"]
        sim("hw1-q3", "hw1", ["HW1_3.v"],
            "module verify;reg a,b,c;wire o1,o2;ckt u(a,b,c,o1,o2);initial begin\n"
            + "\n".join(q3) + "\n$finish;end endmodule")
        results["checks"]["hw1_q3_truth_table_and_counterexamples"] = 10
        results["known_issues"].append("Report's A/0 and w1/0 undetected claims have counterexamples")

        # All 32 assignments, 26 faults, and four fault-free control codes.
        ports = ",".join(f".ctrl_{node}(ctrl[{i}])" for i,node in enumerate(NODES))
        init = "".join(f"ctrl[{i}]=0;" for i in range(13))
        lines = []
        for value in range(32):
            bits = f"{value:05b}"
            lines.append(f"{{A,B,C,D,E}}=5'b{bits};{init}#1;if(F!==1'b{hw2_model(bits)})$fatal(1,\"HW2 good\");")
            for index, node in enumerate(NODES):
                for stuck in (0,1):
                    lines.append(f"ctrl[{index}]={stuck+1};#1;if(F!==1'b{hw2_model(bits,(node,stuck))})$fatal(1,\"HW2 fault\");ctrl[{index}]=0;")
                lines.append(f"ctrl[{index}]=3;#1;if(F!==1'b{hw2_model(bits)})$fatal(1,\"HW2 ctrl3\");ctrl[{index}]=0;")
        sim("hw2-exhaustive", "hw2", ["HW2_3.v", "HW2_3_mux.v"],
            "module verify;reg A,B,C,D,E;reg[1:0]ctrl[0:12];wire F;circuit u(.A(A),.B(B),.C(C),.D(D),.E(E),.F(F),"
            + ports + ");initial begin\n" + "\n".join(lines) + "\n$finish;end endmodule")
        results["checks"]["hw2_exhaustive_fault_controls"] = 32 * (1 + 26 + 13)
        detected = {}
        for bits in ("10101", "10010", "00010", "10100", "01011"):
            detected[bits] = [f"{n}/{s}" for n in NODES for s in (0,1) if hw2_model(bits,(n,s)) != hw2_model(bits)]
        expected_sets = {
            "10101": {"A/0","F/1","L/1","M/1"},
            "10010": {"A/0","F/1","I/1","K/1","L/1","M/1"},
            "00010": {"A/1","F/0","J/1","L/0"},
            "10100": {"A/0","F/1","I/1","K/1","L/1","M/1"},
            "01011": {"A/1","D/0","G/1","I/1","J/1","L/0","F/0"}}
        assert all(set(detected[key]) == val for key,val in expected_sets.items())
        assert len(set().union(*(set(detected[b]) for b in list(detected)[:4]))) == 10
        results["hw2_detected_sets"] = detected
        results["checks"]["hw2_report_detected_sets"] = 5

        # HW3: match retained circuit exactly, and explicitly report statement mismatch.
        lines=[]
        for value in range(16):
            bits=f"{value:04b}"
            for fault in (0,1):
                lines.append(f"x=4'b{bits};fault={fault};#1;if(F!==1'b{hw3_model(bits,bool(fault))})$fatal(1,\"HW3 circuit\");")
        sim("hw3-circuit", "hw3", ["circuit.v"],
            "module verify;reg[0:3]x;reg fault;wire F;circuit u(x,fault,F);initial begin\n"+"\n".join(lines)+"\n$finish;end endmodule")
        results["checks"]["hw3_circuit_truth_table"] = 32
        streams=["".join(str(hw3_model(bits,bool(f))) for bits in PATTERNS) for f in (0,1)]
        assert streams == ["000010001000111", "000000000000101"]
        assert [signature(s) for s in streams] == ["0011", "1010"]
        seq=[]
        for stream in streams:
            seq.append("reset=1;#1;clk=1;#1;clk=0;reset=0;")
            state=[0,0,0,0]
            for bit in stream:
                state=[int(bit)^state[3],state[0]^state[3],state[1],state[2]]
                seq.append(f"data=1'b{bit};#1;clk=1;#1;if(D!==4'b{''.join(map(str,state))})$fatal(1,\"LFSR\");clk=0;")
        sim("hw3-lfsr", "hw3", ["LFSR.v"],
            "module verify;reg data,clk=0,reset=0;wire q;wire[0:3]D;LFSR u(data,clk,reset,q,D);initial begin\n"+"\n".join(seq)+"\n$finish;end endmodule")
        results["checks"]["hw3_lfsr_states"] = 30
        results["hw3_student_streams"] = streams
        results["hw3_student_signatures"] = [signature(s) for s in streams]
        results["known_issues"] += ["HW3 circuit produces F=0 for 0001 while statement specifies F=1",
                                   "HW3 faulty RTL signature is 1010, contradicting report's 0010 and bit list"]

        cpp = work / ("syndrome.exe" if __import__("os").name == "nt" else "syndrome")
        compiler_output=run([args.cxx,"-std=c++17","-O2","-Wall","-Wextra","-pedantic",ROOT/"hw3"/"source"/"HW3_2.cpp","-o",cpp],work)
        observed=re.findall(r"Output: ([01]{8})",run([cpp],work))
        sequences=[list(map(int,x)) for x in ("11110000","11001100","10101010","10101110")]
        vectors=list(zip(*sequences))
        faults=[None]+[(n,s) for n in "abcdefz" for s in (0,1)]
        expected=["".join(str(syndrome_model(bits,fault)) for bits in vectors) for fault in faults]
        assert observed==expected, (observed,expected)
        golden=(sum(map(int,expected[0]))%2,sum(map(int,expected[0])))
        missed=[f"{fault[0]}/{fault[1]}" for fault,stream in zip(faults[1:],expected[1:])
                if (sum(map(int,stream))%2,sum(map(int,stream)))==golden]
        assert missed==["d/1"]
        results["checks"]["hw3_cpp_response_streams"] = 15
        results["hw3_cpp_unmodified_compiler_warnings"] = bool(compiler_output.strip())
        results["hw3_compaction_undetected"] = missed

        # Original testbench smoke runs: remove only nonportable waveform calls in TEMP.
        groups=[("hw1","HW1_1_testbench.v",["HW1_1_full_adder.v","HW1_1_RCA.v","HW1_1_BIST.v","HW1_1_main.v"],"tb"),
                ("hw1","HW1_3_testbench.v",["HW1_3.v"],"tb"),
                ("hw2","HW2_3_tb.v",["HW2_3.v","HW2_3_mux.v"],"tb"),
                ("hw2","HW2_3_fault_free_tb.v",["HW2_3_fault_free.v"],"fault_free"),
                ("hw3","HW3_1_tb.v",["HW3_1.v","circuit.v","LFSR.v"],"hw3_1_tb")]
        for number,(hw,tb,files,top) in enumerate(groups):
            text=(ROOT/hw/"source"/tb).read_text(encoding="utf-8")
            text=re.sub(r"^.*\$fsdbDump(?:file|vars)\([^\n]*\);.*$","",text,flags=re.M)
            bench=work/f"smoke-{number}.v";bench.write_text(text,encoding="utf-8")
            binary=work/f"smoke-{number}.vvp"
            run([args.iverilog,"-g2012","-s",top,"-o",binary,*[ROOT/hw/"source"/f for f in files],bench],work)
            run([args.vvp,binary],work)
        results["checks"]["original_bench_smoke_with_fsdb_calls_omitted"] = len(groups)
    results["total_checks"] = sum(results["checks"].values())
    results["status"] = "PASS: preserved behavior and documented defects reproduced"
    output=json.dumps(results,indent=2)+"\n"
    print(output,end="")
    if args.json:
        args.json.write_text(output,encoding="utf-8")


if __name__ == "__main__":
    main()

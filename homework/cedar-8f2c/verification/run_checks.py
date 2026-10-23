#!/usr/bin/env python3
"""Exercise preserved student RTL with Icarus, without changing the source.

Results are observations, including known failures, rather than an AC certificate.
All compiled files are kept in an automatically removed temporary directory.
"""
from pathlib import Path
import argparse, json, re, shutil, subprocess, tempfile

ROOT = Path(__file__).resolve().parents[1]

ADDER_TB = r'''
`timescale 1ns/1ps
module audit_tb;
reg Clk=0, Rst=0, En=0, Test=0;
reg [15:0] x=0,y=0;
reg cin=0;
reg [3:0] Fault_loc=0;
reg [5:0] Fault_type=0;
wire P_F;
wire [16:0] z;
TOP dut(Clk,Rst,En,Test,x,y,cin,Fault_loc,Fault_type,P_F,z);
always #5 Clk=~Clk;
integer loc,pin,val,k,normal_bad=0,detect_bad=0,repair_bad=0,loc_bad=0;
reg [16:0] expected;
task tick;
begin @(posedge Clk); #1; end
endtask
task reset;
begin
  @(negedge Clk); Rst=1; En=0; Test=0; Fault_type=0;
  tick; @(negedge Clk); Rst=0; tick;
end
endtask
initial begin
  reset;
  for(k=0;k<100;k=k+1)begin
    @(negedge Clk); x=(k*659+17);y=(k*997+63);cin=k%2;
    expected={1'b0,x}+{1'b0,y}+cin;tick;tick;
    if(z!==expected)normal_bad=normal_bad+1;
  end
  reset;
  @(negedge Clk); Test=1; En=1;
  repeat(12)tick;
  $display("GOOD_FLAG %0d",P_F);
  for(loc=0;loc<16;loc=loc+1)
    for(pin=1;pin<=5;pin=pin+1)
      for(val=0;val<=1;val=val+1)begin
        reset;
        @(negedge Clk);Fault_loc=loc;Fault_type=(1<<pin)|val;Test=1;En=1;
        repeat(12)tick;
        if(P_F!==1'b1)begin
          detect_bad=detect_bad+1;
          $display("DETECTION_FAIL loc=%0d pin=%0d value=%0d",loc,pin,val);
        end
        LOCATION_CHECK
        @(negedge Clk);En=0;Test=0;
        x=16'd1300;y=16'd56;cin=1;
        repeat(3)tick;
        REPAIR_CHECK
      end
  $display("RESULT normal_bad=%0d detection_bad=%0d location_bad=%0d repair_bad=%0d faults=160",normal_bad,detect_bad,loc_bad,repair_bad);
  $finish;
end
endmodule
'''

LFSR_TB = r'''
`timescale 1ns/1ps
module audit_tb;
reg clk=0,rst_n=1,en=0;
wire [5:0] out;
reg [63:0] seen=0;
integer i,duplicates=0,sum=0;
LFSR dut(clk,rst_n,en,out);
always #5 clk=~clk;
initial begin
  #1 rst_n=0; #1;
  @(negedge clk);rst_n=1;
  for(i=0;i<63;i=i+1)begin
    #1;if(seen[out])duplicates=duplicates+1;
    seen[out]=1;sum=sum+out;
    en=1;@(negedge clk);
  end
  #1;
  $display("RESULT unique_nonzero=%0d duplicates=%0d zero_seen=%0d sum=%0d returned_seed=%0d",$countones(seen),duplicates,seen[0],sum,out==1);
  $finish;
end
endmodule
'''

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--iverilog', default='iverilog')
    ap.add_argument('--vvp', default='vvp')
    ap.add_argument('--output', type=Path)
    ap.add_argument('--case', default='', help='Only run cases whose name contains this text.')
    ap.add_argument('--fail-on-functional-errors', action='store_true', help='Exit 1 for observed arithmetic, location, or repair errors as well.')
    args=ap.parse_args()
    for name in [args.iverilog,args.vvp]:
        if not shutil.which(name):ap.error(f'Executable not found: {name}')
    report={"scope":"RTL simulation of preserved student sources; failures are retained", "tests":[]}
    with tempfile.TemporaryDirectory(prefix='cedar-verification-') as td:
        temp=Path(td)
        def run(name,top,sources,extra='',monitor=False):
            if args.case and args.case not in name:return None
            files=[str(ROOT/p) for p in sources]
            if extra:
                tb=temp/(name+'.v');tb.write_text(extra,encoding='ascii');files.append(str(tb))
            compiled=temp/(name+'.vvp')
            print('Running '+name,flush=True)
            c=subprocess.run([args.iverilog,'-g2012','-Wall','-s',top,'-o',str(compiled),*files],capture_output=True,text=True,timeout=30)
            r={"name":name,"compile_exit":c.returncode,"compiler_messages":c.stderr}
            if c.returncode==0:
                try:v=subprocess.run([args.vvp,str(compiled)],capture_output=True,text=True,timeout=30)
                except subprocess.TimeoutExpired as exc:
                    r.update(run_exit=124,output=(exc.stdout or b'').decode('utf-8',errors='replace') if isinstance(exc.stdout,bytes) else (exc.stdout or ''),stderr='Simulation exceeded 30 seconds.')
                    report['tests'].append(r)
                    return r
                # Remove host-specific absolute file paths emitted by Icarus $finish.
                r.update(run_exit=v.returncode,output='\n'.join(line for line in v.stdout.splitlines() if '$finish called' not in line),stderr=v.stderr)
            report['tests'].append(r)
            return r
        for kind,top,src,tb in [
            ('bist','FullAdder_16bit_BIST','hw1_1.v','hw1_1_tb.v'),
            ('bisr','FullAdder_16bit_BISR','hw1_2.v','hw1_2_tb.v')]:
            run('original-'+kind,'HW1_tb' if kind=='bist' else 'HW1_2_tb',[f'hw1/code/{src}',f'hw1/code/{tb}'])
            t=ADDER_TB.replace('TOP',top)
            t=t.replace('LOCATION_CHECK', 'if(dut.FA_fault_loc!==Fault_loc)loc_bad=loc_bad+1;' if kind=='bisr' else '')
            t=t.replace('REPAIR_CHECK', 'if(z!==17\'d1357)begin repair_bad=repair_bad+1; $display("REPAIR_FAIL loc=%0d pin=%0d value=%0d result=%0d",loc,pin,val,z);end' if kind=='bisr' else '')
            run('sweep-'+kind,'audit_tb',[f'hw1/code/{src}'],t)
        for part in ['a','b']:
            run('original-signature-'+part,f'HW2_1_{part}_tb',[f'hw2/code/HW2_1_{part}.v',f'hw2/code/HW2_1_{part}_tb.v','hw2/code/Sub_module.v'])
            monitor=f'\nmodule observer; initial begin #180; $display("SIGNATURE %b",HW2_1_{part}_tb.signature);end endmodule\n'
            if args.case and args.case not in 'observed-signature-'+part:continue
            # A second root must be selected explicitly for the observer.
            src=temp/f'monitor-{part}.v';src.write_text(monitor,encoding='ascii')
            target=temp/f'monitor-{part}.vvp'
            c=subprocess.run([args.iverilog,'-g2012','-s',f'HW2_1_{part}_tb','-s','observer','-o',str(target),str(ROOT/f'hw2/code/HW2_1_{part}.v'),str(ROOT/f'hw2/code/HW2_1_{part}_tb.v'),str(ROOT/'hw2/code/Sub_module.v'),str(src)],capture_output=True,text=True,timeout=30)
            if c.returncode==0:
                v=subprocess.run([args.vvp,str(target)],capture_output=True,text=True,timeout=30)
                report['tests'].append({'name':'observed-signature-'+part,'compile_exit':0,'run_exit':v.returncode,'output':'\n'.join(s for s in v.stdout.splitlines() if '$finish called' not in s)})
            else:report['tests'].append({'name':'observed-signature-'+part,'compile_exit':c.returncode,'compiler_messages':c.stderr})
        run('original-lfsr','LFSR_tb',['hw3/code/LFSR.v','hw3/code/LFSR_tb.v'])
        run('lfsr-uniqueness','audit_tb',['hw3/code/LFSR.v'],LFSR_TB)
        run('legacy-bist','HW1_tb',['hw1/code/legacy-bist-project/HW1.v','hw1/code/legacy-bist-project/HW1_tb.v'])
        run('legacy-bisr','HW1_2_tb',['hw1/code/legacy-bisr-project/HW1_2.v','hw1/code/legacy-bisr-project/hw1_2_tb.v'])
        run('legacy-alternate-bisr-elaboration','FullAdder_16bit_BISR',['hw1/code/legacy-bist-project/hw1_2.v'])
    for item in report['tests']:
        for key in ['compiler_messages','output','stderr']:
            if key in item:item[key]=item[key].replace(str(ROOT)+'\\','').replace(str(ROOT)+'/','')
        matches=re.search(r'RESULT normal_bad=(\d+) detection_bad=(\d+) location_bad=(\d+) repair_bad=(\d+) faults=(\d+)',item.get('output',''))
        if matches:item['counts']=dict(zip(['normal_bad','detection_bad','location_bad','repair_bad','faults'],map(int,matches.groups())))
    report['functional_errors_observed']=sum(sum(n for k,n in item.get('counts',{}).items() if k.endswith('_bad')) for item in report['tests'])
    report['exit_policy']='Default exit status tests execution only. Use --fail-on-functional-errors to fail for the preserved reference bugs.'
    data=json.dumps(report,indent=2)
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True);args.output.write_text(data+'\n',encoding='utf-8')
    print(data)
    return 1 if any(t.get('compile_exit') or t.get('run_exit') for t in report['tests']) or (args.fail_on_functional_errors and report['functional_errors_observed']) else 0

if __name__=='__main__':raise SystemExit(main())

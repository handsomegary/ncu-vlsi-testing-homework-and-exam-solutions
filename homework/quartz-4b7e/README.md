# Student reference: Quartz-4b7e

This anonymous collection preserves three homework submissions as student references. The original RTL and C++ source are retained, including documented mistakes. They are not certified solutions to every question.

Each `hwN` directory contains:

- `homework_N.pdf`: the original assignment PDF, unchanged byte for byte.
- `student-reference-original.pdf`: the student's original report layout, with identifying text actually removed by PDF redaction and document metadata replaced.
- `report-tex/main.tex` and `student-reference.pdf`: an editable English reconstruction and its compiled PDF. Equations, tables, and block diagrams replace the report's screenshots and handwritten material. The original report remains available for comparison.
- `source/`: all submitted Verilog dependencies and testbenches. HW3 also retains the C++ syndrome simulator source.

The collection contains 16 Verilog files and one C++ file. The extensionless compiled HW3 executable is omitted. No Vivado project file, simulator cache, generated waveform, or build output is required from the original environment.

## Findings

| Area | Verification result and practical limit |
| --- | --- |
| HW1 full adder and RCA | Arithmetic equations can be checked independently. The retained RCA deliberately forces the first cell's carry to one in test mode. |
| HW1 BIST | The counter advances while `En=0`. The P/F bit describes individual cycles and resets to zero after checking, so a detected failure can disappear. Patterns miss first-cell input triples `001` and `110`, preventing a claim of complete arbitrary single-cell fault coverage. |
| HW1 internal fault example | `w2/0` is undetected by the five vectors, as reported. The report's additional claims for `A/0` and `w1/0` are false: input `100` detects the former, and `001` detects the latter at the sum output. |
| HW1 collapsed fault list | The report's nine-fault list is preserved as a student claim. This collection does not present its drawing as an independently proven minimal list. |
| HW2 serial simulation | The four reported detected sets agree with the explicit 13-line model; their union contains 10 of 26 faults (38.46%). |
| HW2 multiplexer convention | The statement's prose and drawing use inconsistent input labeling. The report and reconstruction follow the drawing: select zero chooses the input marked zero. |
| HW3 signature circuit | The supplied RTL does not match the original statement's truth table. For example `0001` produces zero in the RTL and one in the statement. |
| HW3 signature values | For the retained RTL and zero seed, the chronological good/faulty streams are `000010001000111` / `000000000000101`, with signatures `0011` / `1010` in `(D0,D1,D2,D3)` order. The faulty signature contradicts the report's text. |
| HW3 C++ syndrome simulation | The intended 0-to-14 fault loop produces the reported response streams. Both compactors miss only `d/1` in the seven-line model. The source retains memory leaks, an unused array, and an uninitialized return outside its intended fault-index domain. |

## Reproduce the checks

Install Python 3, a C++17 compiler, and Icarus Verilog (`iverilog` and `vvp`), then run from the repository root:

```sh
python homework/quartz-4b7e/verify.py
```

Compiler executable paths may be supplied with `--iverilog`, `--vvp`, and `--cxx`. `--json FILE` saves the results. The script uses temporary directories and leaves the original sources unchanged. A passing result means that the archived behavior and documented counterexamples were reproduced; it does not mean every student submission is correct.

The recorded run in `validation-results.json` passed 1,900 checks with Icarus Verilog 13 and a C++17 compiler, including all 32 input assignments with every HW2 single fault, thirty LFSR states, the C++ response streams, and the documented counterexamples.

The original testbenches use `$fsdbDumpfile` and `$fsdbDumpvars`, which need an FSDB-capable simulator or PLI. The verification script creates temporary smoke-test copies that omit only those waveform calls, and also runs separate assertion-based benches. No Vivado execution or synthesis result is claimed.

The C++ source can also be built alone:

```sh
g++ -std=c++17 -O2 homework/quartz-4b7e/hw3/source/HW3_2.cpp -o syndrome
./syndrome
```

To rebuild a report, enter its `report-tex` directory and run `pdflatex main.tex` twice. A standard TeX installation with TikZ, Latin Modern, and the packages listed in the preamble is sufficient.

`source-manifest.json` records original statement and source hashes. Anonymization intentionally changes the student-report PDFs; the original assignment PDFs retain their published teacher and course information.

# NCU VLSI Testing: Homework and Exam Solutions

Eight reconstructed examinations with independently derived solutions, and two anonymous collections of homework reports and source code. The editable documents use LaTeX and TikZ. Compiled PDFs are included for reading without a TeX installation.

## Exams

The 2009 file contains both a midterm and a final; they are reconstructed separately. Identical duplicate scans are represented once.

| Year | Midterm | Final |
| --- | --- | --- |
| 2009 | [PDF](exams/2009-midterm/main.pdf), [TeX](exams/2009-midterm/main.tex) | [PDF](exams/2009-final/main.pdf), [TeX](exams/2009-final/main.tex) |
| 2013 | [PDF](exams/2013-midterm/main.pdf), [TeX](exams/2013-midterm/main.tex) | [PDF](exams/2013-final/main.pdf), [TeX](exams/2013-final/main.tex) |
| 2014 | [PDF](exams/2014-midterm/main.pdf), [TeX](exams/2014-midterm/main.tex) | [PDF](exams/2014-final/main.pdf), [TeX](exams/2014-final/main.tex) |
| 2020 | — | [PDF](exams/2020-final/main.pdf), [TeX](exams/2020-final/main.tex) |
| 2021 | — | [PDF](exams/2021-final/main.pdf), [TeX](exams/2021-final/main.tex) |

Question statements, circuits, tables and solutions are rebuilt as text, equations and editable diagrams. Student annotations serve as references rather than answer keys. The new solutions state meaningful source ambiguities, fault models, seed/bit conventions and corrections to inconsistent printed questions. See the [exam catalog](exams/README.md).

## Homework

| Anonymous collection | Contents |
| --- | --- |
| [Cedar-8f2c](homework/cedar-8f2c/README.md) | HW1–HW3 original assignments, anonymized original reports, rebuilt reports, Verilog and testbenches; announcement updates and grading feedback transcribed from related screenshots |
| [Quartz-4b7e](homework/quartz-4b7e/README.md) | HW1–HW3 original assignments, anonymized original reports, rebuilt reports, Verilog and testbenches, plus the HW3 C++ implementation |

These collections use different assignment versions. Each retains its own original `homework_N.pdf` unchanged, so a report stays paired with its actual question. Student-report names, IDs, filenames and identifying metadata are removed. The original-layout anonymous report and its editable English reconstruction are both available. Referenced presentation diagrams and relevant JPEG announcements are reconstructed in the reports.

The student implementations retain their original logic, including documented bugs. Verification found real discrepancies: Cedar's BISR fails some location/repair cases; Quartz has BIST coverage/control limitations and an HW3 circuit that differs from its statement. Their collection READMEs give counterexamples and precise test scope. A green regression run means that the documented behavior and known failures were reproduced; it does not certify every student answer as correct.

## Run the checks

Install Python 3.9+, Icarus Verilog (`iverilog` and `vvp`), and a C++17 compiler. On Debian/Ubuntu, the simulator package is `iverilog`. Run from the repository root:

```sh
python tools/check_all.py
```

The runner supports `--iverilog`, `--vvp` and `--cxx` executable paths. It runs finite Boolean/fault checks for the examinations, 1,900 Quartz checks, and the Cedar source groups with an explicit expectation for the preserved BISR failures. Temporary build outputs are cleaned automatically. Individual collection READMEs explain the underlying commands and module groups.

The original Quartz benches contain proprietary `$fsdbDump*` waveform calls. The portable runner removes only those calls in temporary copies and supplies separate assertion-based checks. The archived sources remain intact. Vivado is not required for these RTL simulations; synthesis, timing and FPGA execution are outside the recorded checks.

## Rebuild the PDFs

A standard pdfLaTeX installation with TikZ and the packages in each preamble is sufficient. For example:

```sh
python tools/build_documents.py
```

The script builds all 14 TeX documents twice, writing results beneath `.build/documents/`. It leaves the committed PDFs untouched. Alternatively, enter any directory containing `main.tex` and run `pdflatex main.tex` twice.

Only source dependencies are needed. Vivado `.xpr` files, environment settings, caches, generated `glbl.v`, waveform databases, compiled executables and original source archives are omitted. The required Verilog modules, shared source files and testbenches are retained, with materially different legacy source sets kept in separate directories.

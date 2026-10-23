# Rebuilt examinations and independent solutions

Each directory contains editable main.tex and a compiled main.pdf.
Questions are rewritten in English, with circuits represented by redrawn logical
diagrams and explicit netlists. Solutions are independently derived; handwritten
student work is reference material rather than an answer key. Personal names,
student numbers and handwritten scans are not published here.

| Examination | Editable source | Rebuilt PDF |
| --- | --- | --- |
| 2009 midterm | [TeX](2009-midterm/main.tex) | [PDF](2009-midterm/main.pdf) |
| 2009 final | [TeX](2009-final/main.tex) | [PDF](2009-final/main.pdf) |
| 2013 midterm | [TeX](2013-midterm/main.tex) | [PDF](2013-midterm/main.pdf) |
| 2013 final | [TeX](2013-final/main.tex) | [PDF](2013-final/main.pdf) |
| 2014 midterm | [TeX](2014-midterm/main.tex) | [PDF](2014-midterm/main.pdf) |
| 2014 final | [TeX](2014-final/main.tex) | [PDF](2014-final/main.pdf) |
| 2020 final | [TeX](2020-final/main.tex) | [PDF](2020-final/main.pdf) |
| 2021 final | [TeX](2021-final/main.tex) | [PDF](2021-final/main.pdf) |

The two copies of the 2009 source are identical and are represented once, split
into their midterm and final examinations. The unnamed midterm PDF and the 2014
midterm PDF are also identical. Separate answer sheets are not additional exams.

Build any document with a normal TeX distribution including TikZ:

    cd exams/2013-final
    pdflatex -interaction=nonstopmode -halt-on-error main.tex
    pdflatex -interaction=nonstopmode -halt-on-error main.tex

The problem order is preserved by topic; related short-answer subquestions
are grouped into sections. In the 2013 final, the repair section covers original
questions 8 and 9, and the fuse section covers original question 10.

## Reproducible finite checks

    python exams/verify.py

The script uses only the Python standard library. It enumerates all inputs of
the reconstructed 2009 and 2013/2014 full-scan combinational circuits, including
both signal-stem and individual gate-input-branch stuck-at faults. The displayed
sets detect 46/46 and 54/54 modeled faults respectively, including identity
buffers representing the separately observed D-pin branches. It also computes SCOAP
tables, simulates the two LFSR realizations, and checks the XOR UDL, deductive
fault examples, hidden mux fault, dominance sets and constant-size adder tests.
These checks establish the stated Boolean models; they are not transistor-level,
timing or production-silicon signoff.

## Explicit reading corrections

- The 2009 midterm prints y/0 and has a handwritten change to y/1; both are
  solved. Its mux question similarly has an outputs/inputs correction; both
  interpretations are given.
- In the 2013 midterm mux figure, both first-level muxes have identical data and
  select inputs. The marked fault on the final select is unobservable. The 2014
  figure instead marks a first-level select branch, which is testable.
- The 2013/2014 final request to detect interconnect SA0 by driving 0000 is
  inconsistent: 1111 activates SA0, while 0000 activates SA1.
- LFSR answers state the zero seed, stage numbering, clock convention and lack
  of extra flush cycles. Physical state signatures differ between equivalent
  distributed-feedback and input-feedback encodings.
- The fixed 2013/2014 three-bit TAM connects internal chains 1→3 and 2→4, giving
  360 shift clocks. The 240-clock free-routing bound requires connectivity
  absent from the figure.
- The 2009 SRAM defect drawing is interpreted explicitly as an access-device
  bridge and an open pull-up path. A retention test needs a specified hold
  interval; no numerical SRAM retention requirement is supplied in that exam.

## Background references

The numerical solutions are derived from the stated circuits. For the underlying
conventions and interfaces, see these primary teaching/manufacturer/standards sources:

- [Testability measures and SCOAP](https://ece-research.unm.edu/jimp/vlsi_test/slides/html/testability_measures.html).
- [Texas Instruments: JTAG/IEEE 1149.1 Design Considerations](https://www.ti.com.cn/cn/lit/an/scta029/scta029.pdf), for boundary-cell access and TAP control.
- [Intel/Altera: IEEE 1149.1 Boundary-Scan Testing](https://cdrdv2-public.intel.com/655055/max2_mii51014.pdf), for the TAP state machine and five-clock TMS reset.
- [IEEE 1500 standard overview](https://standards.ieee.org/ieee/1500/7704/), for the embedded-core wrapper scope.

Course-specific opcode assumptions in an old question are retained and identified;
they should not be substituted for a real device's BSDL or wrapper documentation.

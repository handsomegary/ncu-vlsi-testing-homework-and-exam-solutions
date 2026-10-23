# Validation record

The archive was checked on 2026-10-23. All eight examinations and six rebuilt homework reports compiled with pdfLaTeX twice and were rendered for visual inspection. The 14 editable documents contain 66 pages. The six anonymous original-layout student reports contain another 30 pages and received independent visual privacy checks, including embedded code and waveform screenshots.

The six original assignment PDFs match their source files byte for byte. The Quartz manifest also preserves the hashes of all 17 submitted implementation files. Cedar's publication normalizes source comments and encoding without changing RTL logic. Both collections retain all required source modules and testbenches; materially different legacy sources compile as separate groups.

`python tools/check_archive.py` checks required documents and the original-file hashes. `python tools/check_all.py` runs the reproducible finite models and RTL/C++ regressions. The collection-level READMEs and recorded JSON files give the detailed scope.

| Area | Recorded result |
| --- | --- |
| Examination models | Exhaustive full-scan checks detect 46/46 or 54/54 faults in the stated circuit models; SCOAP, LFSR, mux, deductive-fault and adder calculations are independently evaluated |
| Recent finals | Five scan vectors detect 54/54 modeled faults; no four-vector set suffices; March C-minus detects the 28 enumerated two-cell faults; five high TMS clocks reset all 16 TAP states |
| Cedar BIST | Normal directed arithmetic passes; all 160 supported pin stuck-at injections are detected |
| Cedar BISR | All 160 injections are detected, but 34 decoded locations disagree with the injection and 37 repaired calculations fail for the documented operand example |
| Cedar remaining work | Both reported HW2 signatures reproduce; the HW3 register has period 63 with 63 distinct nonzero states |
| Quartz | 1,900 checks reproduce the archived arithmetic, fault simulation, LFSR states, C++ streams and documented defects |

A passing regression means that the archived behavior and known counterexamples reproduce. It does not turn the original student implementations into corrected solutions. In particular, the Cedar default runner checks execution and reports functional failures; the aggregate runner additionally asserts the expected counterexample counts. `--fail-on-functional-errors` on the Cedar runner provides an explicitly failing exit status for the retained errors.

Icarus Verilog and a C++17 compiler were used for source validation. The original Quartz FSDB waveform calls are omitted only in temporary portable bench copies. No Vivado synthesis, timing analysis, FPGA execution or production-silicon coverage is claimed. The source-reading notes distinguish ambiguous or inconsistent old questions from confirmed numerical results.

The GitHub workflow repeats the archive checks, simulations and all 14 LaTeX builds on Linux. Generated simulator files and TeX intermediates stay outside the tracked archive.

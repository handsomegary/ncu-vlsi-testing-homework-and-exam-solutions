# Cedar-8f2c student references

This anonymous collection preserves three homework submissions. It contains the original assignment PDFs, properly redacted copies of the student reports, editable LaTeX reconstructions with redrawn diagrams, and the submitted Verilog plus testbenches. The reconstructions translate the reports into English and label assignment updates, grading feedback, and later verification separately.

| Homework | Original assignment | Anonymized report | Editable reconstruction |
|---|---|---|---|
| 1: BIST and BISR | [PDF](hw1/homework_1.pdf) | [PDF](hw1/student-report-anonymized.pdf) | [TeX](hw1/report/main.tex), [PDF](hw1/report/main.pdf) |
| 2: Signature analysis | [PDF](hw2/homework_2.pdf) | [PDF](hw2/student-report-anonymized.pdf) | [TeX](hw2/report/main.tex), [PDF](hw2/report/main.pdf) |
| 3: Scan testing and LFSR | [PDF](hw3/homework_3.pdf) | [PDF](hw3/student-report-anonymized.pdf) | [TeX](hw3/report/main.tex), [PDF](hw3/report/main.pdf) |

The student sources remain reference implementations, including observed errors. They have not been silently corrected. See [verification](verification/README.md) and the reproducible [driver](verification/run_checks.py).

## Source selection

- `hw1/code/` contains the four submitted files. Identical copies from the submission folder are represented once. Two separate legacy project source sets retain different testbenches; one includes an earlier, materially different BISR implementation. See [source details](hw1/code/README.md).
- `hw2/code/` contains both top modules, both testbenches, and the shared `Sub_module.v`. The project source copies match these files.
- `hw3/code/` contains `LFSR.v` and `LFSR_tb.v`. The differently named project copy is identical to `LFSR.v`.

Source comments and encoding are normalized for publication, without changing the submitted RTL logic. No `.xpr`, build caches, generated `glbl.v`, simulator databases, or environment files are needed. Original screenshots and the presentation are not published because they can carry identities. Their relevant technical content is preserved as prose, tables, and editable diagrams in the reconstructions.

## Assignment updates and feedback

The source JPEG announcements clarify that HW1's test patterns must originate in the BIST, HW2's printed F column contains errors, and HW3 Q2 permits only two scan paths. HW3's later LFSR instructions accept the ordinary 63 nonzero states, although the original PDF requests 64 states.

The anonymous HW3 grading feedback objects to the added scan I/O overhead in Q1(b) and to adding block pattern counts in Q2. The reconstructions preserve the student's original calculations and explain these objections explicitly.

## Rebuild and simulate

Each report uses ordinary pdfLaTeX and TikZ. From an individual `report/` directory, run `pdflatex main.tex` twice. The committed PDF is the compiled reconstruction.

Install Python 3 and Icarus Verilog, then run from this collection:

```sh
python verification/run_checks.py --output results.json
```

The driver compiles separate source sets and cleans its temporary compiled outputs. Its default exit code checks that simulations execute; inspect the result counts for functional errors. Add `--fail-on-functional-errors` for a failing exit status on the preserved BISR bugs. This validation uses Icarus Verilog 13.0, rather than Vivado synthesis or hardware testing.

## Verification findings

HW1 BIST passes 100 normal arithmetic examples and detects all 160 supported pin stuck-at injections. HW1 BISR detects those injections, but 34 decoded locations differ from the injected cell and 37 repaired calculations fail for the directed operand example `1300 + 56 + 1`. This is a limited directed test, rather than exhaustive arithmetic verification.

HW2 reproduces the reported signatures `1100` and `0101`. HW3's original testbench prints PASS, and an independent state-set check confirms 63 unique nonzero states, period 63, sum 2016, and no all-zero state. The handwritten scan sequences have not been independently simulated against a reconstructed gate-level FSM.

Student names and IDs are removed from report contents, filenames, PDF metadata, and source comments. The original assignment PDFs retain their original bytes, including the course attribution printed by their author.

# 2020 final: reconstructed questions and solutions

[Read the rebuilt PDF](main.pdf) or edit [main.tex](main.tex). The project includes `questions-1-4.tex`, `questions-5-6.tex`, and `question-7.tex`. Run `pdflatex main.tex` twice from this directory to rebuild it.

The three supplied question pages are rebuilt as seven questions with all listed subparts. The supplied student's handwritten work is only a reference. The solutions are independently reasoned, and no student identity or handwritten answer image is published. Two additional handwritten pages with no corresponding question on the supplied exam are not turned into invented questions.

The reconstruction includes editable diagrams for BISR, fuse sensing, BILBO boundaries, wrapped-core organization, and TAM routing. The TAP state machine is preserved as a complete transition table. The exact BILBO gate network is specified by Boolean next-state equations so the NOR inversions and selector convention are explicit.

Key corrections and qualifications:

- Q2 uses four standard eight-bit backgrounds and a full March C-minus pass for each, totaling 40N word operations.
- Q4 distinguishes soft, firm, and hard repair configuration, and explains the fuse precharge/evaluate/capture sequence.
- Q5(a) has consistent read expectations only in candidates 3 and 4. Q5(b) selects tests 1 and 3. Test 2 lacks observation of the final downward transition.
- Q6's control pairs follow the displayed NOR/XOR network. The pattern-source use requires parallel inputs to be zero or isolated. The update is affine. The linear characteristic polynomial is `x^4+x^2+x+1` with the stated state ordering, and its reciprocal tap expression is `x^4+x^3+x^2+1`.
- Q7 distinguishes the data-register multiplexer `p` from the final instruction/data multiplexer `q`. The latter selects IR in Shift-IR and DR in Shift-DR. It is not assigned a TDO-enable expression.
- The shown fixed TAM routing has two 360-bit internal scan paths, chains 1->3 and 2->4. A 240-bit three-lane packing needs a different crossbar and is not an implementation of this figure. Pattern count and extra wrapper overhead are not numerically specified.

Finite-model checks for March consistency, both transition polarities, the conventional two-cell March C-minus fault cases, and reset from all 16 TAP states are available in the repository's [checker](../../tools/check_recent_exams.py). The TAM conclusion follows a direct mux-connection trace, rather than unrestricted lane packing. The partially obscured BILBO control convention is stated in the solution and cross-checked against a clearer matching supplied circuit.

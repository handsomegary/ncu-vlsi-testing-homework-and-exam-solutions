# RTL verification

`run_checks.py` requires Python 3 and Icarus Verilog. It compiles into a temporary directory and executes the retained submitted and legacy source sets separately. It does not need Vivado, an `.xpr` file, generated simulator files, or proprietary waveform tools.

```sh
python run_checks.py --output results.json
python run_checks.py --case sweep-bisr --fail-on-functional-errors
```

The default exit status indicates whether compilation and simulation completed. **It does not indicate that the student RTL is functionally correct.** `--fail-on-functional-errors` returns failure when the directed arithmetic, detection, location, or repair checks observe errors. The original source remains unchanged so known bugs are reproducible.

The recorded run uses Icarus Verilog 13.0 with `-g2012 -Wall`.

| Check | Observation |
|---|---|
| Original BIST/BISR testbenches | Compile and finish |
| BIST, 100 normal examples | 0 wrong sums |
| BIST, good circuit | P/F remains 0 |
| BIST, 16 stages x 5 pins x 2 values | 160 of 160 detected |
| BISR, 100 normal examples | 0 wrong sums |
| BISR, good circuit | P/F remains 0 |
| BISR, 160 pin faults | 160 detected, 34 location mismatches |
| BISR, post-test `1300+56+1` | 37 incorrect results among 160 injections |
| Original HW2 good/faulty testbenches | Final signatures 1100 / 0101 |
| Original HW3 testbench | PASS |
| Independent HW3 state-set check | 63 unique nonzero states, no duplicates, sum 2016, returns to seed |
| Legacy source sets | Compile and execute separately; no broad correctness claim |

For the fault sweep, pin index 1 is carry-out, 2 is sum, 3 is carry-in, 4 is Y, and 5 is X. The forced value is zero or one. Each fault starts from reset. Test mode runs for 12 rising edges, followed by normal mode and the directed repaired arithmetic example. The failure lines report the exact cell, pin, value, and result.

These checks cover the source's ten pin stuck-at faults per full adder. They do not establish coverage of arbitrary cell-functional faults or all post-repair operands. A carry-out fault can propagate to the next sum position, so the first differing sum bit cannot always identify the original physical cell. The BISR source also has directed carry-routing limitations; its per-stage repair logic requires correction before it can be relied upon.

HW2's shared source compiles with a warning for implicitly declared wire `b` inside `CUT_fault`. The original testbench changes some data and reset/enable signals on active clock edges, so the reported matching signatures establish this Icarus run rather than portability across all event-ordering choices.

HW3's stronger checker verifies a state set, instead of using only the original sum test. Its 63-state period follows the later assignment clarification. It does not meet the original PDF's distinct requirement of 64 states. The handwritten scan vectors, synthesis behavior, timing closure, and physical implementation are outside these checks.

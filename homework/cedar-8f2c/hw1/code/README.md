# HW1 source sets

Compile each set separately because module names overlap.

| Set | Sources | Top |
|---|---|---|
| Submitted BIST | `hw1_1.v`, `hw1_1_tb.v` | `HW1_tb` |
| Submitted BISR | `hw1_2.v`, `hw1_2_tb.v` | `HW1_2_tb` |
| Legacy BIST project | `legacy-bist-project/HW1.v`, `legacy-bist-project/HW1_tb.v` | `HW1_tb` |
| Legacy BISR project | `legacy-bisr-project/HW1_2.v`, `legacy-bisr-project/hw1_2_tb.v` | `HW1_2_tb` |
| Earlier BISR source | `legacy-bist-project/hw1_2.v` alone | `FullAdder_16bit_BISR` |

The primary four files are the submitted versions. A second top-level copy is identical and is represented once. The legacy `HW1.v` and `HW1_2.v` have the same executable RTL as the submitted BIST and BISR after comments and whitespace are removed, while their project testbenches differ.

The earlier BISR file has material differences, including a duplicated connection to `x_BISR` where `y_BISR` should be connected, missing pattern/comparison counter gating, and a different carry expression. It is preserved as a legacy reference. It is not the source set used for the main results, and it must not be combined with the submitted implementation.

For example, from this directory:

```sh
iverilog -g2012 -s HW1_tb -o bist.vvp hw1_1.v hw1_1_tb.v
vvp bist.vvp
iverilog -g2012 -s HW1_2_tb -o bisr.vvp hw1_2.v hw1_2_tb.v
vvp bisr.vvp
```

The original testbenches mainly provide waveforms. Use `../../verification/run_checks.py` for directed checks that print arithmetic, detection, location, and repair counts. The Verilog logic remains unchanged, including the known BISR failures described in the collection README.

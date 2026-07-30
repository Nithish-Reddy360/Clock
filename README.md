# FPGA Digital Clock (Basys 3)

A Verilog implementation of a **digital clock** on the **Xilinx Basys 3 FPGA** (Artix-7). The clock supports **24-hour timekeeping**, dual display modes (HH:MM / MM:SS), user time configuration via switches and buttons, and input validation with error detection.

---

## Features

- **24-Hour Timekeeping:** Tracks hours, minutes, and seconds using BCD (Binary-Coded Decimal) logic.
- **Dual Display Modes:**
  - **Mode 0:** Display **HH : MM** (Hours and Minutes).
  - **Mode 1:** Display **MM : SS** (Minutes and Seconds).
- **Time Setting / Loading:** Load hours or minutes using the onboard 8-bit switches.
- **Error Validation:** Detects invalid time inputs (e.g., hours > 23 or minutes > 59) and illuminates an error LED (`err_led`) to prevent loading invalid values.
- **Multiplexed 7-Segment Display:** Smoothly refreshes the four-digit 7-segment display on the Basys 3 board.
- **Enable / Pause:** Toggle the clock increment using the enable switch (`ena`).

---

## Hardware Pin Mapping (Basys 3)

| Port Name | Basys 3 Component | Pin Location | Description |
|---|---|---|---|
| `clk` | 100 MHz Oscillator | `W5` | System Clock |
| `reset` | Center Button (`BTNC`) | `U18` | System Reset |
| `load_h` | Top Button (`BTNU`) | `T18` | Load Hours from Switches |
| `load_m` | Left Button (`BTNL`) | `W19` | Load Minutes from Switches |
| `sw[7:0]` | Switches 7 to 0 | `W13` down to `V17` | Input BCD values (Switches 7–4: Tens, Switches 3–0: Units) |
| `mode` | Switch 15 | `R2` | Display Mode (`0` = HH:MM, `1` = MM:SS) |
| `ena` | Switch 14 | `T1` | Clock Enable / Pause |
| `err_led` | LED 0 | `U16` | Lights up on invalid input |
| `seg[7:0]` | 7-Segment Cathodes | `W7` to `V7` | Segment control (A–G, DP) |
| `an[3:0]` | 7-Segment Anodes | `W4`, `V4`, `U4`, `U2` | Digit Selection |

---

## File Structure

```text
.
├── top_module.v       # Top-level Verilog source code
├── Basys3_Master.xdc  # Vivado Constraints File
└── tb_top.v           # Testbench for simulation

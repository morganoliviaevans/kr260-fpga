# kr260-fpga

FPGA image for the AMD/Xilinx Kria KR260 Robotics Starter Kit.

## Tool Dependencies

Developed on Ubuntu 24.04 (x86_64).

| Tool     | Version  | Notes                                              |
|----------|----------|----------------------------------------------------|
| Vivado   | 2025.2   | Free tier covers the K26; see note below           |
| GNU Make | 4.3      | `sudo apt install make`                            |
| Git      | 2.43     | Clean-tree check in `make build`; `make clean`     |

Other dependencies will be added here as they come up. `vivado` must be on
your `PATH` (e.g. `source /tools/Xilinx/2025.2/Vivado/settings64.sh`).

Vivado is pinned to 2025.2 on purpose: from 2026.1, AMD's licensing requires a
paid tier for the K26, and the free tier can't target it.

## Repository Layout

```
rtl/    SystemVerilog sources (kr260_top.sv is the top level)
syn/    Constraints: pin decode layers (.xdc), io_ports.tcl, timing.tcl
tcl/    Project/build scripts and the Vivado-exported bd.tcl
rdl/    SystemRDL register descriptions for PeakRDL (placeholder)
out/    Checked-in build results: bitstream/ (.bit/.bin/.xsa), reports/, logs/
build/  Vivado working area (generated, git-ignored)
temp/   Local scratch, e.g. reference PDFs (git-ignored, kept by make clean)
```

`tcl/bd.tcl` is always exported from Vivado; make block design changes in the
GUI and re-export. `tcl/project.tcl` is hand-maintained and kept minimal.

## Building

### GUI

```sh
make gui
```

Creates the project in `build/gui/` (if it doesn't already exist) and opens it
in Vivado. After editing the block design, run `dump_bd` in the Vivado Tcl
console to validate it and export it back to `tcl/bd.tcl` before committing.

`make clean` deletes everything git ignores except `temp/`, including the
project, so the next `make gui` recreates it from sources.

### Headless

```sh
make build
```

Recreates the project from scratch in `build/batch/`, runs through bitstream
generation, and copies build products and reports into `out/`. Set `JOBS=N` to
control run parallelism (default 8).

The build refuses to run with uncommitted changes (anything outside `out/`), so
every checked-in result traces back to a commit. `out/README.md` records that
commit, the branch, timestamps, Vivado version, and host. To build anyway while
iterating, use `make build ALLOW_DIRTY=1`; the provenance is then marked dirty
and lists the uncommitted files.

## Pin Constraints

Pins are resolved through three decode layers in `syn/`, each a list of Tcl
variables built from the one before it:

| File                 | Maps                                  | Example                                          |
|----------------------|---------------------------------------|--------------------------------------------------|
| `k26_fpga.xdc`       | FPGA pin name → package pin           | `IO_L11P_AD9P_45` → `A12`                        |
| `k26_som.xdc`        | SOM connector signal → FPGA pin name  | `som240_1_c24` → `IO_L11P_AD9P_45`               |
| `kr260_carrier.xdc`  | Carrier signal → SOM connector signal | `FAN_EN_B_HDA20` → `som240_1_c24`                |

`io_ports.tcl` then constrains top-level ports using carrier names only:

```tcl
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO1_HDA11}" [get_ports {PMOD1[0]}]
```

The SOM layers come from AMD XTP685 (K26 SOM XDC); the carrier layer from XTP743
(KR260 carrier schematic). The carrier layer currently covers the fan, PMOD1–4,
and the Raspberry Pi header; to use another carrier signal, add it there first.

## Current Build

Bring-up image: the PS plus a few PL signals to prove the board and the build
flow end to end.

- **Fan** (`FAN_EN_B`): driven by the PS (TTC0), as in the AMD example design.
- **PMOD LED chasers**: each PMOD header walks a single lit LED across its 8
  pins (IO1 → IO8, then back to IO1), clocked off `CLK100`. Each header runs at
  its own speed; a full lap is all 8 LEDs traversed.

  | PMOD  | Step time | Full lap (8 LEDs) |
  |-------|-----------|-------------------|
  | PMOD1 | 200 ms    | 1.6 s             |
  | PMOD2 | 400 ms    | 3.2 s             |
  | PMOD3 | 800 ms    | 6.4 s             |
  | PMOD4 | 1.6 s     | 12.8 s            |

  PMOD pins drive 3.3 V (LVCMOS33); use a series resistor (~220–330 Ω) on each
  LED.
- **AXI IIC / AXI SPI**: present in the block design but not wired to any pins.

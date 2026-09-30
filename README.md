# kr260-fpga

FPGA image for the AMD/Xilinx Kria KR260 Robotics Starter Kit.

## Tool Dependencies

Developed on Ubuntu 24.04 (x86_64).

| Tool     | Version  | Notes                            |
|----------|----------|----------------------------------|
| Vivado   | 2025.2   |                                  |
| GNU Make | 4.3      | `sudo apt install make`          |
| Git      | 2.43     | `make clean` uses `git clean`    |

Other dependencies will be added here as they come up. `vivado` must be on
your `PATH` (e.g. `source /tools/Xilinx/2025.2/Vivado/settings64.sh`).

## Repository Layout

```
rtl/    SystemVerilog sources (kr260_top.sv is the top level)
syn/    Constraints: pin decode layers (k26_fpga, k26_som, kr260_carrier .xdc),
        io_ports.tcl, timing.tcl
tcl/    Project/build scripts and the Vivado-exported bd.tcl
rdl/    SystemRDL register descriptions (PeakRDL)
out/    Checked-in build products (.bit/.bin/.xsa) and reports
build/  Vivado working area (generated, git-ignored)
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
console to validate it and export it back to `tcl/bd.tcl` before committing. `make clean` deletes the project so the next `make gui`
recreates it from sources.

### Headless

```sh
make build
```

Recreates the project from scratch in `build/batch/`, runs through bitstream
generation, and copies build products and reports into `out/`. Set `JOBS=N` to
control run parallelism (default 8).

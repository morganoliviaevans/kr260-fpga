# kr260-fpga

FPGA image for the AMD/Xilinx Kria KR260 Robotics Starter Kit.

## Tool Dependencies

| Tool   | Version  | Notes           |
|--------|----------|-----------------|
| Vivado | 2026.1.1 | Ubuntu (x86_64) |

Other dependencies will be added here as they come up. `vivado` must be on
your `PATH` (e.g. `source <install>/Vivado/2026.1.1/settings64.sh`).

## Repository Layout

```
rtl/    SystemVerilog sources (kr260_top.sv is the top level)
syn/    Constraints, sourced as Tcl: io_ports.tcl, timing.tcl
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
in Vivado. After editing the block design, export it back to `tcl/bd.tcl`
before committing. `make clean` deletes the project so the next `make gui`
recreates it from sources.

### Headless

```sh
make build
```

Recreates the project from scratch in `build/batch/`, runs through bitstream
generation, and copies build products and reports into `out/`. Set `JOBS=N` to
control run parallelism (default 8).

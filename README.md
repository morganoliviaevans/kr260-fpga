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

The PS plus PL logic on all four PMOD headers. Headers are shown head-on from
the board edge (same orientation as the guide in `syn/io_ports.tcl`); `-` means
unused. All PMOD pins are 3.3 V (LVCMOS33).

**PMOD1 (J2): `LED_DANCE`**

```
   +-----+-----+--------------+--------------+--------------+--------------+
   | 3V3 | GND | LED_DANCE[3] | LED_DANCE[2] | LED_DANCE[1] | LED_DANCE[0] |
   +-----+-----+--------------+--------------+--------------+--------------+
   | 3V3 | GND | LED_DANCE[7] | LED_DANCE[6] | LED_DANCE[5] | LED_DANCE[4] |
===+-----+-----+--------------+--------------+--------------+--------------+===
============================== KR260 Carrier PCB ==============================
```

A single lit LED walks `LED_DANCE[0]` → `[7]` and wraps, one step every
200 ms (a full lap of 8 LEDs in 1.6 s), clocked off `CLK100`. Use a series
resistor (~220–330 Ω) on each LED.

**PMOD2 (J18): `GPIO_EMIO`**

```
   +-----+-----+--------------+--------------+--------------+--------------+
   | 3V3 | GND | GPIO_EMIO[3] | GPIO_EMIO[2] | GPIO_EMIO[1] | GPIO_EMIO[0] |
   +-----+-----+--------------+--------------+--------------+--------------+
   | 3V3 | GND | GPIO_EMIO[7] | GPIO_EMIO[6] | GPIO_EMIO[5] | GPIO_EMIO[4] |
===+-----+-----+--------------+--------------+--------------+--------------+===
============================== KR260 Carrier PCB ==============================
```

EMIO GPIO bits 0–7 from the PS, as outputs only. Each pin is driven only while
the PS enables it as an output, and is high-Z otherwise; nothing is read back
(`gpio_emio_i` is tied to 0). In Linux, EMIO bit *n* is line 78 + *n* on the PS
GPIO controller (lines 0–77 are the MIO pins).

**PMOD3 (J19): I2C**

```
   +-----+-----+--------------+--------------+--------------+--------------+
   | 3V3 | GND |   I2C_SDA    |   I2C_SCL    |      -       |      -       |
   +-----+-----+--------------+--------------+--------------+--------------+
   | 3V3 | GND |      -       |      -       |      -       |      -       |
===+-----+-----+--------------+--------------+--------------+--------------+===
============================== KR260 Carrier PCB ==============================
```

Driven by the Xilinx AXI IIC core (v2.1,
[PG090](https://docs.amd.com/r/en-US/pg090-axi-iic)) at AXI base address
`0xA000_0000` (64 KB). The lines are open drain; the FPGA's internal pull-ups
are enabled as a fallback, but they're weak: fit external pull-ups
(~2.2–4.7 kΩ to 3.3 V).

**PMOD4 (J20): SPI**

```
   +-----+-----+--------------+--------------+--------------+--------------+
   | 3V3 | GND |   SPI_SCK    |   SPI_MISO   |   SPI_MOSI   |   SPI_CS_N   |
   +-----+-----+--------------+--------------+--------------+--------------+
   | 3V3 | GND |      -       |      -       |      -       |      -       |
===+-----+-----+--------------+--------------+--------------+--------------+===
============================== KR260 Carrier PCB ==============================
```

Driven by the Xilinx AXI Quad SPI core (v3.2, standard SPI mode, master,
[PG153](https://docs.amd.com/r/en-US/pg153-axi-quad-spi)) at AXI base address
`0xA001_0000` (64 KB). `SPI_CS_N`, `SPI_MOSI`, and `SPI_SCK` are driven only
while the core enables them, and are high-Z otherwise.

**Fan** (`FAN_EN_B`): driven by the PS (TTC0), as in the AMD example design.

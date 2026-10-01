# io_ports.tcl
#
# Pin assignments and I/O standards for kr260_top. Pins come from the decode
# layers (k26_fpga.xdc -> k26_som.xdc -> kr260_carrier.xdc), which must be
# read first. Sourced as an unmanaged Tcl constraint file in constrs_1.

# --- Fan header enable (active low) ---
set_property -dict "IOSTANDARD LVCMOS33  SLEW SLOW  DRIVE 4  PACKAGE_PIN ${FAN_EN_B_HDA20}" [get_ports FAN_EN_B]

# KR260 PMOD Header Physical Orientation Guide
#
#     +-----+-----+-----------+-----------+-----------+-----------+
#     | 3V3 | GND | PMOD*_IO4 | PMOD*_IO3 | PMOD*_IO2 | PMOD*_IO1 |
#     +-----+-----+-----------+-----------+-----------+-----------+
#     | 3V3 | GND | PMOD*_IO8 | PMOD*_IO7 | PMOD*_IO6 | PMOD*_IO5 |
#  ===+-----+-----+-----------+-----------+-----------+-----------+===
#  ======================== KR260 Carrier PCB ========================
#
# Port bits: PMODn[0] = IO1 ... PMODn[7] = IO8.
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO1_HDA11}"    [get_ports {PMOD1[0]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO2_HDA12}"    [get_ports {PMOD1[1]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO3_HDA13}"    [get_ports {PMOD1[2]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO4_HDA14}"    [get_ports {PMOD1[3]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO5_HDA15}"    [get_ports {PMOD1[4]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO6_HDA16_CC}" [get_ports {PMOD1[5]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO7_HDA17}"    [get_ports {PMOD1[6]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO8_HDA18}"    [get_ports {PMOD1[7]}]

set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO1_HDA02}"    [get_ports {PMOD2[0]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO2_HDA03}"    [get_ports {PMOD2[1]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO3_HDA04}"    [get_ports {PMOD2[2]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO4_HDA05}"    [get_ports {PMOD2[3]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO5_HDA06}"    [get_ports {PMOD2[4]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO6_HDA07}"    [get_ports {PMOD2[5]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO7_HDA08_CC}" [get_ports {PMOD2[6]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO8_HDA09}"    [get_ports {PMOD2[7]}]

set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD3_IO1_HDB00_CC}" [get_ports {PMOD3[0]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD3_IO2_HDB01}"    [get_ports {PMOD3[1]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD3_IO3_HDB02}"    [get_ports {PMOD3[2]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD3_IO4_HDB03}"    [get_ports {PMOD3[3]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD3_IO5_HDB04}"    [get_ports {PMOD3[4]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD3_IO6_HDB05}"    [get_ports {PMOD3[5]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD3_IO7_HDB06}"    [get_ports {PMOD3[6]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD3_IO8_HDB07}"    [get_ports {PMOD3[7]}]

set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO1_HDB08_CC}" [get_ports {PMOD4[0]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO2_HDB09}"    [get_ports {PMOD4[1]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO3_HDB10}"    [get_ports {PMOD4[2]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO4_HDB11}"    [get_ports {PMOD4[3]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO5_HDB12}"    [get_ports {PMOD4[4]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO6_HDB13}"    [get_ports {PMOD4[5]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO7_HDB14}"    [get_ports {PMOD4[6]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO8_HDB15}"    [get_ports {PMOD4[7]}]

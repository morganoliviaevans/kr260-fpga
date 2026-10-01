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

# --- PMOD1: LED_DANCE[0] = IO1 ... LED_DANCE[7] = IO8 ---
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO1_HDA11}"    [get_ports {LED_DANCE[0]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO2_HDA12}"    [get_ports {LED_DANCE[1]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO3_HDA13}"    [get_ports {LED_DANCE[2]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO4_HDA14}"    [get_ports {LED_DANCE[3]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO5_HDA15}"    [get_ports {LED_DANCE[4]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO6_HDA16_CC}" [get_ports {LED_DANCE[5]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO7_HDA17}"    [get_ports {LED_DANCE[6]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD1_IO8_HDA18}"    [get_ports {LED_DANCE[7]}]

# --- PMOD2: GPIO_EMIO[0] = IO1 ... GPIO_EMIO[7] = IO8 ---
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO1_HDA02}"    [get_ports {GPIO_EMIO[0]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO2_HDA03}"    [get_ports {GPIO_EMIO[1]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO3_HDA04}"    [get_ports {GPIO_EMIO[2]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO4_HDA05}"    [get_ports {GPIO_EMIO[3]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO5_HDA06}"    [get_ports {GPIO_EMIO[4]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO6_HDA07}"    [get_ports {GPIO_EMIO[5]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO7_HDA08_CC}" [get_ports {GPIO_EMIO[6]}]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD2_IO8_HDA09}"    [get_ports {GPIO_EMIO[7]}]

# --- PMOD3: I2C (internal pull-ups as a fallback; use external pull-ups) ---
set_property -dict "IOSTANDARD LVCMOS33  PULLUP TRUE  PACKAGE_PIN ${PMOD3_IO3_HDB02}" [get_ports I2C_SCL]
set_property -dict "IOSTANDARD LVCMOS33  PULLUP TRUE  PACKAGE_PIN ${PMOD3_IO4_HDB03}" [get_ports I2C_SDA]

# --- PMOD4: SPI ---
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO1_HDB08_CC}" [get_ports SPI_CS_N]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO2_HDB09}"    [get_ports SPI_MOSI]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO3_HDB10}"    [get_ports SPI_MISO]
set_property -dict "IOSTANDARD LVCMOS33  PACKAGE_PIN ${PMOD4_IO4_HDB11}"    [get_ports SPI_SCK]

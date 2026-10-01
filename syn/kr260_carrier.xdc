# kr260_carrier.xdc
#
# KR260 carrier card decode: carrier signal name to som240_* connector signal.
# Requires k26_fpga.xdc and k26_som.xdc to be sourced first. Extracted from
# AMD XTP743 KR260 carrier card schematic (rev A02): pages 6-7 (SOM240_1/2
# connectors), 3 (fan header), 10-11 (PMOD), 12 (Raspberry Pi header J21).

# --- PMOD header pinout (PMOD1-4 = J2, J18, J19, J20) ---
#
# All four headers are identical 2x6 right-angle sockets. Viewed head-on from
# the board edge, PCB at the bottom. Small numbers are schematic pin numbers
# (XTP743 pp. 10-11), which pair across rows rather than running along them.
#
#     +-------+-------+-------+-------+-------+-------+
#     |  3V3  |  GND  |  IO4  |  IO3  |  IO2  |  IO1  |
#     |   11  |    9  |    7  |    5  |    3  |    1  |
#     +-------+-------+-------+-------+-------+-------+
#     |  3V3  |  GND  |  IO8  |  IO7  |  IO6  |  IO5  |
#     |   12  |   10  |    8  |    6  |    4  |    2  |
#  ===+-------+-------+-------+-------+-------+-------+===
#  ======================= KR260 carrier PCB =========================

# PMOD1
set PMOD1_IO1_HDA11                ${som240_1_a17}
set PMOD1_IO2_HDA12                ${som240_1_d20}
set PMOD1_IO3_HDA13                ${som240_1_d21}
set PMOD1_IO4_HDA14                ${som240_1_d22}
set PMOD1_IO5_HDA15                ${som240_1_b20}
set PMOD1_IO6_HDA16_CC             ${som240_1_b21}
set PMOD1_IO7_HDA17                ${som240_1_b22}
set PMOD1_IO8_HDA18                ${som240_1_c22}

# PMOD2
set PMOD2_IO1_HDA02                ${som240_1_d18}
set PMOD2_IO2_HDA03                ${som240_1_b16}
set PMOD2_IO3_HDA04                ${som240_1_b17}
set PMOD2_IO4_HDA05                ${som240_1_b18}
set PMOD2_IO5_HDA06                ${som240_1_c18}
set PMOD2_IO6_HDA07                ${som240_1_c19}
set PMOD2_IO7_HDA08_CC             ${som240_1_c20}
set PMOD2_IO8_HDA09                ${som240_1_a15}

# PMOD3
set PMOD3_IO1_HDB00_CC             ${som240_2_d44}
set PMOD3_IO2_HDB01                ${som240_2_d45}
set PMOD3_IO3_HDB02                ${som240_2_d46}
set PMOD3_IO4_HDB03                ${som240_2_d48}
set PMOD3_IO5_HDB04                ${som240_2_d49}
set PMOD3_IO6_HDB05                ${som240_2_d50}
set PMOD3_IO7_HDB06                ${som240_2_c46}
set PMOD3_IO8_HDB07                ${som240_2_c47}

# PMOD4
set PMOD4_IO1_HDB08_CC             ${som240_2_c48}
set PMOD4_IO2_HDB09                ${som240_2_c50}
set PMOD4_IO3_HDB10                ${som240_2_c51}
set PMOD4_IO4_HDB11                ${som240_2_c52}
set PMOD4_IO5_HDB12                ${som240_2_b44}
set PMOD4_IO6_HDB13                ${som240_2_b45}
set PMOD4_IO7_HDB14                ${som240_2_b46}
set PMOD4_IO8_HDB15                ${som240_2_b48}

# RASPBERRY PI HEADER (J21)
set RPI_GPIO0_ID_SD_HDC00_CC       ${som240_2_d52}
set RPI_GPIO1_ID_SC_HDC01          ${som240_2_d53}
set RPI_GPIO2_SDA_HDC02            ${som240_2_d54}
set RPI_GPIO3_SCL_HDC03            ${som240_2_d56}
set RPI_GPIO4_GPCLK0_HDC04         ${som240_2_d57}
set RPI_GPIO5_HDC05                ${som240_2_d58}
set RPI_GPIO6_HDC06                ${som240_2_c54}
set RPI_GPIO7_CE1_HDC07            ${som240_2_c55}
set RPI_GPIO8_CE0_HDC08_CC         ${som240_2_c56}
set RPI_GPIO9_MISO_HDC09           ${som240_2_c58}
set RPI_GPIO10_MOSI_HDC10          ${som240_2_c59}
set RPI_GPIO11_SCLK_HDC11          ${som240_2_c60}
set RPI_GPIO12_PWM0_HDC12          ${som240_2_b52}
set RPI_GPIO13_PWM1_HDC13          ${som240_2_b53}
set RPI_GPIO14_TXD_HDC14           ${som240_2_b54}
set RPI_GPIO15_RXD_HDC15           ${som240_2_b56}
set RPI_GPIO16_HDC16_CC            ${som240_2_b57}
set RPI_GPIO17_HDC17               ${som240_2_b58}
set RPI_GPIO18_PCM_CLK_HDC18       ${som240_2_a54}
set RPI_GPIO19_PCM_FS_HDC19        ${som240_2_a55}
set RPI_GPIO20_PCM_DIN_HDC20       ${som240_2_a56}
set RPI_GPIO21_PCM_DOUT_HDC21      ${som240_2_a58}
set RPI_GPIO22_HDC22               ${som240_2_a59}
set RPI_GPIO23_HDC23               ${som240_2_a60}
set RPI_GPIO24_HDB20               ${som240_2_a48}
set RPI_GPIO25_HDB21               ${som240_2_a50}
set RPI_GPIO26_HDB22               ${som240_2_a51}
set RPI_GPIO27_HDB23               ${som240_2_a52}

# FAN HEADER (J13)
set FAN_EN_B_HDA20                 ${som240_1_c24}

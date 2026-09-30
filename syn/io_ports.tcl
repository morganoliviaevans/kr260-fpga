# io_ports.tcl
#
# Pin assignments and I/O standards for kr260_top. Pins come from the decode
# layers (k26_fpga.xdc -> k26_som.xdc -> kr260_carrier.xdc), which must be
# read first. Sourced as an unmanaged Tcl constraint file in constrs_1.

# --- Fan header enable (active low) ---
set_property PACKAGE_PIN $FAN_EN_B_HDA20 [get_ports fan_en_b]
set_property IOSTANDARD  LVCMOS33        [get_ports fan_en_b]
set_property SLEW        SLOW            [get_ports fan_en_b]
set_property DRIVE       4               [get_ports fan_en_b]

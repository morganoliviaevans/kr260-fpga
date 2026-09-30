// kr260_top.sv
//
// Top level for the KR260 FPGA image. Primarily a wrapper around the
// Vivado block design, with room for any fabric logic that lives outside it.

module kr260_top (
    output logic fan_en_b
);

    logic clk100;
    logic rstn100;

    // IIC and SPI buses are left floating for now: inputs tied off, outputs
    // and tristate enables unconnected.
    kr260 kr260_i (
        .AXI_IIC_scl_i (1'b0),
        .AXI_IIC_scl_o (),
        .AXI_IIC_scl_t (),
        .AXI_IIC_sda_i (1'b0),
        .AXI_IIC_sda_o (),
        .AXI_IIC_sda_t (),
        .AXI_SPI_io0_i (1'b0),
        .AXI_SPI_io0_o (),
        .AXI_SPI_io0_t (),
        .AXI_SPI_io1_i (1'b0),
        .AXI_SPI_io1_o (),
        .AXI_SPI_io1_t (),
        .AXI_SPI_sck_i (1'b0),
        .AXI_SPI_sck_o (),
        .AXI_SPI_sck_t (),
        .AXI_SPI_ss_i  (1'b0),
        .AXI_SPI_ss_o  (),
        .AXI_SPI_ss_t  (),
        .CLK100        (clk100),
        .FAN_EN_B      (fan_en_b),
        .RSTN100       (rstn100)
    );

endmodule

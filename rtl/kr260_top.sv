// kr260_top.sv
//
// Top level for the KR260 FPGA image. Primarily a wrapper around the
// Vivado block design, with room for any fabric logic that lives outside it.

module kr260_top (

    // KR260 PMOD
    output logic [7:0] PMOD1,
    output logic [7:0] PMOD2,
    output logic [7:0] PMOD3,
    output logic [7:0] PMOD4,

    // Fan Enable
    output logic       FAN_EN_B
);

    logic        clk100;
    logic        rstn100;

    // PS GPIO over EMIO
    logic [94:0] gpio_emio_i;
    logic [94:0] gpio_emio_o;
    logic [94:0] gpio_emio_t;

    // Temporarily Tie Off
    assign gpio_emio_i[94:0] = '0;

    // -------------------------------------------------------------------------
    // PMOD LED chasers
    //
    // Each PMOD walks a single lit LED around its 8 pins (PMODn[0] = IO1 ...
    // PMODn[7] = IO8), each at its own rate so they're easy to tell apart.
    // Step time per LED: PMOD1 200 ms (fastest), PMOD2 400 ms, PMOD3 800 ms,
    // PMOD4 1600 ms (slowest).
    // -------------------------------------------------------------------------
    localparam int unsigned CLK100_HZ = 100_000_000;

    function automatic int unsigned chase_step_ms(int idx);
        case (idx)
            0:       return 200;  // PMOD1
            1:       return 400;  // PMOD2
            2:       return 800;  // PMOD3
            default: return 1600; // PMOD4
        endcase
    endfunction

    logic [7:0] pmod_led [4];

    for (genvar g = 0; g < 4; g++) begin : g_chase
        localparam int unsigned STEP_TICKS = (CLK100_HZ / 1000) * chase_step_ms(g);

        logic [$clog2(STEP_TICKS)-1:0] tick_cnt;

        always_ff @(posedge clk100) begin
            if (!rstn100) begin
                tick_cnt    <= '0;
                pmod_led[g] <= 8'b0000_0001;
            end else if (tick_cnt == STEP_TICKS - 1) begin
                tick_cnt    <= '0;
                pmod_led[g] <= {pmod_led[g][6:0], pmod_led[g][7]};
            end else begin
                tick_cnt    <= tick_cnt + 1'b1;
            end
        end
    end

    assign PMOD1 = pmod_led[0];
    assign PMOD2 = pmod_led[1];
    assign PMOD3 = pmod_led[2];
    assign PMOD4 = pmod_led[3];

    // IIC and SPI buses are left floating for now: inputs tied off, outputs
    // and tristate enables unconnected.
    kr260 kr260_i (
        .AXI_IIC_scl_i   (1'b0),
        .AXI_IIC_scl_o   (),
        .AXI_IIC_scl_t   (),
        .AXI_IIC_sda_i   (1'b0),
        .AXI_IIC_sda_o   (),
        .AXI_IIC_sda_t   (),
        .AXI_SPI_io0_i   (1'b0),
        .AXI_SPI_io0_o   (),
        .AXI_SPI_io0_t   (),
        .AXI_SPI_io1_i   (1'b0),
        .AXI_SPI_io1_o   (),
        .AXI_SPI_io1_t   (),
        .AXI_SPI_sck_i   (1'b0),
        .AXI_SPI_sck_o   (),
        .AXI_SPI_sck_t   (),
        .AXI_SPI_ss_i    (1'b0),
        .AXI_SPI_ss_o    (),
        .AXI_SPI_ss_t    (),
        .GPIO_EMIO_tri_i (gpio_emio_i),
        .GPIO_EMIO_tri_o (gpio_emio_o),
        .GPIO_EMIO_tri_t (gpio_emio_t),
        .CLK100          (clk100),
        .FAN_EN_B        (FAN_EN_B),
        .RSTN100         (rstn100)
    );

endmodule

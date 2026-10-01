// kr260_top.sv
//
// Top level for the KR260 FPGA image. Primarily a wrapper around the
// Vivado block design, with room for any fabric logic that lives outside it.

module kr260_top (

    // PMOD1: LED chaser
    output logic [7:0] LED_DANCE,

    // PMOD2: PS GPIO over EMIO (output only)
    output logic [7:0] GPIO_EMIO,

    // PMOD3: I2C
    inout  wire        I2C_SCL,
    inout  wire        I2C_SDA,

    // PMOD4: SPI
    output logic       SPI_CS_N,
    output logic       SPI_MOSI,
    input  logic       SPI_MISO,
    output logic       SPI_SCK,

    // Fan Enable
    output logic       FAN_EN_B
);

    logic        clk100;
    logic        rstn100;

    // PS GPIO over EMIO
    logic [94:0] gpio_emio_i;
    logic [94:0] gpio_emio_o;
    logic [94:0] gpio_emio_t;

    // I2C
    logic        iic_scl_i, iic_scl_o, iic_scl_t;
    logic        iic_sda_i, iic_sda_o, iic_sda_t;

    // SPI
    logic        spi_ss_o,   spi_ss_t;
    logic        spi_mosi_o, spi_mosi_t;
    logic        spi_sck_o,  spi_sck_t;

    // -------------------------------------------------------------------------
    // PMOD1: LED chaser
    //
    // Walks a single lit LED around LED_DANCE[0] (IO1) ... LED_DANCE[7] (IO8),
    // one step every 200 ms (full lap of 8 LEDs in 1.6 s).
    // -------------------------------------------------------------------------
    localparam int unsigned CLK100_HZ  = 100_000_000;
    localparam int unsigned STEP_MS    = 200;
    localparam int unsigned STEP_TICKS = (CLK100_HZ / 1000) * STEP_MS;

    logic [$clog2(STEP_TICKS)-1:0] tick_cnt;

    always_ff @(posedge clk100) begin
        if (!rstn100) begin
            tick_cnt  <= '0;
            LED_DANCE <= 8'b0000_0001;
        end else if (tick_cnt == STEP_TICKS - 1) begin
            tick_cnt  <= '0;
            LED_DANCE <= {LED_DANCE[6:0], LED_DANCE[7]};
        end else begin
            tick_cnt  <= tick_cnt + 1'b1;
        end
    end

    // -------------------------------------------------------------------------
    // PMOD2: PS GPIO over EMIO, bits 0-7
    //
    // Outputs only, for board safety: each pin is driven only while the PS
    // enables it (_t low), otherwise high-Z. Nothing is read back.
    // -------------------------------------------------------------------------
    assign GPIO_EMIO[0] = gpio_emio_t[0] ? 1'bZ : gpio_emio_o[0];
    assign GPIO_EMIO[1] = gpio_emio_t[1] ? 1'bZ : gpio_emio_o[1];
    assign GPIO_EMIO[2] = gpio_emio_t[2] ? 1'bZ : gpio_emio_o[2];
    assign GPIO_EMIO[3] = gpio_emio_t[3] ? 1'bZ : gpio_emio_o[3];
    assign GPIO_EMIO[4] = gpio_emio_t[4] ? 1'bZ : gpio_emio_o[4];
    assign GPIO_EMIO[5] = gpio_emio_t[5] ? 1'bZ : gpio_emio_o[5];
    assign GPIO_EMIO[6] = gpio_emio_t[6] ? 1'bZ : gpio_emio_o[6];
    assign GPIO_EMIO[7] = gpio_emio_t[7] ? 1'bZ : gpio_emio_o[7];

    assign gpio_emio_i[94:0] = '0;

    // -------------------------------------------------------------------------
    // PMOD3: I2C (open drain)
    //
    // The IIC core pulls a line low by driving _o = 0 with _t = 0, and releases
    // it with _t = 1; pull-ups bring it high. _i reads the line back.
    // -------------------------------------------------------------------------
    assign I2C_SCL   = iic_scl_t ? 1'bZ : iic_scl_o;
    assign I2C_SDA   = iic_sda_t ? 1'bZ : iic_sda_o;
    assign iic_scl_i = I2C_SCL;
    assign iic_sda_i = I2C_SDA;

    // -------------------------------------------------------------------------
    // PMOD4: SPI (master)
    //
    // Outputs driven only while the SPI core enables them (_t low).
    // -------------------------------------------------------------------------
    assign SPI_CS_N = spi_ss_t   ? 1'bZ : spi_ss_o;
    assign SPI_MOSI = spi_mosi_t ? 1'bZ : spi_mosi_o;
    assign SPI_SCK  = spi_sck_t  ? 1'bZ : spi_sck_o;

    // -------------------------------------------------------------------------
    // Block design
    // -------------------------------------------------------------------------
    kr260 kr260_i (
        .AXI_IIC_scl_i   (iic_scl_i),
        .AXI_IIC_scl_o   (iic_scl_o),
        .AXI_IIC_scl_t   (iic_scl_t),
        .AXI_IIC_sda_i   (iic_sda_i),
        .AXI_IIC_sda_o   (iic_sda_o),
        .AXI_IIC_sda_t   (iic_sda_t),
        .AXI_SPI_io0_i   (1'b0),
        .AXI_SPI_io0_o   (spi_mosi_o),
        .AXI_SPI_io0_t   (spi_mosi_t),
        .AXI_SPI_io1_i   (SPI_MISO),
        .AXI_SPI_io1_o   (),
        .AXI_SPI_io1_t   (),
        .AXI_SPI_sck_i   (1'b0),
        .AXI_SPI_sck_o   (spi_sck_o),
        .AXI_SPI_sck_t   (spi_sck_t),
        .AXI_SPI_ss_i    (1'b1),
        .AXI_SPI_ss_o    (spi_ss_o),
        .AXI_SPI_ss_t    (spi_ss_t),
        .GPIO_EMIO_tri_i (gpio_emio_i),
        .GPIO_EMIO_tri_o (gpio_emio_o),
        .GPIO_EMIO_tri_t (gpio_emio_t),
        .CLK100          (clk100),
        .FAN_EN_B        (FAN_EN_B),
        .RSTN100         (rstn100)
    );

endmodule

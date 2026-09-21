// SPDX-License-Identifier: Apache-2.0
`default_nettype none
module chip_top (
`ifdef USE_POWER_PINS
    inout wire IOVDD, IOVSS, VDD, VSS,
`endif
    inout wire clk_PAD,
    inout wire rst_n_PAD,
    inout wire [7:0] input_PAD,
    inout wire [7:0] output_PAD
);
    wire clk, rst_n;
    wire [7:0] core_in, core_out;

    sg13g2_IOPadIn clk_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS),
`endif
        .p2c(clk), .pad(clk_PAD));
    sg13g2_IOPadIn rst_n_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS),
`endif
        .p2c(rst_n), .pad(rst_n_PAD));

    generate for (genvar i=0; i<8; i++) begin : inputs
        sg13g2_IOPadIn input_pad (
`ifdef USE_POWER_PINS
            .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS),
`endif
            .p2c(core_in[i]), .pad(input_PAD[i]));
    end endgenerate
    generate for (genvar i=0; i<8; i++) begin : outputs
        sg13g2_IOPadOut30mA output_pad (
`ifdef USE_POWER_PINS
            .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS),
`endif
            .c2p(core_out[i]), .pad(output_PAD[i]));
    end endgenerate

    (* keep *) sg13g2_IOPadIOVdd iovdd_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS)
`endif
    );
    (* keep *) sg13g2_IOPadIOVss iovss_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS)
`endif
    );
    (* keep *) sg13g2_IOPadVdd vdd_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS)
`endif
    );
    (* keep *) sg13g2_IOPadVss vss_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS)
`endif
    );

    // input_PAD[3:0] = JTAG TCK/TMS/TDI/TRSTn; [7:4] = IRQ[3:0].
    veer_core_harness i_core (
        .clk(clk), .rst_n(rst_n), .irq({4'b0, core_in[7:4]}),
        .jtag_tck(core_in[0]), .jtag_tms(core_in[1]),
        .jtag_tdi(core_in[2]), .jtag_trst_n(core_in[3]),
        .status(core_out));
endmodule
`default_nettype wire

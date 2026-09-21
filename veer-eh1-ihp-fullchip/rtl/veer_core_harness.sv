// SPDX-License-Identifier: Apache-2.0
// Physical-design harness for VeeR EH1. The AHB instruction port is fed
// harmless RISC-V NOPs; this keeps the complete core active without embedding
// a technology-specific memory macro in the baseline flow.
`default_nettype none
`include "build.h"

module veer_core_harness (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] irq,
    input  logic       jtag_tck,
    input  logic       jtag_tms,
    input  logic       jtag_tdi,
    input  logic       jtag_trst_n,
    output logic [7:0] status
);
    logic [63:0] trace_insn, trace_addr;
    logic [2:0] trace_valid, trace_exception, trace_interrupt;
    logic [4:0] trace_ecause;
    logic [31:0] trace_tval;
    logic jtag_tdo, halted, debug_mode;
    logic [31:0] haddr, lsu_haddr, sb_haddr;
    logic [63:0] lsu_hwdata, sb_hwdata;

    // 0x00000013 is ADDI x0,x0,0 (NOP). Both halves are valid RV32 words.
    wire [63:0] nop_pair = 64'h0000_0013_0000_0013;

    assign status = {debug_mode, halted, trace_exception[0], trace_interrupt[0],
                     trace_valid[0], trace_addr[3:2], jtag_tdo};

    veer_wrapper u_veer (
        .clk(clk), .rst_l(rst_n), .dbg_rst_l(rst_n),
        .rst_vec(31'h4000_0000), .nmi_int(1'b0),
        .nmi_vec(31'h0808_8000), .jtag_id(31'h0488_2601),
        .trace_rv_i_insn_ip(trace_insn),
        .trace_rv_i_address_ip(trace_addr),
        .trace_rv_i_valid_ip(trace_valid),
        .trace_rv_i_exception_ip(trace_exception),
        .trace_rv_i_ecause_ip(trace_ecause),
        .trace_rv_i_interrupt_ip(trace_interrupt),
        .trace_rv_i_tval_ip(trace_tval),
        .haddr(haddr), .hburst(), .hmastlock(), .hprot(), .hsize(),
        .htrans(), .hwrite(), .hrdata(nop_pair), .hready(1'b1), .hresp(1'b0),
        .lsu_haddr(lsu_haddr), .lsu_hburst(), .lsu_hmastlock(), .lsu_hprot(),
        .lsu_hsize(), .lsu_htrans(), .lsu_hwrite(), .lsu_hwdata(lsu_hwdata),
        .lsu_hrdata(64'b0), .lsu_hready(1'b1), .lsu_hresp(1'b0),
        .sb_haddr(sb_haddr), .sb_hburst(), .sb_hmastlock(), .sb_hprot(),
        .sb_hsize(), .sb_htrans(), .sb_hwrite(), .sb_hwdata(sb_hwdata),
        .sb_hrdata(64'b0), .sb_hready(1'b1), .sb_hresp(1'b0),
        .dma_haddr(32'b0), .dma_hburst(3'b0), .dma_hmastlock(1'b0),
        .dma_hprot(4'b0), .dma_hsize(3'b0), .dma_htrans(2'b0),
        .dma_hwrite(1'b0), .dma_hwdata(64'b0), .dma_hsel(1'b0),
        .dma_hreadyin(1'b1), .dma_hrdata(), .dma_hreadyout(), .dma_hresp(),
        .lsu_bus_clk_en(1'b1), .ifu_bus_clk_en(1'b1),
        .dbg_bus_clk_en(1'b1), .dma_bus_clk_en(1'b1),
        .timer_int(irq[0]), .extintsrc_req(irq),
        .dec_tlu_perfcnt0(), .dec_tlu_perfcnt1(),
        .dec_tlu_perfcnt2(), .dec_tlu_perfcnt3(),
        .jtag_tck(jtag_tck), .jtag_tms(jtag_tms), .jtag_tdi(jtag_tdi),
        .jtag_trst_n(jtag_trst_n), .jtag_tdo(jtag_tdo),
        .mpc_debug_halt_req(1'b0), .mpc_debug_run_req(1'b0),
        .mpc_reset_run_req(1'b1), .mpc_debug_halt_ack(),
        .mpc_debug_run_ack(), .debug_brkpt_status(),
        .i_cpu_halt_req(1'b0), .o_cpu_halt_ack(),
        .o_cpu_halt_status(halted), .o_debug_mode_status(debug_mode),
        .i_cpu_run_req(1'b0), .o_cpu_run_ack(),
        .scan_mode(1'b0), .mbist_mode(1'b0)
    );
endmodule

`default_nettype wire

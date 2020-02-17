//date: 01.08.2020
//from "FPGA Prototyping by Verilog"

module ps2_rxtx(
	input clk, rst,
	input wr_ps2,
	input [7:0] din,
	inout ps2d, ps2c,
	output wire rx_done_tick, tx_done_tick,
	output wire [7:0] dout );
	
	wire tx_idle;
	
	ps2_rx ps2_rx_uut
		(.clk(clk), .rst(rst), .rx_en(tx_idle),
		 .ps2d(ps2d), .ps2c(ps2c), .rx_done_tick(rx_done_tick),
		 .dout(dout) );
		 
	ps2_tx ps2_tx_uut
		(.clk(clk), .rst(rst), .wr_ps2(wr_ps2), .din(din),
		 .ps2c(ps2c), .ps2d(ps2d), .tx_idle(tx_idle),
		 .tx_done_tick(tx_done_tick) );
		 
endmodule
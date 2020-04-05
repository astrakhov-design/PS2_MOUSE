//date: 09.01.2020
//PS/2 mouse interface

`include "stream_FSM.v"
`include "../ps2_rxtx/ps2_rxtx.v"

module mouse(
	input clk, rst,
	inout ps2d, ps2c,
	output wire [8:0] xm, ym,
	output wire [2:0] btnm_led,
	output wire package_done_tick
	);
			
	wire [7:0] tx_data;
	wire [7:0] rx_data;
	wire wr_ps2;
	wire rx_done_tick, tx_done_tick;
	
	ps2_rxtx ps2_uut
		(.clk(clk),
		.rst(rst),
		.wr_ps2(wr_ps2),
		 .din(tx_data),
		 .dout(rx_data),
		 .ps2d(ps2d),
		 .ps2c(ps2c),
		 .rx_done_tick(rx_done_tick),
		 .tx_done_tick(tx_done_tick) );
			
	stream_FSM stream_uut(
		.clk(clk),
		.rst(rst),
		.rx_data(rx_data),
		.rx_done_tick(rx_done_tick),
		.tx_done_tick(tx_done_tick),
		.wr_ps2(wr_ps2),
		.package_done_tick(package_done_tick),
		.tx_data(tx_data),
		.x_axis(xm),
		.y_axis(ym),
		.btnm(btnm_led) );

endmodule

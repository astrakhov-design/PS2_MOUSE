//Ariphmetic register with BCD decoder
//Author: Aleksander Strakhov
//Date: 14.04.2020

`include "../bcd_decoder/bcd_decoder_16bit.v"
`include "ariphmetic_register.v"

module ariphmetic_register_bcd(
	input clk,
	input rst,
	input reset_button,
	input done_tick,
	input [8:0] x_axis,
	input [8:0] y_axis,
	output [19:0] ariphmetic_bcd
);
	
	wire [15:0] z_axis;
	
	wire [3:0] ten_thousands;
	wire [3:0] thousands;
	wire [3:0] hundreds;
	wire [3:0] tens;
	wire [3:0] units;
	
	ariphmetic_register ariphmetic_unit(
		.clk(clk),
		.rst(rst),
		.reset_registers(reset_button),
		.package_done(done_tick),
		.x_axis(x_axis),
		.y_axis(y_axis),
		.z_reg(z_axis)
	);
					
	bcd_decoder_16bit bcd_unit(
		.B(z_axis),
		.ten_thousands(ten_thousands),
		.thousands(thousands),
		.hundreds(hundreds),
		.tens(tens),
		.units(units)
	);
	
	assign ariphmetic_bcd = {ten_thousands, thousands,
			hundreds, tens, units};
	
endmodule
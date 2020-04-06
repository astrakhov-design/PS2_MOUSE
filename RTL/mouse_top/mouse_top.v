//mouse testing circut top module
//date: 01.10.2020
//upd1: 01.27.2020
//upd2: 04.05.2020

`include "../ariphmetic/ariphmetic_register.v"
`include "../bcd_decoder/bcd_decoder.v"
`include "../interface/mouse.v"
`include "../led_controller/led_controller.v"

module mouse_top(
	input clk, rst,
	input reset_registers,
	inout ps2d, ps2c,
	
	output middle_led,
	output left_led,
	output right_led,
	output done_tick_led,
	
	output [6:0] sseg,
	output [3:0] anode );
	
	wire reset;
	assign reset = ~rst;
	wire nreset_reg;
	assign nreset_reg = ~reset_registers;
	//axis with overflow
	wire [8:0] x_input, y_input;
	wire [2:0] btnm_led;
	//w/o overflow
	wire done_tick;
	//reg x_over, y_over;
	wire [15:0] z_axis;
	
	mouse mouse_uut(
		.clk(clk), .rst(reset),
		.ps2d(ps2d), .ps2c(ps2c),
		.xm(x_input), .ym(y_input),
		.btnm_led(btnm_led),
		.package_done_tick(done_tick)
	);
	
	ariphmetic_register ariphmetic_uut(
		.clk(clk),
		.rst(reset),
		.reset_registers(nreset_reg),
		.package_done(done_tick),
		.x_axis(x_input),
		.y_axis(y_input),
		.z_reg(z_axis)
	);
	
	wire [3:0] ten_thousands, thousands,
				hundreds, tens, units;
				
	bcd_decoder bcd(.B(z_axis),
				.ten_thousands(ten_thousands),
				.thousands(thousands),
				.hundreds(hundreds),
				.tens(tens),
				.units(units)
			);
	
	
	
	led_controller led_uut(
		.clk(clk), .rst(reset),
		.x_axis({ten_thousands, thousands}), .y_axis({hundreds, tens}),
		.sseg(sseg), .anode(anode) );

	//assign x_over_led = x_over;
	//assign y_over_led = y_over;
	assign done_tick_led = ~done_tick;
	assign middle_led = ~btnm_led[2];
	assign right_led = ~btnm_led[1];
	assign left_led = ~btnm_led[0];
	
endmodule
			
	
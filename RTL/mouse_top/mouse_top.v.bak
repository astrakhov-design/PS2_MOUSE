//mouse testing circut top module
//date: 01.10.2020
//upd1: 01.27.2020

module mouse_top(
	input clk, rst,
	inout ps2d, ps2c,
	input [2:0] buttons,
	
	output middle_led,
	output left_led,
	output right_led,
	output done_tick_led,
	
	output [6:0] sseg,
	output [3:0] anode );
	
	wire reset;
	assign reset = ~rst;
	wire [2:0] buttons_inv;
	assign buttons_inv = ~buttons;
	//axis with overflow
	wire [8:0] x_input, y_input;
	wire [2:0] btnm_led;
	//w/o overflow
	wire done_tick;
	//reg x_over, y_over;
	wire [9:0] z_axis;
	
	mouse mouse_uut(
		.clk(clk), .rst(reset),
		.ps2d(ps2d), .ps2c(ps2c),
		.input_btnm(buttons_inv),
		.xm(x_input), .ym(y_input),
		.btnm_led(btnm_led),
		.package_done_tick(done_tick)
	);
	
	ariphmetic_register ariphmetic_uut(
		.rst(reset),
		.package_done(done_tick),
		.x_axis(x_input),
		.y_axis(y_input),
		.z_reg(z_axis)
	);
	
	led_controller led_uut(
		.clk(clk), .rst(reset),
		.x_axis({6'b000_000, z_axis[9:8]}), .y_axis(z_axis[7:0]),
		.sseg(sseg), .anode(anode) );

	//assign x_over_led = x_over;
	//assign y_over_led = y_over;
	assign done_tick_led = ~done_tick;
	assign middle_led = ~btnm_led[2];
	assign right_led = ~btnm_led[1];
	assign left_led = ~btnm_led[0];
	
endmodule
			
	
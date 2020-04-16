//mouse testing circut top module
//date: 10.01.2020
//upd1: 27.01.2020
//upd2: 05.04.2020
//upd3: 13.04.2020
//upd4: 14.04.2020
//upd5: 16.04.2020

`include "../ariphmetic/ariphmetic_register_bcd.v"
`include "../interface/mouse.v"
`include "../led_controller/led_controller.v"
`include "../vga_text/ps2_mouse_VGA_top.v"
`include "../mouse_button_counter/button_counter_bcd.v"

module mouse_top(
	input clk, rst,
	input reset_register,
	inout ps2d, ps2c,
	
	output middle_led,
	output left_led,
	output right_led,
	output done_tick_led,
	
	output [6:0] sseg,
	output [3:0] anode,

	output hsync,
	output vsync,
	output [2:0] vga_rgb
	);
	
	wire reset;
	assign reset = ~rst;
	wire nreset_reg;
	assign nreset_reg = ~reset_register;
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
	
	wire [19:0] ariphmetic_bcd;
	
	ariphmetic_register_bcd ariphmetic_register_bcd_unit(
		.clk(clk),
		.rst(reset),
		.reset_button(nreset_reg),
		.done_tick(done_tick),
		.x_axis(x_input),
		.y_axis(y_input),
		.ariphmetic_bcd(ariphmetic_bcd)
	);
	
	wire [9:0] left_bcd;
	wire [9:0] middle_bcd;
	wire [9:0] right_bcd;
	
	button_counter_bcd button_counter_bcd_unit(
		.clk(clk),
		.rst(reset),
		.reset_button(nreset_reg),
		.left_button(btnm_led[0]),
		.middle_button(btnm_led[2]),
		.right_button(btnm_led[1]),
		.left_bcd(left_bcd),
		.middle_bcd(middle_bcd),
		.right_bcd(right_bcd)
	);
	
		
	led_controller led_uut(
		.clk(clk),
		.rst(reset),
		.x_axis(ariphmetic_bcd[19:12]),
		.y_axis(ariphmetic_bcd[11:4]),
		.sseg(sseg),
		.anode(anode)
	);
	
	ps2_mouse_VGA_top vga_unit(
		.clk(clk),
		.rst(reset),
		.ariphmetic_bcd(ariphmetic_bcd),
		.left_bcd(left_bcd),
		.middle_bcd(middle_bcd),
		.right_bcd(right_bcd),
		.hsync(hsync),
		.vsync(vsync),
		.vga_rgb(vga_rgb)
	);
		
	//assign x_over_led = x_over;
	//assign y_over_led = y_over;
	assign done_tick_led = ~done_tick;
	assign middle_led = ~btnm_led[2];
	assign right_led = ~btnm_led[1];
	assign left_led = ~btnm_led[0];
	
endmodule
			
	
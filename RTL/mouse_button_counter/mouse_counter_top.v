//top module for button counter
//Author: Aleksander Strakhov
//Date: 14.04.2020

`include "mouse_counter.v"

module mouse_counter_top(
	input clk,
	input rst,
	input reset_register,
	input left_button,
	input middle_button,
	input right_button,
	
	output [7:0] left_button_counter,
	output [7:0] middle_button_counter,
	output [7:0] right_button_counter
	);
	
	button_counter left_unit(
		.clk(clk),
		.rst(rst),
		.reset_register(reset_register),
		.input_button(left_button),
		.counter(left_button_counter)
	);
	
	button_counter middle_unit(
		.clk(clk),
		.rst(rst),
		.reset_register(reset_register),
		.input_button(middle_button),
		.counter(middle_button_counter)
	);
	
	button_counter right_unit(
		.clk(clk),
		.rst(rst),
		.reset_register(reset_register),
		.input_button(right_button),
		.counter(right_button_counter)
	);
	
endmodule
	
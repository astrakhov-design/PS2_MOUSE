//mouse_counter_with_bcd
//Author: Aleksander Strakhov
//Date: 14.04.2020

`include "mouse_counter_top.v"
`include "../bcd_decoder/bcd_decoder_8bit.v"

module button_counter_bcd(
	input clk,
	input rst,
	input reset_button,
	input left_button,
	input middle_button,
	input right_button,
	
	output [9:0] left_bcd,
	output [9:0] middle_bcd,
	output [9:0] right_bcd
);

	wire [7:0] 	left_button_counter,
				middle_button_counter,
				right_button_counter;
				
	wire [1:0] left_hundreds;
	wire [3:0] left_tens;
	wire [3:0] left_units;
	
	wire [1:0] middle_hundreds;
	wire [3:0] middle_tens;
	wire [3:0] middle_units;
	
	wire [1:0] right_hundreds;
	wire [3:0] right_tens;
	wire [3:0] right_units;


	mouse_counter_top counter_unit(
		.clk(clk),
		.rst(rst),
		.reset_register(reset_button),
		.left_button(left_button),
		.middle_button(middle_button),
		.right_button(right_button),
		.left_button_counter(left_button_counter),
		.middle_button_counter(middle_button_counter),
		.right_button_counter(right_button_counter)
	);
	
	bcd_decoder_8bit left_bcd_unit(
		.A(left_button_counter),
		.ones(left_units),
		.tens(left_tens),
		.hundreds(left_hundreds)
	);
	
	bcd_decoder_8bit middle_bcd_unit(
		.A(middle_button_counter),
		.ones(middle_units),
		.tens(middle_tens),
		.hundreds(middle_hundreds)
	);
	
	bcd_decoder_8bit right_bcd_unit(
		.A(right_button_counter),
		.ones(right_units),
		.tens(right_tens),
		.hundreds(right_hundreds)
	);
	
	assign left_bcd = {left_hundreds,
					left_tens, left_units};
	assign middle_bcd = {middle_hundreds,
					middle_tens, middle_units};
	assign right_bcd = {right_hundreds,
					right_tens, right_units};
					
endmodule
		
		
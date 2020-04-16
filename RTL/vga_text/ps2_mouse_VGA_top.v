//Top module for VGA text
//Author: Aleksander Strakhov
//Date: 13.04.2020

`include "vga_sync.v"
`include "ps2_mouse_text.v"

module ps2_mouse_VGA_top(
	input clk,
	input rst,
	input [19:0] ariphmetic_bcd,
	input [9:0] left_bcd,
	input [9:0] middle_bcd,
	input [9:0] right_bcd,
	
	output hsync,
	output vsync,
	output [2:0] vga_rgb
	);
	
	//signal declaration
	wire [9:0] pixel_x, pixel_y;
	wire video_on, pixel_tick;
	reg [2:0] rgb_reg;
	wire [2:0] rgb_next;
	
	reg [3:0]	ten_thousands_reg,
				thousands_reg,
				hundreds_reg,
				tens_reg,
				units_reg;
			  
	reg [3:0] 	left_hundreds_reg,
				left_tens_reg,
				left_units_reg;
				
	reg [3:0]	middle_hundreds_reg,
				middle_tens_reg,
				middle_units_reg;
				
	reg [3:0]	right_hundreds_reg,
				right_tens_reg,
				right_units_reg;
				
	wire [3:0] left_hundreds;
	assign left_hundreds = {2'b00, left_bcd[9:8]};
			  
	always @ (posedge clk, posedge rst)
		begin
			if(rst)
			begin
				ten_thousands_reg <= 4'd0;
				thousands_reg <= 4'd0;
				hundreds_reg <= 4'd0;
				tens_reg <= 4'd0;
				units_reg <= 4'd0;
				
				left_hundreds_reg <= 4'd0;
				left_tens_reg <= 4'd0;
				left_units_reg <= 4'd0;
				
				middle_hundreds_reg <= 4'd0;
				middle_tens_reg <= 4'd0;
				middle_units_reg <= 4'd0;
				
				right_hundreds_reg <= 4'd0;
				right_tens_reg <= 4'd0;
				right_units_reg <= 4'd0;
			end
			else begin
				ten_thousands_reg <= ariphmetic_bcd[19:16];
				thousands_reg <= ariphmetic_bcd[15:12];
				hundreds_reg <= ariphmetic_bcd[11:8];
				tens_reg <= ariphmetic_bcd[7:4];
				units_reg <= ariphmetic_bcd[3:0];
				
				left_hundreds_reg <= left_hundreds;
				left_tens_reg <= left_bcd[7:4];
				left_units_reg <= left_bcd[3:0];
				
				middle_hundreds_reg <= {2'b00,
							middle_bcd[9:8]};
				middle_tens_reg <= middle_bcd[7:4];
				middle_units_reg <= middle_bcd[3:0];
				
				right_hundreds_reg <= {2'b00,
							right_bcd[9:8]};
				right_tens_reg <= right_bcd[7:4];
				right_units_reg <= right_bcd[3:0];
			end
		end
				
	
	
	vga_sync vga_sync_unit(
		.clk(clk),
		.rst(rst),
		.hsync(hsync),
		.vsync(vsync),
		.video_on(video_on),
		.p_tick(pixel_tick),
		.pixel_x(pixel_x),
		.pixel_y(pixel_y)
	);
	
	ps2_mouse_text text_unit(
		.clk(clk),
		.video_on(video_on),
		.z_axis_ten_thousands(ten_thousands_reg),
		.z_axis_thousands(thousands_reg),
		.z_axis_hundreds(hundreds_reg),
		.z_axis_tens(tens_reg),
		.z_axis_units(units_reg),
		.left_button_hundreds(left_hundreds_reg),
		.left_button_tens(left_tens_reg),
		.left_button_units(left_units_reg),
		.middle_button_hundreds(middle_hundreds_reg),
		.middle_button_tens(middle_tens_reg),
		.middle_button_units(middle_units_reg),
		.right_button_hundreds(right_hundreds_reg),
		.right_button_tens(right_tens_reg),
		.right_button_units(right_units_reg),
		.pix_x(pixel_x),
		.pix_y(pixel_y),
		.text_rgb(rgb_next)
	);
	
	always @ (posedge clk)
	begin
		if (pixel_tick)
			rgb_reg <= rgb_next;
	end
	
	assign vga_rgb = rgb_reg;
	
endmodule	
	
	
	
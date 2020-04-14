//Top module for VGA text
//Author: Aleksander Strakhov
//Date: 13.04.2020

`include "vga_sync.v"
`include "ps2_mouse_text.v"

module ps2_mouse_VGA_top(
	input clk,
	input rst,
	input [3:0] ten_thousands,
	input [3:0] thousands,
	input [3:0] hundreds,
	input [3:0] tens,
	input [3:0] units,
	
	output hsync,
	output vsync,
	output [2:0] vga_rgb
	);
	
	//signal declaration
	wire [9:0] pixel_x, pixel_y;
	wire video_on, pixel_tick;
	reg [2:0] rgb_reg;
	wire [2:0] rgb_next;
	
	reg [3:0] ten_thousands_reg,
			  thousands_reg,
			  hundreds_reg,
			  tens_reg,
			  units_reg;
			  
	always @ (posedge clk, posedge rst)
		begin
			if(rst)
			begin
				ten_thousands_reg <= 4'd0;
				thousands_reg <= 4'd0;
				hundreds_reg <= 4'd0;
				tens_reg <= 4'd0;
				units_reg <= 4'd0;
			end
			else begin
				ten_thousands_reg <= ten_thousands;
				thousands_reg <= thousands;
				hundreds_reg <= hundreds;
				tens_reg <= tens;
				units_reg <= units;
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
	
	
	
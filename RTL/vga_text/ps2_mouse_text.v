//Text generating module for PS2_MOUSE
//Author: Aleksander Strakhov
//Date: 08.04.2020

`include "LCD_character_bitmap.v"

module ps2_mouse_text(
	input clk,
	input video_on,
	
	input [3:0] z_axis_ten_thousands,
	input [3:0] z_axis_thousands,
	input [3:0] z_axis_hundreds,
	input [3:0] z_axis_tens,
	input [3:0] z_axis_units,
	
	input [3:0] left_button_hundreds,
	input [3:0] left_button_tens,
	input [3:0] left_button_units,
	
	input [3:0] middle_button_hundreds,
	input [3:0] middle_button_tens,
	input [3:0] middle_button_units,
	
	input [3:0] right_button_hundreds,
	input [3:0] right_button_tens,
	input [3:0] right_button_units,
	
	input [9:0] pix_x, pix_y,
	
	output reg [2:0] text_rgb
);

	wire [9:0] rom_addr;
	reg [6:0] char_addr;
	wire [2:0] row_addr;
	wire [2:0] bit_addr;
	wire [7:0] font_word;
	wire font_bit, z_axis_on;
	wire [7:0] rule_rom_addr;
	
	LCD_character_bitmap bitmap_unit(
		.clk(clk),
		.addr(rom_addr),
		.data(font_word)
	);
	
	//assign constant scaling
	assign row_addr = pix_y[2:0];
	assign bit_addr = pix_x[2:0];
	
	//---------------------------------
	//### region
	//display chars: "******************"
	//---------------------------------
	//area parameters
	reg [6:0] char_comment;
	wire char_comment_on;
	assign char_comment_on = (pix_y[9:3] == 7'd0
	|| pix_y[9:3] == 7'd4
	|| pix_y[9:3] == 7'd8
	||	pix_y[9:3] == 7'd13) && (pix_x[9:3] < 5'd31);
	always @*
		begin
			if(pix_x[7:3] < 5'd15)
				char_comment = 7'h0a;
			else
				char_comment = 7'h00;
		end
	
	//---------------------------------
	// name region
	//display chars: "PS/2 TRACKING COUNTER"
	//---------------------------------
	//area parameters
	reg [6:0] char_one;
	wire char_one_on;
	assign char_one_on = (pix_y[9:3] == 7'd1) && (pix_x[9:3] < 5'd31);
	always @*
		begin
			case(pix_x[7:3])
				5'd0: 	char_one = 7'h30; //P
				5'd1: 	char_one = 7'h33; //S
				5'd2: 	char_one = 7'h0f; ///
				5'd3: 	char_one = 7'h12; //2
				5'd4: 	char_one = 7'h00; //space
				5'd5: 	char_one = 7'h34; //T
				5'd6: 	char_one = 7'h32; //R
				5'd7: 	char_one = 7'h21; //A
				5'd8: 	char_one = 7'h23; //C
				5'd9: 	char_one = 7'h2b; //K
				5'd10:	char_one = 7'h29; //I
				5'd11:	char_one = 7'h2e; //N
				5'd12:	char_one = 7'h27; //G
				5'd13:	char_one = 7'h00; //space
				5'd14:	char_one = 7'h23; //C
				5'd15:	char_one = 7'h2f; //O
				5'd16:	char_one = 7'h35; //U
				5'd17:	char_one = 7'h2e; //N
				5'd18:	char_one = 7'h34; //T
				5'd19:	char_one = 7'h25; //E
				5'd20:	char_one = 7'h32; //R
				default:	char_one = 7'h00;
			endcase
		end
		
	//-----------------------------
	//author region
	//display chars: "MADE BY ALEKSANDER STRAKHOV"
	//-----------------------------
	//area parameters
	reg [6:0] char_two;
	wire char_two_on;
	assign char_two_on = (pix_y[9:3] == 7'd2) && (pix_x[9:3] < 5'd31);
	always @*
		begin
			case(pix_x[7:3])
				5'd0:	char_two = 7'h2d; //M
				5'd1:	char_two = 7'h21; //A
				5'd2:	char_two = 7'h24; //D
				5'd3:	char_two = 7'h25; //E
				5'd4:	char_two = 7'h00; // space
				5'd5:	char_two = 7'h22; //B
				5'd6:	char_two = 7'h39; //Y
				5'd7:	char_two = 7'h00; // space
				5'd8:	char_two = 7'h21; //A
				5'd9:	char_two = 7'h2c; //L
				5'd10:	char_two = 7'h25; //E
				5'd11:	char_two = 7'h2b; //K
				5'd12:	char_two = 7'h33; //S
				5'd13:	char_two = 7'h21; //A
				5'd14:	char_two = 7'h2e; //N
				5'd15:	char_two = 7'h24; //D
				5'd16:	char_two = 7'h25; //E
				5'd17:	char_two = 7'h32; //R
				5'd18:	char_two = 7'h00; // space
				5'd19:	char_two = 7'h33; //S
				5'd20:	char_two = 7'h34; //T
				5'd21:	char_two = 7'h32; //R
				5'd22:	char_two = 7'h21; //A
				5'd23:	char_two = 7'h2b; //K
				5'd24:	char_two = 7'h28; //H
				5'd25:	char_two = 7'h2f; //O
				5'd26:	char_two = 7'h36; //V
				default: char_two = 7'h00;
			endcase
		end
		
	//---------------------------------
	//date region
	//display region: "JANUARY-APRIL 2020"
	//---------------------------------
	reg [6:0] char_three;
	wire char_three_on;
	assign char_three_on = (pix_y[9:3] == 7'd3) && (pix_x[9:3] < 5'd31);
	always @*
	begin
		case (pix_x[7:3])
			5'd0:	char_three = 7'h2a; //J
			5'd1:	char_three = 7'h21; //A
			5'd2:	char_three = 7'h2e; //N
			5'd3:	char_three = 7'h35; //U
			5'd4:	char_three = 7'h21; //A
			5'd5:	char_three = 7'h32; //R
			5'd6:	char_three = 7'h39; //Y
			5'd7:	char_three = 7'h0d; //-
			5'd8:	char_three = 7'h21; //A
			5'd9:	char_three = 7'h30; //P
			5'd10:	char_three = 7'h32; //R
			5'd11:	char_three = 7'h29; //I
			5'd12:	char_three = 7'h2c; //L
			5'd13:	char_three = 7'h00; //space
			5'd14:	char_three = 7'h12; //2
			5'd15:	char_three = 7'h10; //0
			5'd16:	char_three = 7'h12; //2
			5'd17:	char_three = 7'h10; //0
			default: char_three = 7'h00;
		endcase
	end
				
	
	//---------------------------------
	//z-axis region
	//display chars: "TRACKING COUNT: DDDDD"
	//---------------------------------
	//area parameters
	reg [6:0] char_addr_z;
	assign z_axis_on = (pix_y[9:3] == 7'd5) && (pix_x[9:3] < 5'd31);
	always @*
		case (pix_x[7:3])
			5'd0: 	char_addr_z = 7'h34; // T
			5'd1: 	char_addr_z = 7'h32; // R
			5'd2: 	char_addr_z = 7'h21; // A
			5'd3: 	char_addr_z = 7'h23; // C
			5'd4: 	char_addr_z = 7'h2b; // K
			5'd5: 	char_addr_z = 7'h29; // I
			5'd6: 	char_addr_z = 7'h2e; // N
			5'd7: 	char_addr_z = 7'h27; // G
			5'd8: 	char_addr_z = 7'h00; // space
			5'd9:	char_addr_z = 7'h23; // C
			5'd10: 	char_addr_z = 7'h2f; // O
			5'd11: 	char_addr_z = 7'h35; // U
			5'd12: 	char_addr_z = 7'h2e; // N
			5'd13: 	char_addr_z = 7'h34; // T
			5'd14:	char_addr_z = 7'h1a; // :
			5'd15:	char_addr_z = 7'h00; // space
			5'd16: 	char_addr_z = {3'b001, z_axis_ten_thousands};
			5'd17:	char_addr_z = {3'b001, z_axis_thousands};
			5'd18:	char_addr_z = {3'b001, z_axis_hundreds};
			5'd19:	char_addr_z = {3'b001, z_axis_tens};
			5'd20:	char_addr_z = {3'b001, z_axis_units};
			default: char_addr_z = 7'h00;
		endcase
		
	
	//------------------------------------
	//button status area
	//display chars: "BUTTON STATUS"
	//------------------------------------
	//area parameters
	reg [6:0] char_btnm_status;
	wire char_btnm_on;
	assign char_btnm_on = (pix_y[9:3] == 7'd9) && (pix_x[9:3] < 5'd31);
	always @*
		case (pix_x[7:3])
			5'd0:	char_btnm_status = 7'h22; //B
			5'd1:	char_btnm_status = 7'h35; //U
			5'd2:	char_btnm_status = 7'h34; //T
			5'd3:	char_btnm_status = 7'h34; //T
			5'd4:	char_btnm_status = 7'h2f; //O
			5'd5:	char_btnm_status = 7'h2e; //N
			5'd6:	char_btnm_status = 7'h00; // space
			5'd7:	char_btnm_status = 7'h33; //S
			5'd8:	char_btnm_status = 7'h34; //T
			5'd9:	char_btnm_status = 7'h21; //A
			5'd10:	char_btnm_status = 7'h34; //T
			5'd11:	char_btnm_status = 7'h35; //U
			5'd12:	char_btnm_status = 7'h33; //S
			default: char_btnm_status = 7'h00;
		endcase
		
	//------------------------------------
	//left button counter
	//display chars: "LEFT: DDD"
	//------------------------------------
	//area parameters
	reg [6:0] char_left_button;
	wire char_left_on;
	assign char_left_on = (pix_y[9:3] == 7'd10) && (pix_x[9:3] < 5'd31);
	always @*
		case (pix_x[7:3])
			5'd0:	char_left_button = 7'h2c; //L
			5'd1:	char_left_button = 7'h25; //E
			5'd2:	char_left_button = 7'h26; //F
			5'd3:	char_left_button = 7'h34; //T
			5'd4:	char_left_button = 7'h1a; //:
			5'd5:	char_left_button = 7'h00; //space
			5'd6:	char_left_button = {3'b001, left_button_hundreds};
			5'd7:	char_left_button = {3'b001, left_button_tens};
			5'd8:	char_left_button = {3'b001, left_button_units};
			default:	char_left_button = 7'h00;
		endcase


	
		
	//------------------------------------
	//mux for font ROM addresses and rgb
	//------------------------------------
	always @*
	begin
		if(~video_on)
		begin
			char_addr = 7'h00;
			text_rgb = 3'b000;
		end
		else begin
			if(char_comment_on)
			begin
				char_addr = char_comment;
				if(font_bit)
					text_rgb = 3'b111;
				else
					text_rgb = 3'b000;
			end
			else if(char_one_on)
			begin
				char_addr = char_one;
				if (font_bit)
					text_rgb = 3'b111;
				else
					text_rgb = 3'b000;
			end
			else if(char_two_on)
			begin
				char_addr = char_two;
				if (font_bit)
					text_rgb = 3'b111;
				else
					text_rgb = 3'b000;
			end
			else if(char_three_on)
			begin
				char_addr = char_three;
				if (font_bit)
					text_rgb = 3'b111;
				else
					text_rgb = 3'b000;
			end
			else if(z_axis_on)
			begin
				char_addr = char_addr_z;
				if(font_bit)
					text_rgb = 3'b111;
				else
					text_rgb = 3'b000;
			end
			else if (char_btnm_on)
			begin
				char_addr = char_btnm_status;
				if (font_bit)
					text_rgb = 3'b111;
				else
					text_rgb = 3'b000;
			end
			else if(char_left_on)
			begin
				char_addr = char_left_button;
				if(font_bit)
					text_rgb = 3'b111;
				else
					text_rgb = 3'b000;
			end
			else begin
				char_addr = 7'h00;
				text_rgb = 3'b000;
			end
		end
	end
	
	//-----------------------------------
	//font rom interface
	//-----------------------------------
	assign rom_addr = {char_addr, row_addr};
	assign font_bit = font_word[~bit_addr];
	
endmodule	
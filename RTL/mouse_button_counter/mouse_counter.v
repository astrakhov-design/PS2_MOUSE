//button filter & counter
//Author: Aleksander Strakhov
//Date: 14.04.2020


module button_counter(
	input clk,
	input rst,
	input reset_register,
	input input_button,

	output reg [7:0] counter
	);
	
	reg [7:0] filter_reg;
	
	always @ (posedge clk, posedge rst)
		begin
			if(rst)
				filter_reg <= 8'd0;
			else
				filter_reg <= {input_button, filter_reg[7:1]};
		end
	
	wire pressed_tick;
	assign pressed_tick = (filter_reg == 8'b1111_1111) ? 1'b1 : 1'b0;
	
	always @ (posedge clk, posedge rst, posedge reset_register)
		begin
			if (rst || reset_register)
				counter <= 8'd0;
			else if (pressed_tick)
				counter <= counter + 1'b1;
		end
		
endmodule
		
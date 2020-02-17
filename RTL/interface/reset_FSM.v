//FSM for RESET command
//Date: 01.17.2020
module reset_FSM(
	input clk,
	input rst,
	input reset_enable,
	input [7:0] rx_data,
	input rx_done_tick, tx_done_tick,
	
	output reg wr_ps2,
	output wire [7:0] tx_data, //command to mouse
	output reg reset_done);
	
	localparam MOUSE_RESET = 8'hFF;
	
	reg [7:0] tx_cmd;
	
	localparam [2:0]
		reset_idle = 3'd0,
		reset_cmd_state = 3'd1,
		reset_wait_state = 3'd2,
		reset_answer_state = 3'd3,
		reset_done_state = 3'd4;
		
	reg [2:0] reset_reg, reset_next;
	
	always @ (posedge clk, posedge rst)
		begin
			if (rst)
				begin
					reset_reg <= reset_idle;
				end
			else
				begin
					reset_reg <= reset_next;
				end
		end
		
	always @*
		begin
			reset_next = reset_reg;
			reset_done = 1'b0;
			tx_cmd = 8'h00;
			wr_ps2 = 1'b0;
			case (reset_reg)
				reset_idle:
					if (reset_enable)
						reset_next = reset_cmd_state;
				reset_cmd_state:
					begin
						wr_ps2 = 1'b1;
						tx_cmd = MOUSE_RESET;
						reset_next = reset_wait_state;
					end
				reset_wait_state:
					if (tx_done_tick)
						reset_next = reset_answer_state;
				reset_answer_state:
					if (rx_done_tick)
						begin
							if (rx_data == 8'hAA)
								reset_next = reset_done_state;
						end
				reset_done_state:
					begin
						reset_next = reset_idle;
						reset_done = 1'b1;
					end
			endcase
		end
		
	assign tx_data = tx_cmd;
		
endmodule
				
					
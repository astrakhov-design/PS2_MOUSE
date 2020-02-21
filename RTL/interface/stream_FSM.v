//FSM for STREAM mode
//date: 01.17.2020

module stream_FSM(
	input clk, rst,
	input [7:0] rx_data,
	input rx_done_tick, tx_done_tick,
	
	output reg wr_ps2,
	output reg package_done_tick,
	output wire [7:0] tx_data, //commands to mouse
	output wire [8:0] x_axis,
	output wire [8:0] y_axis,
	output wire [2:0] btnm );
	
	localparam ENABLE_MOUSE_STREAMING = 8'hF4;
	localparam DISABLE_MOUSE_STREAMING = 8'hF5;
	
	localparam [2:0]
		stream_idle = 3'd0,
		stream_cmd_state = 3'd1,
		stream_wait_state = 3'd2,
		stream_answer_state = 3'd3,
		pack1_state = 3'd4,
		pack2_state = 3'd5,
		pack3_state = 3'd6,
		stream_done_state = 3'd7;
		
	reg [2:0] stream_reg, stream_next;
	reg [8:0] x_reg, x_next, y_reg, y_next;
	reg [2:0] btn_reg, btn_next;
	reg [7:0] tx_cmd;
	
	always @ (posedge clk, posedge rst)
		begin
			if (rst)
				begin
					stream_reg <= stream_idle;
					x_reg <= 0;
					y_reg <= 0;
					btn_reg <= 0;
				end
			else
				begin
					stream_reg <= stream_next;
					x_reg <= x_next;
					y_reg <= y_next;
					btn_reg <= btn_next;
				end
		end
		
	always @*
		begin
			wr_ps2 = 1'b0;
			stream_next = stream_reg;
			x_next = x_reg;
			y_next = y_reg;
			btn_next = btn_reg;
			tx_cmd = 8'h00;
			package_done_tick = 1'b0;
			case (stream_reg)
				stream_idle:
						stream_next = stream_cmd_state;
				stream_cmd_state:
					begin
						wr_ps2 = 1'b1;
						tx_cmd = ENABLE_MOUSE_STREAMING;
						stream_next = stream_wait_state;
					end
				stream_wait_state:
					if (tx_done_tick)
						stream_next = stream_answer_state;
				stream_answer_state:
					if (rx_done_tick)
						stream_next = pack1_state;
				pack1_state:
					if (rx_done_tick)
						begin
							stream_next = pack2_state;
							y_next[8] = rx_data[5];
							x_next[8] = rx_data[4];
							btn_next = rx_data[2:0];
						end
				pack2_state:
					if (rx_done_tick)
						begin
							stream_next = pack3_state;
							x_next[7:0] = rx_data;
						end
				pack3_state:
					if (rx_done_tick)
						begin
							stream_next = stream_done_state;
							y_next[7:0] = rx_data;
						end
				stream_done_state:
					begin
						package_done_tick = 1'b1;
						stream_next = pack1_state;
					end
			endcase
		end
		
	assign x_axis = x_reg;
	assign y_axis = y_reg;
	assign btnm = btn_reg;
	assign tx_data = tx_cmd;
	
endmodule

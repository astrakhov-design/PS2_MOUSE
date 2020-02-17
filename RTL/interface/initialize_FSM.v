module initialize_FSM(
	input clk, rst,
	input init_en,
	input rx_done_tick, tx_done_tick,
	
	output reg wr_ps2,
	output wire [7:0] tx_data,
	output reg initialize_done);
	
	localparam SET_MOUSE_RESOLUTION = 8'hE8;
	localparam SET_MOUSE_SAMPLING_RATE = 8'hF3;
	localparam SET_MOUSE_SCALING_1TO1 = 8'hE6;
	localparam SET_MOUSE_SCALING_2TO1 = 8'hE7;
	
	localparam [4:0]
		initialization_idle = 5'd0,
		resolution_cmd_state = 5'd1,
		resolution_cmd_wait = 5'd2,
		resolution_cmd_answer = 5'd3,
		resolution_val_cmd = 5'd4,
		resolution_val_wait = 5'd5,
		resolution_val_answer = 5'd6,
		scaling_cmd = 5'd7,
		scaling_wait = 5'd8,
		scaling_answer = 5'd9,
		sampling_cmd = 5'd10,
		sampling_wait = 5'd11,
		sampling_answer = 5'd12,
		sampling_val_cmd = 5'd13,
		sampling_val_wait = 5'd14,
		sampling_val_answer = 5'd15,
		initialization_done = 5'd16;
		
	reg [4:0] initialization_reg, initialization_next;
	reg [7:0] tx_cmd;
	
	always @ (posedge clk, posedge rst)
		begin
			if (rst)
				initialization_reg <= initialization_idle;
			else
				initialization_reg <= initialization_next;
		end
	
	always @*
		begin
			wr_ps2 = 1'b0;
			tx_cmd = 8'h00;
			initialize_done = 1'b0;
			initialization_next = initialization_reg;
			case (initialization_reg)
				initialization_idle:
					if (init_en)
						initialization_next = resolution_cmd_state;
				resolution_cmd_state:
					begin
						wr_ps2 = 1'b1;
						tx_cmd = SET_MOUSE_RESOLUTION;
						initialization_next = resolution_cmd_wait;
					end
				resolution_cmd_wait:
					if (tx_done_tick)
						initialization_next = resolution_cmd_answer;
				resolution_cmd_answer:
					if (rx_done_tick)
						initialization_next = resolution_val_cmd;
				resolution_val_cmd:
					begin
						wr_ps2 = 1'b1;
						tx_cmd = 8'h00;
						initialization_next = resolution_val_wait;
					end
				resolution_val_wait:
					if (tx_done_tick)
						initialization_next = resolution_val_answer;
				resolution_val_answer:
					if (rx_done_tick)
						initialization_next = scaling_cmd;
				scaling_cmd:
					begin
						wr_ps2 = 1'b1;
						tx_cmd = SET_MOUSE_SCALING_1TO1;
						initialization_next = scaling_wait;
					end
				scaling_wait:
					if (tx_done_tick)
						initialization_next = scaling_answer;
				scaling_answer:
					if (rx_done_tick)
						initialization_next = sampling_cmd;
				sampling_cmd:
					begin
						wr_ps2 = 1'b1;
						tx_cmd = SET_MOUSE_SAMPLING_RATE;
						initialization_next = sampling_wait;
					end
				sampling_wait:
					if (tx_done_tick)
						initialization_next = sampling_answer;
				sampling_answer:
					if (rx_done_tick)
						initialization_next = sampling_val_cmd;
				sampling_val_cmd:
					begin
						wr_ps2 = 1'b1;
						tx_cmd = 8'd40;
						initialization_next = sampling_val_wait;
					end
				sampling_val_wait:
					if (tx_done_tick)
						initialization_next = sampling_val_answer;
				sampling_val_answer:
					if (rx_done_tick)
						initialization_next = initialization_done;
				initialization_done:
					begin
						initialize_done = 1'b1;
					end
			endcase
		end
		
	assign tx_data = tx_cmd;
		
endmodule
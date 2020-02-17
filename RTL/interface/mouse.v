//date: 01.09.2020
//PS/2 mouse interface
module mouse(
	input clk, rst,
	inout ps2d, ps2c,
	input [2:0] input_btnm,
	output wire [8:0] xm, ym,
	output wire [2:0] btnm_led,
	output wire package_done_tick );
	
	
	localparam [1:0]
		IDLE = 2'd0,
		RESET = 2'd1,
		INITIALIZATION = 2'd2,
		STREAM = 2'd3;
		
	reg [1:0] general_reg, general_next;
	
	wire [7:0] tx_data;
	reg  [7:0] tx_cmd;
	wire [7:0] rx_data;
	reg wr_ps2_global;
	wire wr_ps2, rx_done_tick, tx_done_tick;
	
	ps2_rxtx ps2_uut
		(.clk(clk), .rst(rst), .wr_ps2(wr_ps2),
		 .din(tx_data), .dout(rx_data), .ps2d(ps2d), .ps2c(ps2c),
		 .rx_done_tick(rx_done_tick),
		 .tx_done_tick(tx_done_tick) );
		 
	reg reset_enable;
	wire reset_done;
	wire [7:0] tx_reset;
	wire wr_ps2_reset;

	reset_FSM reset_uut(
		.clk(clk), .rst(rst),
		.reset_enable(reset_enable),
		.rx_data(rx_data),
		.rx_done_tick(rx_done_tick), .tx_done_tick(tx_done_tick),
		.wr_ps2(wr_ps2_reset), .tx_data(tx_reset),
		.reset_done(reset_done));
		
	reg stream_enable, stream_disable;
	wire disable_done_tick;
	wire [7:0] tx_stream;
	wire wr_ps2_stream;
	
	stream_FSM stream_uut(
		.clk(clk), .rst(rst),
		.stream_enable(stream_enable),
		.stream_disable(stream_disable),
		.rx_data(rx_data), .rx_done_tick(rx_done_tick),
		.tx_done_tick(tx_done_tick), .wr_ps2(wr_ps2_stream),
		.disable_done_tick(disable_done_tick),
		.package_done_tick(package_done_tick),
		.tx_data(tx_stream), .x_axis(xm),
		.y_axis(ym), .btnm(btnm_led) );
	
	reg init_enable;
	wire initialize_done;
	wire [7:0] tx_init;
	wire wr_ps2_init;
		
	initialize_FSM initialize_uut(
		.clk(clk), .rst(rst),
		.init_en(init_enable),
		.rx_done_tick(rx_done_tick),
		.tx_done_tick(tx_done_tick),
		.wr_ps2(wr_ps2_init), .tx_data(tx_init),
		.initialize_done(initialize_done) );
	

	//control streaming
	reg [1:0] button_state;
	always @ (posedge input_btnm[0], posedge rst)
		begin
			if (rst)
				button_state <= 2'b00;
			else
				begin
					if (button_state > 2'b10)
						button_state <= 2'b00;
					else
						button_state <= button_state + 1'b1;
				end
		end
		
		 
	always @ (posedge clk, posedge rst) begin
		if (rst)
			begin
				general_reg <= RESET;
			end
		else
			begin
				general_reg <= general_next;
			end
	end
	
	always @*
		begin
			tx_cmd = 8'h00;
			wr_ps2_global = 1'b0;
			reset_enable = 1'b0;
			stream_enable = 1'b0;
			stream_disable = 1'b0;
			init_enable = 1'b1;
			general_next = general_reg;
			case(general_reg)
				IDLE:
					begin
						case (input_btnm)
							3'b100:
								general_next = RESET;
							3'b010:
								general_next = INITIALIZATION;
							3'b001:
								general_next = STREAM;
							default:
								general_next = IDLE;
						endcase
					end
				RESET:
					begin
						wr_ps2_global = wr_ps2_reset;
						reset_enable = 1'b1;
						tx_cmd = tx_reset;
						if (reset_done)
							begin
								general_next = IDLE;
								reset_enable = 1'b0;
							end
					end
				INITIALIZATION:
					begin
						init_enable = 1'b1;
						wr_ps2_global = wr_ps2_init;
						tx_cmd = tx_init;
						if (initialize_done)
							begin
								init_enable = 1'b0;
								general_next = IDLE;
							end
					end
				STREAM:
					begin
						tx_cmd = tx_stream;
						wr_ps2_global = wr_ps2_stream;
						case (button_state)
							2'b01: begin
								stream_enable = 1'b1;
								stream_disable = 1'b0;
									end
							2'b10: begin
								stream_enable = 1'b0;
								stream_disable = 1'b1;
									end
							default: begin
								stream_enable = 1'b0;
								stream_disable = 1'b0;
									end
						endcase
					end
			endcase
		end
		
	assign tx_data = tx_cmd;
	assign wr_ps2 = wr_ps2_global;
	
endmodule
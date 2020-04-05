//counting register for Z axis
//Date: 21.02.2020

`include "ariphmetic.v"

module ariphmetic_register(
	input clk,
	input rst,
	input reset_registers,
	input package_done,
	input [8:0] x_axis,
	input [8:0] y_axis,
	
	output reg [15:0] z_reg);
	
	wire [8:0] z_wire;
	
	ariphmetic ariphmetic_combinational(
		.x_axis(x_axis),
		.y_axis(y_axis),
		.z_axis(z_wire)
	);
	
	always @ (posedge clk, posedge rst, posedge reset_registers)
		begin
			if (rst || reset_registers)
				z_reg <= 0;
			else if (package_done)
				z_reg <= z_reg + z_wire;
		end
		
endmodule

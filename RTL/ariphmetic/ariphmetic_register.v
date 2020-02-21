//counting register for Z axis
//Date: 21.02.2020

module ariphmetic_register(
	input rst,
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
	
	always @ (posedge package_done, posedge rst)
		begin
			if (rst)
				z_reg <= 0;
			else
				z_reg <= z_reg + z_wire;
		end
		
endmodule

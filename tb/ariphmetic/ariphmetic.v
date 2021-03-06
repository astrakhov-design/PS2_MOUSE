module ariphmetic(
	input [8:0] x_axis,
	input [8:0] y_axis,
	
	output [8:0] z_axis
	);
	
	//converting from two's complement
	wire [7:0] x_normal;
	wire [7:0] y_normal;
	
	assign x_normal = x_axis[8] ? ( ~(x_axis[7:0] - 1)) : ( x_axis[7:0] );
	assign y_normal = y_axis[8] ? ( ~(y_axis[7:0] - 1)) : ( y_axis[7:0] );
	
	//x2 and y2
	
	wire [15:0] x2, y2;
	assign x2 = x_normal * x_normal;
	assign y2 = y_normal * y_normal;
	
	wire [17:0] z2;
	assign z2 = x2 + y2;
	
	assign z_axis[8] = (z2[17:16] == 2'b00) ? 1'b0 : 1'b1;
	assign z_axis[7] = (z2[17:14] < {z_axis[8], 1'b1} * {z_axis[8], 1'b1}) ? 1'b0 : 1'b1;
	assign z_axis[6] = (z2[17:12] < {z_axis[8:7], 1'b1} * {z_axis[8:7], 1'b1}) ? 1'b0 : 1'b1;
	assign z_axis[5] = (z2[17:10] < {z_axis[8:6], 1'b1} * {z_axis[8:6], 1'b1}) ? 1'b0 : 1'b1;
	assign z_axis[4] = (z2[17:8]  < {z_axis[8:5], 1'b1} * {z_axis[8:5], 1'b1}) ? 1'b0 : 1'b1;
	assign z_axis[3] = (z2[17:6]  < {z_axis[8:4], 1'b1} * {z_axis[8:4], 1'b1}) ? 1'b0 : 1'b1;
	assign z_axis[2] = (z2[17:4]  < {z_axis[8:3], 1'b1} * {z_axis[8:3], 1'b1}) ? 1'b0 : 1'b1;
	assign z_axis[1] = (z2[17:2]  < {z_axis[8:2], 1'b1} * {z_axis[8:2], 1'b1}) ? 1'b0 : 1'b1;
	assign z_axis[0] = (z2[17:0]  < {z_axis[8:1], 1'b1} * {z_axis[8:1], 1'b1}) ? 1'b0 : 1'b1;
	
endmodule
	
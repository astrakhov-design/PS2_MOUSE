`timescale 1us/1us
module ariphmetic_tb;
	reg [8:0] x_axis;
	reg [8:0] y_axis;
	wire [8:0] z_axis;
	
	wire z_axis_delay;
	
	ariphmetic ariphmetic_uut(
		.x_axis(x_axis),
		.y_axis(y_axis),
		.z_axis(z_axis)
	);
	
	wire [7:0] x_norm;
	wire [7:0] y_norm;
	
	assign x_norm = x_axis[8] ? ( ~(x_axis[7:0] - 1)) : ( x_axis[7:0] );
	assign y_norm = y_axis[8] ? ( ~(y_axis[7:0] - 1)) : ( y_axis[7:0] );
	
	
	function [15:0] sqrt;
    input [31:0] num;  //declare input
    //intermediate signals.
    wire [31:0] a;
    wire [15:0] q;
    wire [17:0] left,right,r;    
    integer i;
begin
    //initialize all the variables.
    a = num;
    q = 0;
    i = 0;
    left = 0;   //input to adder/sub
    right = 0;  //input to adder/sub
    r = 0;  //remainder
    //run the calculations for 16 iterations.
    for(i=0;i<16;i=i+1) begin 
        right = {q,r[17],1'b1};
        left = {r[15:0],a[31:30]};
        a = {a[29:0],2'b00};    //left shift by 2 bits.
        if (r[17] == 1) //add if r is negative
            r = left + right;
        else    //subtract if r is positive
            r = left - right;
        q = {q[14:0],!r[17]};       
    end
    sqrt = q;   //final assignment of output.
end
endfunction //end of Function
	
	integer k;
	
	wire [15:0] z_verif = 0;
	//z_verif = sqrt((x_norm * x_norm) + (y_norm * y_norm));
	
	initial begin
		for (k = 0; k < 511; k = k+1)
			begin
				x_axis = $random;
				y_axis = $random;
				#1;
				z_verif = sqrt((x_norm * x_norm) + (y_norm * y_norm));
				#1;
				z_axis_delay = z_axis;

			end
	end
	
endmodule
//BCD Decoder for PS2_MOUSE
//Author: Aleksander Strakhov
//Date: 05.04.2020

`inlcude "add3.v"

module bcd_decoder(
	input [15:0] B,
	output [3:0] ten_thousands,
	output [3:0] thousands,
	output [3:0] hundreds,
	output [3:0] tens,
	output [3:0] units);
	
	wire [3:0] C1o, C2o, C3o, C4o, C5o, C6o, C7o, C8o,
	C9o, C10o, C11o, C12o, C13o, C14o, C15o, C16o, C17o,
	C18o, C19o, C20o, C21o, C22o, C23o, C24o, C25o, C26o,
	C27o, C28o, C29o, C30o, C31o, C32o, C33o, C34o;
	
	add3 C1(
		.in({1'b0, B[15:13]}),
		.out(C1o)
		);
		
	add3 C2(
		.in({C1o[2:0], B[12]}),
		.out(C2o)
		);
		
	add3 C3(
		.in({C2o[2:0], B[11]}),
		.out(C3o)
		);
		
	add3 C4(
		.in({C3o[2:0], B[10]}),
		.out(C4o)
		);

	add3 C5(
		.in({C4o[2:0], B[9]}),
		.out(C5o)
		);

	add3 C6(
		.in({C5o[2:0], B[8]}),
		.out(C6o)
		);

	add3 C7(
		.in({C6o[2:0], B[7]}),
		.out(C7o)
		);

	add3 C8(
		.in({C7o[2:0], B[6]}),
		.out(C8o)
		);

	add3 C9(
		.in({C8o[2:0], B[5]}),
		.out(C9o)
		);

	add3 C10(
		.in({C9o[2:0], B[4]}),
		.out(C10o)
		);

	add3 C11(
		.in({C10o[2:0], B[3]}),
		.out(C11o)
		);

	add3 C12(
		.in({C11o[2:0], B[2]}),
		.out(C12o)
		);

	add3 C13(
		.in({C12o[2:0], B[1]}),
		.out(C13o)
		);

	add3 C14(
		.in({1'b0, C1o[3], C2o[3], C3o[3]}),
		.out(C14o)
		);
		
	add3 C15(
		.in({C14o[2:0], C4o[3]}),
		.out(C15o)
		);
		
	add3 C16(
		.in({C15o[2:0], C5o[3]}),
		.out(C16o)
		);

	add3 C17(
		.in({C16o[2:0], C6o[3]}),
		.out(C17o)
		);

	add3 C18(
		.in({C17o[2:0], C7o[3]}),
		.out(C18o)
		);

	add3 C19(
		.in({C18o[2:0], C8o[3]}),
		.out(C19o)
		);

	add3 C20(
		.in({C19o[2:0], C9o[3]}),
		.out(C20o)
		);

	add3 C21(
		.in({C20o[2:0], C10o[3]}),
		.out(C21o)
		);

	add3 C22(
		.in({C21o[2:0], C11o[3]}),
		.out(C22o)
		);

	add3 C23(
		.in({C22o[2:0], C12o[3]}),
		.out(C23o)
		);

	add3 C24(
		.in({1'b0, C14o[3], C15o[3], C16o[3]}),
		.out(C24o)
		);

	add3 C25(
		.in({C24o[2:0], C17o[3]}),
		.out(C25o)
		);

	add3 C26(
		.in({C25o[2:0], C18o[3]}),
		.out(C26o)
		);

	add3 C27(
		.in({C26o[2:0], C19o[3]}),
		.out(C27o)
		);

	add3 C28(
		.in({C27o[2:0], C20o[3]}),
		.out(C28o)
		);

	add3 C29(
		.in({C28o[2:0], C21o[3]}),
		.out(C29o)
		);

	add3 C30(
		.in({C29o[2:0], C22o[3]}),
		.out(C30o)
		);

	add3 C31(
		.in({1'b0, C24o[3], C25o[3], C26o[3]}),
		.out(C31o)
		);

	add3 C32(
		.in({C31o[2:0], C27o[3]}),
		.out(C32o)
		);

	add3 C33(
		.in({C32o[2:0], C28o[3]}),
		.out(C33o)
		);

	add3 C34(
		.in({C33o[2:0], C29o[3]}),
		.out(C34o)
		);

	assign ten_thousands = {C31o[3], C32o[3], C33o[3], C34o[3]};
	assign thousands = {C34o[2:0], C30o[3]};
	assign hundreds = {C30o[2:0], C23o[3]};
	assign tens = {C23o[2:0], C13o[3]};
	assign units = {C13o[2:0], B[0]};
	
endmodule	
		
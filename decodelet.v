// Mini decoder for flow control only

module decodelet(
	input [31:0] cmdIn,
	output isJmp, isJr, isBr,
	output [31:0] cmdOut
);

	wire j; assign j = (opcode == 6'h2);
	wire jr; assign jr = (opcode == 6'h0  && funct == 6'h8);
	wire beq; assign beq = (opcode == 6'h4);
	wire bne; assign bne = (opcode == 6'h5);

	assign isJmp = j | jr;
	assign isJr = 0; // No jump reg yet
	assign isBr = 0; // No bromine yet 

	assign cmdOut = cmdIn;

endmodule

// Mini decoder for flow control only

module decodelet(
	input [31:0] cmdIn, lastCmdIn,
	output isBubble, isJmp, isJr, isBr,
	output [31:0] cmdOut
);

	// Always in the same place in the command, though not always there
	wire [5:0] opcode; assign opcode = cmdIn[31:26];
	wire [5:0] funct; assign funct = cmdIn[5:0];

	wire lw; assign lw = (opcode == 6'h23);
	wire j; assign j = (opcode == 6'h2);
	wire jr; assign jr = (opcode == 6'h0  && funct == 6'h8);
	wire beq; assign beq = (opcode == 6'h4);
	wire bne; assign bne = (opcode == 6'h5);

	assign isBubble = lw;
	assign isJmp = !lw && ( j | jr);
	assign isJr = 0; // No jump reg yet
	assign isBr = 0; // No bromine yet 

	assign cmdOut = cmdIn;

endmodule

// Mini decoder for flow control only

module decodelet(
	input [31:0] cmdIn, lastCmdIn,
	output isBubble, isJmp, isJr, isBr, 
	output [15:0] imm,
	output [25:0] jmpAddr,
	output [31:0] cmdOut
);

	// Always in the same place in the command, though not always there
	wire [5:0] opcode; assign opcode = cmdIn[31:26];
	wire [5:0] funct; assign funct = cmdIn[5:0];

	assign imm = cmdIn[15:0];
	assign jmpAddr = cmdIn[25:0];

	wire j; assign j = (opcode == 6'h2);
	wire jal; assign jal = (opcode == 6'h3);
	wire jr; assign jr = (opcode == 6'h0  && funct == 6'h8);
	wire beq; assign beq = (opcode == 6'h4);
	wire bne; assign bne = (opcode == 6'h5);

	wire lastLw; assign lastLw = (lastCmdIn[31:26] == 6'h23);

	assign isBubble = lastLw;
	assign isJmp = !lastLw && ( j | jal | jr);
	assign isJr = 0; // No jump reg yet
	assign isBr = 0; // No bromine yet 

	assign cmdOut = isBubble ? 32'h00000020 : cmdIn; // Send " add $zero, $zero, $zero " for bubbles

endmodule

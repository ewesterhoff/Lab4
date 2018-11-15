// Mini decoder for flow control only

module decodelet(
	input [31:0] cmdIn, cmdIn1, cmdIn2,
	output isBubble, isJmp, isJr, isBr,
	output [15:0] imm,
	output [25:0] jmpAddr,
	output [31:0] cmdOut
);

	// Always in the same place in the command, though not always there
	wire [5:0] opcode; assign opcode = cmdIn[31:26];
	wire [5:0] funct; assign funct = cmdIn[5:0];
/*
	wire [5:1] opcode1; assign opcode1 = cmdIn1[31:26];
	wire [5:1] funct1; assign funct = cmdIn1[5:1];
	wire [5:2] opcode2; assign opcode2 = cmdIn2[31:26];
	wire [5:2] funct2; assign funct = cmdIn2[5:2];
	*/

	assign imm = cmdIn[15:0];
	assign jmpAddr = cmdIn[25:0];

	wire j; assign j = (opcode == 6'h2);
	wire jal; assign jal = (opcode == 6'h3);
	wire jr; assign jr = (opcode == 6'h0  && funct == 6'h8);
	wire beq; assign beq = (opcode == 6'h4);
	wire bne; assign bne = (opcode == 6'h5);
	wire br; assign br = bne || beq;


	wire lw1; assign lw1 = (cmdIn1[31:26] == 6'h23);

	wire jr1; assign jr1 = (cmdIn1[31:26] == 6'h0 && cmdIn1[5:0] == 6'h8);
	wire jr2; assign jr2 = (cmdIn2[31:26] == 6'h0 && cmdIn2[5:0] == 6'h8);

	/*
	wire beq1; assign beq1 = (opcode1 == 6'h4);
	wire bne1; assign bne1 = (opcode1 == 6'h5);
	wire br1; assign br1 = bne || beq;
	wire beq2; assign beq2 = (opcode2 == 6'h4);
	wire bne2; assign bne2 = (opcode2 == 6'h5);
	wire br2; assign br2 = bne || beq;
	*/

	assign isBubble = (lw1 | jr1) && !jr2;
	assign isJmp = !lw1 && ( j | jal);
	assign isJr = jr2 && jr1 && jr;
	assign isBr = 0; // No bromine yet

	assign cmdOut = isBubble ? 32'h00000020 : cmdIn; // Send " add $zero, $zero, $zero " for bubbles

endmodule

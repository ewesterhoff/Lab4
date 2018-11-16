// A PC with no flow control.
module linearPC(
	input clk,
	output pcData
);

	reg [31:0] pc;
	initial pc <= 0;
	always @(posedge clk) pc <= pc + 32'd4;
	assign pcData = pc;

endmodule


// A real PC that can do flow control
module complexPC(
	input clk, isBubble, isJmp, isJr, isBr, inBr,takeBr,
	input [15:0] imm,
	input [25:0] jmpAddr,
	input[31:0] rrs,cmd,
	output[31:0] pcData
);

	reg [31:0] pc;
	assign pcData = pc;
	initial pc <= 0;

	always @(posedge clk) begin
		if (!isBubble) begin
			if (isJmp) pc <= {pc[31:28], jmpAddr, 2'b0};
			else begin
				if (isJr) pc <= rrs-4;
				else if (!isJr && cmd[31:26] == 6'h0  && cmd[5:0] == 6'h8) pc <= pc;
				else begin
					if (isBr && takeBr) pc <= pc + 32'd4 + {14'b0, imm, 2'b0};
					else if (inBr && !isBr) pc<= pc;
					else pc <= pc + 32'd4;
				end
			end
		end
	end

endmodule

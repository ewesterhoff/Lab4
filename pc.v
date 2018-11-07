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
	input clk, isJmp, isJr, isBr,
	input imm, rrt,
	output pcData
);
	
	reg [31:0] pc;
	initial pc <= 0;
	always @(posedge clk) begin
		if (isJmp) pc <= {pc[31:28], imm, 2'b0};
		else begin
			if (isJr) pc <= rrt;
			else begin
				if (isBr) pc <= pc + 32'd4 + {14'b0, imm, 2'b0};
				else pc <= pc + 32'd4;
			end
		end
	end

endmodule

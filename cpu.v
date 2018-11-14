`include "alu.v"
`include "dataMemory.v"
`include "decoder.v"
`include "regfile.v"
`include "decodelet.v"
`include "pc.v"

module cpu(
  input clk,
  output dataOut,
  output regDest,
  output Dw
  );

  reg[31:0] cmd1, cmd2, cmd3, cmd4;
  reg[31:0] rrs3;
	reg[31:0] rrs2_nofwd, rrt2_nofwd;
  reg[31:0] rrt3;
	reg[4:0] rs2, rt2;
  reg[15:0] imm2, imm3;
  reg[31:0] aluOut3;
  reg[31:0] Dw4;
  reg[4:0] Aw2, Aw3, Aw4;
  reg regWrEn2, regWrEn3, regWrEn4;
	reg immSel2;
  reg[1:0] DwSel2, DwSel3;
  reg memWrEn2, memWrEn3;
  reg[2:0] aluOp2;
  wire[2:0] aluOp1;
  wire[31:0] rrs1, rrs2, rrt1, rrt2, cmd0, aluOut2, Dw3, pc;
  wire[15:0] imm1;
  wire isBubble, isJmp, isJr, isBr;
  wire[4:0] rs1,rt1,Aw1;
  wire immSel1, memWrEn1, regWrEn1, isJmp1, isJr1, brSel1;
  wire[1:0] DwSel1;
  wire carryout, zero, overflow;
  wire[31:0] cmdDecodelet, memOut;
  wire[31:0] imm0;
  wire[31:0] rrtOrImm2;
	wire[31:0] rrsNow;
  assign imm0 = 0;



	complexPC pcComp(.clk(clk), .isBubble(isBubble), .isJmp(isJmp), .isJr(isJr), .isBr(isBr),.imm(imm0), .rrt(rrt1),.pcData(pc));
	decodelet pcDecode(.cmdIn(cmdDecodelet), .lastCmdIn(cmd1), .isBubble(isBubble), .isJmp(isJmp), .isJr(isJr), .isBr(isBr),.cmdOut(cmd0));
	// Data memory is also here, but it's defined in stage 3

	always @(posedge clk)begin cmd1 <= cmd0; end

	decoder decode( .cmd(cmd1), .immSel(immSel1), .memWrEn(memWrEn1), .regWrEn(regWrEn1), .DwSel(DwSel1), .Aa(rs1), .Ab(rt1), .Aw(Aw1), .aluOp(aluOp1), .imm(imm1));
	regfile register( .ReadData1(rrs1), .ReadData2(rrt1), .WriteData(Dw4), .ReadRegister1(rs1), .ReadRegister2(rt1), .WriteRegister(Aw4), .RegWrite(regWrEn4),	.Clk(clk));

	always @(posedge clk)begin rs2 <= rs1; rt2 <= rt1; rrs2_nofwd <= rrs1; rrt2_nofwd <= rrt1; regWrEn2 <= regWrEn1; immSel2 <= immSel1;  imm2 <= imm1; Aw2 <= Aw1; aluOp2 <= aluOp1; cmd2 <= cmd1; DwSel2 <= DwSel1; end

	assign rrs2 = (rs2 == 5'b0) ? rrs2_nofwd : ( (rs2 == Aw3 && regWrEn3) ? Dw3 : ( (rs2 == Aw4 && regWrEn4) ? Dw4 : rrs2_nofwd) );
	assign rrt2 = (rt2 == 5'b0) ? rrt2_nofwd : ( (rt2 == Aw3 && regWrEn3) ? Dw3 : ( (rt2 == Aw4 && regWrEn4) ? Dw4 : rrt2_nofwd) );

	assign rrtOrImm2 = immSel2 ? imm2 : rrt2;
	alu math(.result(aluOut2),.carryout(carryout),.zero(zero),.overflow(overflow), .operandA(rrs2), .operandB(rrtOrImm2), .command(aluOp2));

	always @(posedge clk)begin rrs3 <= rrs2; regWrEn3 <= regWrEn2; imm3 <= imm2; Aw3 <= Aw2; aluOut3 <= aluOut2; cmd3 <= cmd2; rrt3 <= rrt2; DwSel3 <= DwSel2; end

	dataMemory mem( .clk(clk),.dataOut(memOut), .instruction(cmdDecodelet), .address(aluOut3), .pc_address(pc), .writeEnable(memWrEn3), .dataIn(rrt3));
	assign Dw3 = (DwSel3 == 2'd2) ? memOut : aluOut3;

	always @(posedge clk)begin Aw4 <= Aw3; regWrEn4 = regWrEn3; Dw4 <= Dw3; cmd4 <= cmd3; end

	// The second reg-file access is here, but it's declared in stage 1 because that's where the writing
	// happens.

endmodule

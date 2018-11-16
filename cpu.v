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

  reg[31:0] cmd1, cmd2, cmd3, cmd4, rrs3, rrs2_nofwd, rrt2_nofwd, rrt3, aluOut3, Dw4, pc1, pc2, lastCmd, lastLastCmd, lastLastLastCmd;
  reg[15:0] imm2, imm3;
	reg[4:0] rs2, rt2, Aw2, Aw3, Aw4;
  reg[2:0] aluOp2;
  reg[1:0] DwSel2, DwSel3;
  reg regWrEn2, regWrEn3, regWrEn4, jalAdd82, immSel2,memWrEn2, memWrEn3;


  wire isBubble, isJmp, isJr, isBr,jalAdd81, immSel1, memWrEn1, regWrEn1, isJmp1, isJr1, brSel1, carryout, zero, overflow;
  wire[1:0] DwSel1;
  wire[2:0] aluOp1;
  wire[4:0] rs1,rt1,Aw1;
  wire[15:0] imm0,imm1;
	wire[25:0] jmpAddr;
  wire[31:0] rrtOrImm2, cmdDecodelet, memOut, rrsNow, rrs1, rrs2, rrt1, rrt2, cmd0, aluOut2, Dw3, pc0, rrsOrPc;


	complexPC pcComp(.clk(clk), .isBubble(isBubble), .isJmp(isJmp), .isJr(isJr), .isBr(isBr),.imm(imm0), .jmpAddr(jmpAddr), .rrs(rrs2),.cmd(cmdDecodelet),.pcData(pc0));
	decodelet pcDecode(.cmdIn(cmdDecodelet), .cmdIn1(lastCmd), .cmdIn2(lastLastCmd), .cmdIn3(lastLastLastCmd), .isBubble(isBubble), .isJmp(isJmp), .isJr(isJr), .isBr(isBr), .imm(imm0), .jmpAddr(jmpAddr), .cmdOut(cmd0));
	// Data memory is also here, but it's defined in stage 3

	always @(posedge clk)begin cmd1 <= cmd0; pc1 <= pc0; lastCmd <= cmdDecodelet; end

	decoder decode( .cmd(cmd1), .immSel(immSel1), .memWrEn(memWrEn1), .regWrEn(regWrEn1), .DwSel(DwSel1), .Aa(rs1), .Ab(rt1), .Aw(Aw1), .aluOp(aluOp1), .imm(imm1), .jalAdd8(jalAdd81));
	regfile register( .ReadData1(rrs1), .ReadData2(rrt1), .WriteData(Dw4), .ReadRegister1(rs1), .ReadRegister2(rt1), .WriteRegister(Aw4), .RegWrite(regWrEn4),	.Clk(clk));

	always @(posedge clk)begin rs2 <= rs1; pc2 <= pc1; rt2 <= rt1; jalAdd82 <= jalAdd81; rrs2_nofwd <= rrs1; rrt2_nofwd <= rrt1; regWrEn2 <= regWrEn1; immSel2 <= immSel1;  imm2 <= imm1; Aw2 <= Aw1; aluOp2 <= aluOp1; cmd2 <= cmd1; DwSel2 <= DwSel1; memWrEn2 <= memWrEn1; lastLastCmd <= lastCmd; end

	initial begin // Initialize "old" Aw's so we don't forward from before time
		Aw3 = 5'b0;
		Aw4 = 5'b0;
	end

	assign rrs2 = (rs2 == 5'b0) ? rrs2_nofwd : ( (rs2 == Aw3 && regWrEn3) ? Dw3 : ( (rs2 == Aw4 && regWrEn4) ? Dw4 : rrs2_nofwd) );
	assign rrt2 = (rt2 == 5'b0) ? rrt2_nofwd : ( (rt2 == Aw3 && regWrEn3) ? Dw3 : ( (rt2 == Aw4 && regWrEn4) ? Dw4 : rrt2_nofwd) );

	assign rrtOrImm2 = immSel2 ? imm2 : rrt2; // Does this do sign extension right?
  assign rrsOrPc = jalAdd82 ? pc2 : rrs2;
	alu math(.result(aluOut2),.carryout(carryout),.zero(zero),.overflow(overflow), .operandA(rrsOrPc), .operandB(rrtOrImm2), .command(aluOp2));

	always @(posedge clk)begin rrs3 <= rrs2; regWrEn3 <= regWrEn2; imm3 <= imm2; Aw3 <= Aw2; aluOut3 <= aluOut2; cmd3 <= cmd2; rrt3 <= rrt2; DwSel3 <= DwSel2; memWrEn3 <= memWrEn2; lastLastLastCmd <= lastLastCmd; end

	dataMemory mem( .clk(clk),.dataOut(memOut), .instruction(cmdDecodelet), .address(aluOut3), .pc_address(pc0), .writeEnable(memWrEn3), .dataIn(rrt3));
	assign Dw3 = (DwSel3 == 2'd2) ? memOut : aluOut3;

	always @(posedge clk)begin Aw4 <= Aw3; regWrEn4 = regWrEn3; Dw4 <= Dw3; cmd4 <= cmd3; end

	// The second reg-file access is here, but it's declared in stage 1 because that's where the writing
	// happens.

endmodule

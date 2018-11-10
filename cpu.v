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

  reg[31:0] cmd1;
  reg[31:0] rrs2, rrs3;
  reg[31:0] rrt2, rrt3;
  reg[31:0] rrtOrImm2;
  reg[15:0] imm2, imm3;
  reg[31:0] aluOut3;
  reg[31:0] Dw4;
  reg[4:0] addrReg2, addrReg3, addrReg4;
  reg regWrEn2, regWrEn3, regWrEn4;
  reg[1:0] DwSel2, DwSel3, DwSel4;
  reg memWrEn2, memWrEn3;
  reg[2:0] aluOp2;
  wire[2:0] aluOp1;
  wire[31:0] rrs1, rrt1, cmd0, aluOut2, Dw3, pc;
  wire[15:0] imm1;
  wire isJmp, isJr, isBr;
  wire[4:0] rs,rt,addrReg1;
  wire immSel1, memWrEn1, regWrEn1, isJmp1, isJr1, brSel1;
  wire[1:0] DwSel1;
  wire carryout, zero, overflow;
  wire[31:0] cmdDecodelet, memOut;
  wire[31:0] imm0;
  wire[31:0] rrtOrImm1;
  assign imm0 = 0;



	complexPC pcComp(.clk(clk), .isJmp(isJmp), .isJr(isJr), .isBr(isBr),.imm(imm0), .rrt(rrt1),.pcData(pc));
	decodelet pcDecode(.cmdIn(cmdDecodelet),.isJmp(isJmp), .isJr(isJr), .isBr(isBr),.cmdOut(cmd0));

	always @(posedge clk)begin cmd1 = cmd0; end

	decoder decode( .cmd(cmd1), .immSel(immSel1), .memWrEn(memWrEn1), .regWrEn(regWrEn1), .DwSel(DwSel1), .Aa(rs), .Ab(rt), .Aw(addrReg1), .aluOp(aluOp1), .imm(imm1));
	regfile register( .ReadData1(rrs1), .ReadData2(rrt1), .WriteData(Dw4), .ReadRegister1(rs), .ReadRegister2(rt), .WriteRegister(addrReg4), .RegWrite(regWrEn4),	.Clk(clk));
	assign rrtOrImm1 = immSel1 ? imm1 : rrt1;

	always @(posedge clk)begin rrs2 = rrs1; rrtOrImm2 = rrtOrImm1; imm2 = imm1; addrReg2 = addrReg1; end

	alu math(.result(aluOut2),.carryout(carryout),.zero(zero),.overflow(overflow), .operandA(rrs2), .operandB(rrtOrImm2), .command(aluOp2));

	always @(posedge clk)begin rrs3 = rrs2; imm3 = imm2; addrReg3 = addrReg2; aluOut3 = aluOut2; end

	dataMemory mem( .clk(clk),.dataOut(memOut), .instruction(cmdDecodelet), .address(aluOut3), .pc_address(pc), .writeEnable(memWrEn3), .dataIn(rrt3));
	assign Dw3 = (DwSel3 == 2'd2) ? memOut : aluOut3;

	always @(posedge clk)begin addrReg4 = addrReg3; Dw4 = Dw3; end

	// The second reg-file access is here, but it's declared in stage 1 because that's where the writing
	// happens.

endmodule

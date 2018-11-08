`include "adder32.v"
`include "alu.v"
`include "dataMemory.v"
`include "decoder.v"
`include "regfile.v"

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
  reg[31:0] imm2, imm3;
  reg[31:0] aluOut2, aluOut3;
  reg[31:0] dw4;
  reg[31:0] addrReg2, addrReg3, addrReg4;
  reg regWrEn2, regWrEn3, regWrEn4;
  reg DwSel2, DwSel3, DwSel4;
  reg memWrEn2, memWrEn3;
  reg[2:0] aluOp2;
  wire[2:0] aluOp1;
  wire[31:0] imm1,rrs1, rrt1, cmd0, aluOut1, dw3, addrReg1, pc;
  wire isJmp, isJr, isBr;
  wire[31:0] rs,rt;
  wire immSel1, memWrEn1, regWrEn1, isJmp1, isJr1, DwSel1, brSel1;
  wire carryout, zero, overflow;




    complexPC pcComp(.clk(clk), .isJmp(isJmp), .isJr(isJr), .isBr(isBr),.imm(imm0), .rrt(rrt1),.pcData(pc));
    always @(posedge clk)begin cmd1 = cmd0; end
    decoder decode( .cmd(cmd1), .immSel(immSel1), .memWrEn(memWrEn1), .regWrEn(regWrEn1), .isJmp(isJmp1), .isJr(isJr1), .DwSel(DwSel1), .brSel(brSel1), .Aa(rs), .Ab(rt), .Aw(addrReg1), .aluOp(aluOp1), .imm(imm1), .jumpAddr());
    regfile register( .ReadData1(rs), .ReadData2(rt), .WriteData(dw4), .ReadRegister1(rrs1), .ReadRegister2(rrt1), .WriteRegister(addrReg4), .RegWrite(regWrEn4),	.Clk(clk));
    always @(posedge clk)begin rrs2 = rrs1; rrtOrImm2 = rrtOrImm1; imm2 = imm1; addrReg2 = addrReg1; end
    alu alU(.result(aluOut2),.carryout(carryout),.zero(zero),.overflow(overflwo), .operandA(rrs2), .operandB(rrtOrImm2), .command(aluOp2));

    always @(posedge clk)begin rrs3 = rrs2; imm3 = imm2; addrReg3 = addrReg2; aluOut3 = aluOut2; end
    dataMemory mem( .clk(clk),.dataOut(memOut), .instruction(cmd0), .address(aluOut3), .pc_address(pc), .writeEnable(memWrEn3), .dataIn(rrt3));
    always @(posedge clk)begin addrReg4 = addrReg3; aluOut4 = aluOut3; end

endmodule

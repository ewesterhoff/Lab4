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
  reg[31:0] rrtOrImm2;
  reg[31:0] imm2, imm3;
  reg[31:0] aluOut2, aluOut3, aluOut4;
  reg[31:0] dw4;
  reg[31:0] addrReg2, addrReg3, addrReg4;
  wire[31:0] imm1,rrs1, cmd0, aluOut1, dw3, addrReg1, pc;
  wire isJmp, isJr, isBr;


    complexPC pcComp(.clk(clk), .isJmp(), .isJr(), .isBr(),.imm(imm0), .rrt(rrt1),.pcData(pc));
    always @(posedge clk)begin cmd1 = cmd0; end
    decoder decode( .cmd(cmd1), .immSel(), .memWrEn(), .regWrEn(), .isJmp(), .isJr(), .DwSel(), .brSel(), .Aa(rs), .Ab(rt), .Aw(addrReg1), .aluOp(), .imm(imm1), .jumpAddr());
    regfile register( .ReadData1(), .ReadData2(), .WriteData(), .ReadRegister1(), .ReadRegister2(), .WriteRegister(), .RegWrite(),	.Clk(clk));
    always @(posedge clk)begin rrs2 = rrs1; rrtOrImm2 = rrtOrImm1; imm2 = imm1; addrReg2 = addrReg1; end
    ALUcontrolLUT alu( .alu_code0(), .alu_code1(), .alu_code2(), .set_flags(), .slt_enable(), .subtract(), .ALUcommand());
    always @(posedge clk)begin rrs3 = rrs2; imm3 = imm2; addrReg3 = addrReg2; aluOut3 = aluOut2; end
    dataMemory mem( .clk(clk),.dataOut(), .instruction(), .address(), .pc_address(), .writeEnable(), .dataIn());
    always @(posedge clk)begin addrReg4 = addrReg3; aluOut4 = aluOut3; end

endmodule

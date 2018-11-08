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
  reg[31:0] cmd1, cmd0;
  reg[31:0] rrs1, rrs2, rrs3;
  reg[31:0] rrtOrImm1, rrtOrImm2;
  reg[31:0] imm1, imm2, imm3;
  reg[31:0] aluOut2, aluOut3, aluOut4;
  reg[31:0] dw3, dw4;
  reg[31:0] addrReg1, addrReg2, addrReg3, addrReg4;


    always @(posedge clk)begin cmd1 = cmd0; end
    complexPC pc(.clk(clk), .isJmp(), .isJr(), .isBr(),.imm(), .rrt(),.pcData());
    decoder decode( .cmd(), .immSel(), .memWrEn(), .regWrEn(), .isJmp(), .isJr(), .DwSel(), .brSel(), .Aa(), .Ab(), .Aw(), .aluOp(), .imm(), .jumpAddr());
    regfile register( .ReadData1(), .ReadData2(), .WriteData(), .ReadRegister1(), .ReadRegister2(), .WriteRegister(), .RegWrite(),	.Clk(clk));
    always @(posedge clk)begin rrs2 = rrs1; rrtOrImm2 = rrtOrImm1; imm2 = imm1; addrReg2 = addrReg1; end
    ALUcontrolLUT alu( .alu_code0(), .alu_code1(), .alu_code2(), .set_flags(), .slt_enable(), .subtract(), .ALUcommand());
    always @(posedge clk)begin rrs3 = rrs2; imm3 = imm2; addrReg3 = addrReg2; aluOut3 = aluOut2; end
    dataMemory mem( .clk(clk),.dataOut(), .instruction(), .address(), .pc_address(), .writeEnable(), .dataIn());
    always @(posedge clk)begin addrReg4 = addrReg3; aluOut4 = aluOut3; end

endmodule

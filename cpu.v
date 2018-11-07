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
  s


    always @(posedge clk) cmd1 = cmd0;
    complexPC pc(.clk(clk), .isJmp(), .isJr(), .isBr(),.imm(), .rrt(),.pcData());
    FullAdder32bit adder(.sum(), .carryout(), .overflow(), .zeros(), .a(), .b(), .carryin());
    ALUcontrolLUT alu( .alu_code0(), .alu_code1(), .alu_code2(), .set_flags(), .slt_enable(), .subtract(), .ALUcommand());
    dataMemory mem( .clk(clk),.dataOut(), .instruction(), .address(), .pc_address(), .writeEnable(), .dataIn());
    decoder decode( .cmd(), .immSel(), .memWrEn(), .regWrEn(), .isJmp(), .isJr(), .DwSel(), .brSel(), .Aa(), .Ab(), .Aw(), .aluOp(), .imm(), .jumpAddr());
    regfile register( .ReadData1(), .ReadData2(), .WriteData(), .ReadRegister1(), .ReadRegister2(), .WriteRegister(), .RegWrite(),	.Clk(clk));

endmodule

`include "adder32.v"
`include "alu.v"
`include "dataMemory.v"
`include "decoder.v"
`include "regfile.v"
module cpu(
  input clk,
  output dataOut,
  output regDest,
  output Dw );
  always @(posedge clk)begin
  FullAdder32bit adder(.sum(), .carryout(), .overflow(), .zeros(), .a(), .b(), .carryin());
  ALUcontrolLUT alu( .alu_code0(), .alu_code1(), .alu_code2(), .set_flags(), .slt_enable(), .subtract(), .ALUcommand());
  module dataMemory( .clk(),.dataOut(), .address(), .writeEnable(), .dataIn());
  decoder decode( .cmd(), .immSel(), .memWrEn(), .regWrEn(), .DwSel(), .Aa(), .Ab(), .Aw(), .aluOp(), .imm());
  regfile reg( .ReadData1(), .ReadData2(), .WriteData(), .ReadRegister1(), .ReadRegister2(), .WriteRegister(), .RegWrite(),	.Clk());
  end
endmodule
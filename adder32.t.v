// Adder testbench
`timescale 1 ns / 1 ps
`include "adder.v"

//Testing full 32 bit adder module
module testFullAdder();
    reg [31:0] a, b;  // Input binary strings
    reg carryin;      // Carryin used to make the adder flexible for use in subtractor
    wire [31:0] result; // Output of sum
    wire carryout, overflow;  // Overflow and Carryout Flags
    wire zero;        // Zero flag

    // Instantiating adder
    FullAdder32bit adder32bit (result, carryout, overflow, zero, a, b,carryin);


    initial begin
    $dumpfile("adder.vcd"); //Creating .vcd file for timing analysis
    $dumpvars;
    carryin = 0;  // Defining carryin for pure adding capabilities
    $display("operandA operandB | result overflow carryout zero");
    a = 32'b01111111111111111111111111111111; b = 32'b00000000000000000000000000000001; #2500
    if((result !== 32'b10000000000000000000000000000000) || (overflow !== 1) || (carryout !== 0) || (zero !== 0)) begin
      $display("%b        %b      %b      %b |        10000000000000000000000000000000 1        0        0",result,overflow, carryout, zero);
    end
    a = 32'b00000000000000000000000000000101; b = 32'b00000000000000000000000000001010; #2500
    if((result !== 32'b00000000000000000000000000001111) || (overflow !== 0) || (carryout !== 0) || (zero !== 0)) begin
      $display("%b        %b      %b      %b |        00000000000000000000000000001111 0        0        0",result,overflow, carryout, zero);
    end
    a = 32'b10000000000000000000000000000000; b = 32'b10000000000000000000000000000000; #2500
    if((result !== 32'b00000000000000000000000000000000) || (overflow !== 1) || (carryout !== 1) || (zero !== 1)) begin
      $display("%b        %b      %b      %b |        00000000000000000000000000000000 1        1        1",result,overflow, carryout, zero);
    end
    a = 32'b10001000110010100110110000000000; b = 32'b00001011111010111100001000000000; #2500
    if((result !== 32'b10010100101101100010111000000000) || (overflow !== 0) || (carryout !== 0) || (zero !== 0)) begin
      $display("%b        %b      %b      %b |        10010100101101100010111000000000 0        0        0",result,overflow, carryout, zero);
    end
    a = 32'b11111111111111000011100100000110; b = 32'b00000000000000000000000111010101; #2500
    if((result !== 32'b11111111111111000011101011011011) || (overflow !== 0) || (carryout !== 0) || (zero !== 0)) begin
      $display("%b        %b      %b      %b |        11111111111111000011101011011011 0        0        0",result,overflow, carryout, zero);
    end
    a = 32'b00001011111010111100001000000000; b = 32'b10001000110010100110110000000000; #2500
    if((result !== 32'b10010100101101100010111000000000) || (overflow !== 0) || (carryout !== 0) || (zero !== 0)) begin
      $display("%b        %b      %b      %b |        10010100101101100010111000000000 0        0        0",result,overflow, carryout, zero);
    end
    a = 32'b11111111101001101010100111011100; b = 32'b00000000000000000000001011101110; #2500
    if((result !== 32'b11111111101001101010110011001010) || (overflow !== 0) || (carryout !== 0) || (zero !== 0)) begin
      $display("%b        %b      %b      %b |        11111111101001101010110011001010 0        0        0",result,overflow, carryout, zero);
    end
    a = 32'b10000000000000000000000000000000; b = 32'b11111111111111111111111111111111; #2500
    if((result !== 32'b01111111111111111111111111111111) || (overflow !== 1) || (carryout !== 1) || (zero !== 0)) begin
      $display("%b        %b      %b      %b |        01111111111111111111111111111111 1        1        0",result,overflow, carryout, zero);
    end
    a = 32'b11111111111111111111110000011000; b = 32'b11111111111111111111110000011000; #2500
    if((result !== 32'b11111111111111111111100000110000) || (overflow !== 0) || (carryout !== 1) || (zero !== 0)) begin
      $display("%b        %b      %b      %b |        11111111111111111111100000110000 0        1        0",result,overflow, carryout, zero);
    end
    a = 32'b00000000000000000000000000000000; b = 32'b00000000000000000000000000000000; #2500
    if((result !== 32'b00000000000000000000000000000000) || (overflow !== 0) || (carryout !== 0) || (zero !== 1)) begin
      $display("%b        %b      %b      %b |        00000000000000000000000000000000 0        0        1",result,overflow, carryout, zero);
    end
    a = 32'b00000000000001100001101010000000; b = 32'b11111111111110011110010110000000; #2500 //WRONG!!!
    if((result !== 32'b00000000000000000000000000000000) || (overflow !== 0) || (carryout !== 1) || (zero !== 1)) begin
      $display("%b        %b      %b      %b |        00000000000000000000000000000000 0        1        1",result,overflow, carryout, zero);
    end

    $finish();
    end
endmodule

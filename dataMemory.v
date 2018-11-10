// Data memory, with automatic initialization
// Credit: Ben Hill, mostly
// Three ports: dataIn (write), dataOut (read), cmdOut (read)
// dataIn and dataOut share an address

/*
module dataMemory
(
  input clk, regWE, // On rising edge, iff regWE, writes data to register
  input[9:0] dataAddr,
  input[9:0] cmdAddr,
  input[31:0] dataIn,
  output[31:0]  dataOut,
  output[31:0] cmdOut
);

  reg [31:0] mem[1023:0]; // The actual memory

  always @(posedge clk) begin // Write if necessary
    if (regWE) begin
      mem[dataAddr] <= dataIn;
    end
  end
  integer idx;


  assign dataOut = mem[dataAddr]; // Data output
  assign cmdOut = mem[cmdAddr]; // Command output
endmodule

*/
// ------------------------------------------------------------------------
// Data Memory
//   Positive edge triggered
//   dataOut always has the value mem[address]
//   If writeEnable is true, writes dataIn to mem[address]
//   March and Emma
// ------------------------------------------------------------------------

// Text menory size: 1024
// Datapath memory size: 4096-1024 = 3072
module dataMemory
#(
    parameter depth = 32'b00000000000000000000010000000000,
    parameter offset = 32'b0
)
(
    input                     clk,
    output[31:0]            dataOut,
    output[31:0]        instruction,
    input [31:0]            address,
    input [31:0]         pc_address,
    input               writeEnable,
    input [31:0]             dataIn
);
    // convert address from mips thing to verilog index 0,4,8 to 0,1,2
    // 0x1000 to incoming address. add offset parameter

    reg [31:0] memory [depth-1:0];
    wire[31:0] shift_address; // use the ALU to shift the address as necessary (shift if accessing datamemory)

    assign shift_address = address-offset;

    wire [31:0] div4_address = shift_address >> 2;

    assign dataOut = memory[div4_address];

    always @(posedge clk) begin
        if(writeEnable)begin
            memory[div4_address] <= dataIn;
            end
    end

endmodule

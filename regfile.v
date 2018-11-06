//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);

  reg[31:0] registers[31:0];

  wire[31:0] decoded;
  decoder1to32 deco (decoded,RegWrite,WriteRegister);
  genvar i;
  generate
    for (i = 1; i < 32; i = i+1)
      always @(posedge Clk) begin
          if(decoded[i]) begin
              registers[i] <= WriteData;
          end
      end
  endgenerate
  mux32to1by32 mux1 (ReadData1,ReadRegister1,0,registers[1], registers[2], registers[3], registers[4], registers[5],registers[6], registers[7], registers[8], registers[9], registers[10],registers[11], registers[12], registers[13], registers[14], registers[15],registers[16], registers[17], registers[18], registers[19], registers[20],registers[21], registers[22], registers[23], registers[24], registers[25],registers[26], registers[27], registers[28], registers[29], registers[30],registers[31]);
  mux32to1by32 mux2 (ReadData2,ReadRegister2,0,registers[1], registers[2], registers[3], registers[4], registers[5],registers[6], registers[7], registers[8], registers[9], registers[10],registers[11], registers[12], registers[13], registers[14], registers[15],registers[16], registers[17], registers[18], registers[19], registers[20],registers[21], registers[22], registers[23], registers[24], registers[25],registers[26], registers[27], registers[28], registers[29], registers[30],registers[31]);

endmodule


//register modules

// Single-bit D Flip-Flop with enable
//   Positive edge triggered
module register
(
output reg	q,
input		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q <= d;
        end
    end

endmodule

//  32-bit register composed funtionally of 32 D flipflops
// Positive edge triggered
module register32
(
output reg[31:0]	q,
input[31:0]		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q <= d;
        end
    end

endmodule


module register32zero
(
output reg[31:0]	q,
input[31:0]		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q <= 0;
        end
    end

endmodule


// including MUXes

module mux32to1by1
    (
    output      out,
    input[4:0]  address,
    input[31:0] inputs
    );
    assign out=inputs[address];
endmodule

module mux32to1by32
  (
  output[31:0]  out,
  input[4:0]    address,
  input[31:0]   input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11,
  input[31:0]   input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23,
  input[31:0]   input24, input25, input26, input27, input28, input29, input30, input31
  );

    wire[31:0] mux[31:0];			// Create a 2D array of wires

    assign mux[0] = input0;		// Connect the sources of the array
    assign mux[1] = input1;
    assign mux[2] = input2;
    assign mux[3] = input3;
    assign mux[4] = input4;
    assign mux[5] = input5;
    assign mux[6] = input6;
    assign mux[7] = input7;
    assign mux[8] = input8;
    assign mux[9] = input9;
    assign mux[10] = input10;
    assign mux[11] = input11;
    assign mux[12] = input12;
    assign mux[13] = input13;
    assign mux[14] = input14;
    assign mux[15] = input15;
    assign mux[16] = input16;
    assign mux[17] = input17;
    assign mux[18] = input18;
    assign mux[19] = input19;
    assign mux[20] = input20;
    assign mux[21] = input21;
    assign mux[22] = input22;
    assign mux[23] = input23;
    assign mux[24] = input24;
    assign mux[25] = input25;
    assign mux[26] = input26;
    assign mux[27] = input27;
    assign mux[28] = input28;
    assign mux[29] = input29;
    assign mux[30] = input30;
    assign mux[31] = input31;
    assign out = mux[address];	// Connect the output of the array
endmodule


// including Decoder

// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32
(
output[31:0]	out,
input		enable,
input[4:0]	address
);

    assign out = enable<<address;

endmodule

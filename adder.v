// Adder circuit
`define AND2 and #30
`define OR2 or  #30
`define XOR2 xor  #30
`define NOT not #10
`define OR32 or #330
`define AND3 and  #40


//Single bit adder for bitpliced adder design.
module structuralFullAdder
(
    output sum,
    output carryout,
    input a,
    input b,
    input carryin

);
    wire xor0, and0, and1;
    // Single bit adder with carryin / carryout
    `XOR2 xor0gate(xor0,a,b);
    `AND2 and0gate(and0,a,b);
    `XOR2 sumgate(sum,xor0,carryin);
    `AND2 and1gate(and1,xor0,carryin);
    `OR2 orgate(carryout,and0,and1);
endmodule

//Full 32 bit adder module
module FullAdder32bit

(
  output[31:0] sum,  // 2's complement sum of a and b
  output carryout,  // Carry out of the summation of a and b
  output overflow,  // True if the calculation resulted in an overflow
  output zeros,
  input[31:0] a,     // First operand in 2's complement format
  input[31:0] b,      // Second operand in 2's complement format
  input carryin       //subtractor option
);

    wire[31:0] carryout0;     // temporary bus to contain all carryouts in bitpliced adder

    // Iterating through bits in bitspliced adder and adding the output to 'sum'
    genvar i;
    generate
      structuralFullAdder _adder (sum[0], carryout0[0], a[0], b[0], carryin);
      for (i = 1; i < 32; i = i+1)
        begin:genblock
          structuralFullAdder _adder (sum[i],carryout0[i], a[i], b[i],carryout0[i-1]);
        end
    endgenerate

    //Assigning final carryout to output
    assign carryout = carryout0[31];

    // Defining temporary variables for flag identification
    wire negand, posand, a3inv, b3inv, s3inv,one;

    // Checking for overflow
    `NOT a3inv(a3inv, a[31]);
    `NOT b3inv(b3inv, b[31]);
    `NOT s3inv(s3inv, sum[31]);
    `AND3 posand(posand, a3inv, b3inv, carryout0[30]);
    `AND3 negand(negand, a[31], b[31], s3inv);
    `OR2 overflowgate(overflow, posand, negand);

    // Checking if sum is all zero
    `OR32 zeroGate(one, sum[0],sum[1],sum[2],sum[3],sum[4],sum[5],sum[6],sum[7],sum[8],sum[9],sum[10],sum[11],sum[12],sum[13],sum[14],sum[15],sum[16],sum[17],sum[18],sum[19],sum[20],sum[21],sum[22],sum[23],sum[24],sum[25],sum[26],sum[27],sum[28],sum[29],sum[30],sum[31]);
    `NOT one2zero(zeros,one);


endmodule

`include "cpu.v"

module jump_test ();
	reg clk;

	initial clk = 0;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("asm/Flow_Control/jump_waves.vcd");
    	$dumpvars();

			//$readmemh("asm/Flow_Control/jump.text.hex", dut.mem.memory, 0);
    	$readmemh("asm/Flow_Control/jr_jal.text.hex", dut.mem.memory, 0);


    	#300
    	$finish();
    end


endmodule

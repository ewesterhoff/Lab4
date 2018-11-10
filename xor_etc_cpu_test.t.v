`include "cpu.v"

module xor_etc_cpu_test ();
	reg clk;

	initial clk = 0;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("asm/R_testing/xoretc_waves.vcd");
    	$dumpvars();

    	$readmemh("asm/R_testing/xor_add_sub_slt.text.hex", dut.mem.memory, 0);

    	#1000
    	$finish();
    end


endmodule

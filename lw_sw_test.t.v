`include "cpu.v"

module lw_sw_cpu_test ();
	reg clk;

	initial clk = 0;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("asm/Load_Store/lw_sw_waves.vcd");
    	$dumpvars();

    	$readmemh("asm/Load_Store/lw_sw.text.hex", dut.mem.memory, 0);


    	#1000
    	$finish();
    end


endmodule

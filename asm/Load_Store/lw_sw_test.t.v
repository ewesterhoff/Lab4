`include "cpu.v"

module lw_sw_cpu_test ();
	reg clk;

	initial clk = 0;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("lw_sw_waves.vcd");
    	$dumpvars();

    	$readmemh("lw_sw.text.hex", dut.InstructionMemory.memory, 0);


    	#1000
    	$finish();
    end


endmodule

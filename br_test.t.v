`include "cpu.v"

module br_test ();
	reg clk;

	initial clk = 0;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("asm/Flow_Control/br_waves.vcd");
    	$dumpvars();

    	$readmemh("asm/Flow_Control/br.text.hex", dut.mem.memory, 0);


    	#800
    	$finish();
    end


endmodule

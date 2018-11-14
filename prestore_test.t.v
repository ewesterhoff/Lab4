`include "cpu.v"

module prestore_test ();
	reg clk;

	initial clk = 0;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("asm/Load_Store/prestore_waves.vcd");
    	$dumpvars();

    	$readmemh("asm/Load_Store/prestore.text.hex", dut.mem.memory, 0);
			$readmemh("asm/Load_Store/prestore.data.hex", dut.mem.memory, 2048);

    	#1000
    	$finish();
    end


endmodule

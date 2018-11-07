`include "cpu.v"

module prestore_test ();
	reg clk;

	initial clk = 0;
	always #10 clk =! clk;

	cpu dut(.clk(clk));

    initial begin

    	$dumpfile("prestore_waves.vcd");
    	$dumpvars();

    	$readmemh("prestore_memory.text.hex", dut.dataMemory.memory, 0);
			$readmemh("prestore_memory.data.hex", dut.dataMemory.memory, 0);

    	#1000
    	$finish();
    end


endmodule

`timescale 1ns/1ps

module transmitter_tb;
	
	localparam CLOCKS_PER_PULSE = 16, //200_000_000/9600
	
	CLK_PERIOD = 10;
	logic clk=0, rstn=0, data_en=1, tx, tx_busy;
	
	reg[7:0] data_in = 8'b10101100;
	
	always #1 clk <= ~clk;
	
	transmitter #(
	.CLOCKS_PER_PULSE(CLOCKS_PER_PULSE)) dut (.*);
	
	initial begin
		$dumpfile("dump.vcd"); $dumpvars;
		repeat(2) @(posedge clk) #1;
		rstn = 1;
		data_en = 0;
		repeat(5) @(posedge clk) #1;
		wait(!tx_busy);
		$finish();
	end
endmodule
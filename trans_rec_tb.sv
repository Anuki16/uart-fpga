`timescale 1ns/1ps

module trans_rec_tb;
	
	localparam CLOCKS_PER_PULSE = 4; //200_000_000/9600
	
	localparam CLK_PERIOD = 10;
	logic clk=0, rstn=0, data_en=1, tx, tx_busy;
  	logic ready, ready_clr=1;
	
	logic[7:0] data_in = 8'b10101100;
  	logic[7:0] data_out;
	
	always #1 clk <= ~clk;
	
	transmitter #(
      .CLOCKS_PER_PULSE(CLOCKS_PER_PULSE)) trans (.*);
  
    receiver #( 
      .CLOCKS_PER_PULSE(CLOCKS_PER_PULSE)) rec (
      .clk(clk),
      .rstn(rstn),
      .ready_clr(ready_clr),
      .rx(tx),
      .ready(ready),
      .data_out(data_out)
    );
	
	initial begin
		$dumpfile("dump.vcd"); $dumpvars;
		repeat(2) @(posedge clk) #1;
		rstn <= 1;
		data_en <= 0;
		repeat(5) @(posedge clk) #1;
      	data_en <= 1;
      	wait(ready);
      	repeat(10) @(posedge clk) #1;
      	data_in <= 8'b00101011;
      	ready_clr <= 0;
      	#1 data_en <= 0;
      	repeat(5) @(posedge clk) #1;
      	data_en <= 1;
      	ready_clr <= 1;
      	wait(ready);
      	repeat(10) @(posedge clk) #1;
		$finish();
	end
endmodule
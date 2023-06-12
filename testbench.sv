`timescale 1ns/1ps

module testbench();

	localparam CLOCKS_PER_PULSE = 4;
  logic [3:0] data_in = 4'b001;
	logic clk = 0;
	logic rstn = 0;
	logic enable = 1;

	logic tx_busy;
	logic ready;
	logic [7:0] data_out;

	logic loopback;
	logic ready_clr = 1;

	uart #(.CLOCKS_PER_PULSE(CLOCKS_PER_PULSE)) 
			test_uart(.data_in(data_in),
						.data_en(enable),
						.clk(clk),
						.tx(loopback),
						.tx_busy(tx_busy),
						.rx(loopback),
						.ready(ready),
						.ready_clr(ready_clr),
						.data_out(data_out),
						.rstn(rstn)
						);
  
  
	always begin
		#1 clk = ~clk;
	end
  
	initial begin
		$dumpfile("testbench.vcd");
		$dumpvars(0, testbench);
      	rstn <= 1;
		enable <= 1'b0;
      	#2 ready_clr <= 0;
		#5 enable <= 1'b1;
		#2 ready_clr <= 1;
	end
      
  	
	always @(posedge ready) begin
		#2 ready_clr <= 0;
		#2 ready_clr <= 1;
		if (data_out != data_in) begin
			$display("FAIL: rx data %x does not match tx %x", data_out, data_in);
          $finish();
		end 
		else begin
          if (data_out == 4'b1111) begin //Check if received data is 11111111
				$display("SUCCESS: all bytes verified");
				$finish();
			end
			data_in <= data_in + 1'b1;
			enable <= 1'b0;
			#2 enable <= 1'b1;
		end
	end
endmodule
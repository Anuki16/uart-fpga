module uart #(
	parameter CLOCKS_PER_PULSE = 16
)
(
	input logic [3:0] data_in,
	input logic data_en,
	input logic clk,
	input logic rstn,
	output logic tx,
	output logic tx_busy,
	input logic ready_clr,
	input logic rx,
	output logic ready,
	output logic [3:0] data_out
);
	logic [7:0] data_input; 
	logic [7:0] data_output;

	transmitter #(.CLOCKS_PER_PULSE(CLOCKS_PER_PULSE)) uart_tx (
		.data_in(data_input),
		.data_en(data_en),
		.clk(clk),
		.rstn(rstn),
		.tx(tx),
		.tx_busy(tx_busy)
	);
	
	receiver #(.CLOCKS_PER_PULSE(CLOCKS_PER_PULSE)) uart_rx (
		.clk(clk),
		.rstn(rstn),
		.ready_clr(ready_clr),
		.rx(rx),
		.ready(ready),
		.data_out(data_output)
	);
	
	assign data_input = {4'b0, data_in};
	assign data_out = data_output[3:0];
	
endmodule
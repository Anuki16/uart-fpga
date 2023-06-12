module receiver #(
	parameter CLOCKS_PER_PULSE = 16
)
(
	input logic clk,
	input logic rstn,
	input logic ready_clr,
	input logic rx,
	output logic ready,
	output logic [7:0] data_out
);

	enum {RX_IDLE, RX_START, RX_DATA, RX_END} state;

	logic[2:0] c_bits;
	logic[$clog2(CLOCKS_PER_PULSE)-1:0] c_clocks;
	
  	logic[7:0] temp_data;
	logic rx_sync;
	
	always_ff @(posedge clk or negedge rstn) begin
	
		if (!rstn) begin
			c_clocks <= 0;
			c_bits <= 0;
			temp_data <= 8'b0;
			//data_out <= 8'b0;
			ready <= 0;
			state <= RX_IDLE;
			
		end else begin 
			rx_sync <= rx;  // Synchronize the input signal using a flip-flop
			
			case (state)
			RX_IDLE : begin
				if (rx_sync == 0) begin
					state <= RX_START;
					c_clocks <= 0;
				end
			end
			RX_START: begin
				if (c_clocks == CLOCKS_PER_PULSE/2-1) begin
					state <= RX_DATA;
					c_clocks <= 0;
				end else
					c_clocks <= c_clocks + 1;
			end
			RX_DATA : begin
				if (c_clocks == CLOCKS_PER_PULSE-1) begin
					c_clocks <= 0;
					temp_data[c_bits] <= rx_sync;
					if (c_bits == 3'd7) begin
						state <= RX_END;
						c_bits <= 0;
					end else c_bits <= c_bits + 1;
				end else c_clocks <= c_clocks + 1;
			end
			RX_END : begin
				if (c_clocks == CLOCKS_PER_PULSE-1) begin
					//data_out <= temp_data;
					ready <= 1'b1;
					state <= RX_IDLE;
					c_clocks <= 0;
				end else c_clocks <= c_clocks + 1;
			end
			default: state <= RX_IDLE;
			endcase
		end
	end
	assign data_out = temp_data;
endmodule



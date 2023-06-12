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

	logic[2:0] c_bits = 3'b0;
	logic[$clog2(CLOCKS_PER_PULSE)-1:0] c_clocks = 0;
	
  	logic[7:0] temp_data = 8'b0;
	
	always_ff @(posedge clk or negedge rstn or negedge ready_clr) begin
	
		if (!ready_clr) ready <= 1'b0;
		if (!rstn) begin
			c_clocks <= 0;
			c_bits <= 0;
			//data_out <= 0;
			ready <= 0;
			state <= RX_IDLE;
			
		end else begin 
			case (state)
			RX_IDLE : begin
				if (rx == 0) begin
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
					temp_data[c_bits] <= rx;
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



module transmitter #(
	parameter CLOCKS_PER_PULSE = 16
)
(
	input logic [7:0] data_in,
	input logic data_en,
	input logic clk,
	input logic rstn,
	output logic tx,
	output logic tx_busy
);
	enum {TX_IDLE, TX_START, TX_DATA, TX_END} state;
	
	logic[7:0] data = 8'b0;
	logic[2:0] c_bits = 3'b0;
	logic[$clog2(CLOCKS_PER_PULSE)-1:0] c_clocks = 0;
	
	always_ff @(posedge clk or negedge rstn) begin
		if (!rstn) begin
			c_clocks <= 0;
			c_bits <= 0;
			data <= 0;
          	tx <= 1'b1;
			state <= TX_IDLE;
		end else begin 
			case (state)
			TX_IDLE: begin
				if (~data_en) begin
					state <= TX_START;
					data <= data_in;
					c_bits <= 3'b0;
					c_clocks <= 0;
				end else tx <= 1'b1;
			end
			TX_START: begin
				if (c_clocks == CLOCKS_PER_PULSE-1) begin
					state <= TX_DATA;
					c_clocks <= 0;
				end else begin
					tx <= 1'b0;
					c_clocks <= c_clocks + 1;
				end
			end
			TX_DATA: begin
				if (c_clocks == CLOCKS_PER_PULSE-1) begin
					c_clocks <= 0;
					if (c_bits == 3'd7) begin
						state <= TX_END;
					end else begin
						c_bits <= c_bits + 1;
						tx <= data[c_bits];
					end
				end else begin
					tx <= data[c_bits];
					c_clocks <= c_clocks + 1;
				end
			end
			TX_END: begin
				if (c_clocks == CLOCKS_PER_PULSE-1) begin
					state <= TX_IDLE;
					c_clocks <= 0;
				end else begin
					tx <= 1'b1;
					c_clocks <= c_clocks + 1;
				end
			end
            default: state <= TX_IDLE;
			endcase
		end
	end
	assign tx_busy = (state != TX_IDLE);
	
endmodule
`timescale 1ns/1ps

module BIST(
	input Reset, clk, En, test, carry_in, FA_carry,
	input [15:0] x_in, y_in, FA_sum,
	output reg pf, FA_carry_in,
	output reg [15:0] x_out, y_out
);

	reg [3:0] counter;

	always@(posedge clk)begin
		
		if(Reset)begin
			counter <= 4'd0;
		end
		
		else begin
			
			if( test == 0 )begin
				counter <= 4'd0;
			end

			else begin

				if( counter < 4'd9 )begin
					counter <= counter + 4'd1;
				end

				else begin
					counter <= counter;
				end

			end

		end
		
	end

	always@(posedge clk)begin
		
		if(Reset)begin
			x_out <= 16'd0;
			y_out <= 16'd0;
			FA_carry_in <= 1'b0;
		end
		
		else begin
			// normal mode //
			if( test == 1'b0 )begin
				x_out <= x_in;
				y_out <= y_in;
				FA_carry_in <= carry_in;
			end
			// testing mode //
			else if( test == 1'b1 && En == 1'b1 )begin
				
				case(counter)

				4'd0: begin
					x_out <= 16'b0000_0000_0000_0000;
					y_out <= 16'b0000_0000_0000_0000;
					FA_carry_in <= 1'b0;
				end

				4'd1: begin
					x_out <= 16'b0000_0000_0000_0000;
					y_out <= 16'b1111_1111_1111_1111;
					FA_carry_in <= 1'b0;
				end

				4'd2: begin
					x_out <= 16'b0000_0000_0000_0000;
					y_out <= 16'b1111_1111_1111_1111;
					FA_carry_in <= 1'b1;
				end

				4'd3: begin
					x_out <= 16'b1111_1111_1111_1111;
					y_out <= 16'b0000_0000_0000_0000;
					FA_carry_in <= 1'b0;
				end

				4'd4: begin
					x_out <= 16'b1111_1111_1111_1111;
					y_out <= 16'b0000_0000_0000_0000;
					FA_carry_in <= 1'b1;
				end

				4'd5: begin
					x_out <= 16'b1111_1111_1111_1111;
					y_out <= 16'b1111_1111_1111_1111;
					FA_carry_in <= 1'b1;
				end

				4'd6: begin
					x_out <= 16'b0101_0101_0101_0101;
					y_out <= 16'b0101_0101_0101_0101;
					FA_carry_in <= 1'b1;
				end

				4'd7: begin
					x_out <= 16'b1010_1010_1010_1010;
					y_out <= 16'b1010_1010_1010_1010;
					FA_carry_in <= 1'b0;
				end

				endcase
				
			end

			else begin
			end
			
		end
	end
	
	always@(posedge clk)begin
		
		if(Reset)begin
			pf <= 1'bz;
		end

		else begin

			if( test == 1'b0 )begin
				pf <= 1'bz;
			end
			
			else begin
				case(counter)
				
				4'd1: begin

					if( FA_carry == 1'b0 && FA_sum == 16'b0000_0000_0000_0000 )begin
						pf <= 1'b0;
					end
					else begin
						pf <= 1'b1;
					end

				end

				4'd2: begin

					if( FA_carry == 1'b0 && FA_sum == 16'b1111_1111_1111_1111 )begin
						pf <= 1'b0;
					end
					else begin
						pf <= 1'b1;
					end

				end

				4'd3: begin

					if( FA_carry == 1'b1 && FA_sum == 16'b0000_0000_0000_0000 )begin
						pf <= 1'b0;
					end
					else begin
						pf <= 1'b1;
					end

				end

				4'd4: begin

					if( FA_carry == 1'b0 && FA_sum == 16'b1111_1111_1111_1111 )begin
						pf <= 1'b0;
					end
					else begin
						pf <= 1'b1;
					end

				end

				4'd5: begin

					if( FA_carry == 1'b1 && FA_sum == 16'b0000_0000_0000_0000 )begin
						pf <= 1'b0;
					end
					else begin
						pf <= 1'b1;
					end

				end

				4'd6: begin

					if( FA_carry == 1'b1 && FA_sum == 16'b1111_1111_1111_1111 )begin
						pf <= 1'b0;
					end
					else begin
						pf <= 1'b1;
					end

				end

				4'd7: begin

					if( FA_carry == 1'b0 && FA_sum == 16'b1010_1010_1010_1011 )begin
						pf <= 1'b0;
					end
					else begin
						pf <= 1'b1;
					end

				end

				4'd8: begin

					if( FA_carry == 1'b1 && FA_sum == 16'b0101_0101_0101_0100 )begin
						pf <= 1'b0;
					end
					else begin
						pf <= 1'b1;
					end

				end

				default: begin

					pf <= 1'b0;

				end

				endcase
			end
		end
	end

endmodule



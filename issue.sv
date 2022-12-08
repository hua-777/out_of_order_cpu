`timescale 1ns/1ns // Tell Questa what time scale to run at
import rezzmaster::*;

module issue(clk,
				op_type,
				f_u,
				rstation,
				index,
				res_station,
				func_unit,
				);	
				
	input clk;
	input reg [5:0] index;
	input reg [6:0] op_type;
	input reg [2:0] f_u;
	input reservation_station rstation;
	output reservation_station res_station;
	output reg [2:0] func_unit;
	
	initial begin
	assign res_station = rstation;
	assign func_unit = f_u;
	end
	
	always @ (posedge clk) begin
	
	if (op_type) begin
	
	if (f_u[0]) begin
		assign func_unit[0] = 0;
		assign res_station[index].inuse = 0;
		end
	else
		begin
			if (f_u[1]) begin
				assign func_unit[1] = 0;
				assign res_station[index].inuse = 0;
				end
		end
	end
	
	else begin
		if (f_u[2]) begin
			assign func_unit[2] = 0;
			assign res_station[index].inuse = 0;
			end
	end
	
	end
				
endmodule 
`timescale 1ns/1ns // Tell Questa what time scale to run at
import rezzmaster::*;

module dispatch(clk,
				rs1,
				rs2,
				rd,
				imm,
				free_pool,
				freepool,
				re_station,
				rstation,
				mem,
				fu,
				);
				

	input clk;
	input reg [4:0] rs1;
	input reg [4:0] rs2;
	input reg [4:0] rd;
	input reg [31:0] imm;
	input reservation_station re_station;
	input reg free_pool [63:0];
	output reg freepool [63:0];
	output reservation_station rstation;
	
	input logic [6:0] mem [31:0];
	input logic [2:0] fu;
	
	integer k;
	reg [4:0] j;

	always @ (posedge clk) begin	
	
	reg [6:0] rd_value;
	reg [6:0] rs1_value;
	reg [6:0] rs2_value;
	reg rs1_ready;
	reg rs2_ready;
	reg f_u;
	reg rob;
	
	assign rd_value = mem[rd];
	assign rs1_value = mem[rs1];
	assign rs2_value = mem[rs2];
	assign rs1_ready = freepool[rs1];
	assign rs2_ready = freepool[rs2];
	
	for (k=0; k<3; k=k+1) begin
		if (fu[k] == 1)
		break;
	end 
	
	assign f_u = fu[k];
		
	assign rob = 0;
	

			
	for (j = 0; j < 32; j = j+1) begin
		if (!(rstation[j].inuse))
			break;
	end
	
	rstation[j] = '{1, rd, rd_value, rs1, rs1_value, rs1_ready, rs2, rs2_value, rs2_ready, f_u, rob};
	
	end
	
endmodule
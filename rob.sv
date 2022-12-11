`timescale 1ns/1ns // Tell Questa what time scale to run at
import respackage::*;

module rob(clk,
				curr_dest_reg_1,
				old_dest_reg_1,
				rob_index_1,
				curr_dest_reg_2,
				old_dest_reg_2,
				rob_index_2,
				free_regs_r,
				inst_1_index,
				inst_2_index,
				inst_3_index,
				line1_i,
				line2_i,
				line3_i,
				line1_val_i,
				line2_val_i,
				line3_val_i,
				num_retired,
				opcode_inst1_o,
				opcode_inst2_o,
				inst1_val_o,
				inst2_val_o,
				);
				
	typedef struct {
	reg in_use;
	reg is_complete;
	reg [5:0] old_d_reg; 
	reg [5:0] curr_d_reg;
	reg [6:0] rd_opcode;
	reg [5:0] rd_value;
	} rob_entry;
	
	typedef rob_entry reorder_buffer [32];
	
	reg [5:0] head;
	
	reorder_buffer rob;
	
	input [2:0] reg func_units_flag;
								
	input reg clk;
	input reg [4:0] old_dest_reg_1;
	input reg [4:0] curr_dest_reg_1;
	input reg [4:0] rob_index_1;
	
	input reg [4:0] old_dest_reg_2;
	input reg [4:0] curr_dest_reg_2;
	input reg [4:0] rob_index_2;
	
	output free_regs_r [63:0]; 
	
	reg [6:0] rob [31:0];
	
	input res_entry line1_i;
	input res_entry line2_i;
	input res_entry line3_i;
	
	input reg [5:0] line1_val_i;
	input reg [5:0] line2_val_i;
	input reg [5:0] line3_val_i;
	 
	output reg [5:0] inst1_val_o;
	output reg [5:0] inst2_val_o;

	output reg [6:0] opcode_inst1_o;
	output reg [6:0] opcode_inst2_o;	
	
	output reg [1:0] num_retired;

	initial begin
		head = 0;
		integer i;
		//Initialize freeregs
		free_regs_r = 0;	
		//Initialize ROB 
		for (i=0; i<32; i=i+1) begin
			rob[i] = '{0, 0, 0, 0, 0, 0};
		end	
	end
	
	
	always @ (posedge clk) begin
	
		free_regs_r = 0; 
		rob[rob_index_1] = '{1, 0, old_dest_reg_1, curr_dest_reg_1, 0, 0};
		rob[rob_index_2] = '{1, 0, old_dest_reg_2, curr_dest_reg_2, 0, 0};
		
		if (func_units_flag == 3'b001)
			rob[line1_i.rob_index].is_complete = 1; 
			rob[line1_i.rob_index].rd_opcode = line1_i.opcode;
			rob[line1_i.rob_index].rd_value = line1_val_i;
		if (func_units_flag == 3'b010)
			rob[line2_i.rob_index].is_complete = 1;
			rob[line2_i.rob_index].rd_opcode = line2_i.opcode;
			rob[line2_i.rob_index].rd_value = line2_val_i;
		if (func_units_flag == 3'b100)
			rob[line3_i.rob_index].is_complete = 1;
			rob[line3_i.rob_index].rd_opcode = line3_i.opcode;
			rob[line3_i.rob_index].rd_value = line3_val_i;
		
		
		num_retired = 0;
		if (rob[head].iscomplete) begin
			free_regs_r = (1 << rob[head].old_d_reg) | free_regs_r;
			rob[head].in_use = 0;
			inst1_val_o = rob[head].rd_value;
			opcode_inst1_o = rob[head].rd_opcode;
			head = head + 1;
			num_retired = 1;
		end
		if (rob[head].iscomplete) begin
			free_regs_r = (1 << rob[head].old_d_reg) | free_regs_r;
			rob[head].in_use = 0;
			inst1_val_o = rob[head].rd_value;
			opcode_inst1_o = rob[head].rd_opcode;
			head = head + 1;
			num_retired = 2;
		end
		
		
			
	end

	
	
endmodule
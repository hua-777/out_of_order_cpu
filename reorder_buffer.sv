`timescale 1ns/1ns // Tell Questa what time scale to run at


module reorder_buffer
import my_package::*;
(
				clk,
				clk_counter,
				curr_dest_reg_1,
				old_dest_reg_1,
				curr_dest_reg_2,
				old_dest_reg_2,
				line1_i,
				line2_i,
				line3_i,
				line1_val_i,
				line2_val_i,
				line3_val_i,
				num_retired,
				rob_o_1,
				rob_o_2,
				func_units_flag
				);
				

	
	reg [4:0] head;
	
									
	input reg clk;
	input reg [31:0] clk_counter;
	input reg [5:0] old_dest_reg_1;
	input reg [5:0] curr_dest_reg_1;
	//input reg [4:0] rob_index_1;
	
	input reg [5:0] old_dest_reg_2;
	input reg [5:0] curr_dest_reg_2;
	//input reg [4:0] rob_index_2;
	
	//output reg [63:0] free_regs_r; 
		
	input res_entry line1_i;
	input res_entry line2_i;
	input res_entry line3_i;
	
	input reg [31:0] line1_val_i;
	input reg [31:0] line2_val_i;
	input reg [31:0] line3_val_i;
	 
	//output reg [31:0] inst1_val_o;
	//output reg [31:0] inst2_val_o;

	//output reg [6:0] opcode_inst1_o;
	//output reg [6:0] opcode_inst2_o;	
	output reg [1:0] num_retired;

	output rob_entry rob_o_1;
	output rob_entry rob_o_2;
	
	input reg [2:0] func_units_flag;
	
	generic_buffer rob;

	reg [4:0] current_rob_index = 0;
	
	integer i;

	initial begin
	
		head = 0;
		//Initialize ROB 
		for (i=0; i<32; i=i+1) begin
			rob[i] = '{0, 0, 0, 0, 0, 0, 0};
		end	
	
	end
	
	
	always @ (posedge clk) begin
	
		if (clk_counter > 3) begin
			//free_regs_r = 0; 
			num_retired = 0;
			if (rob[head].is_complete) begin
				//free_regs_r = (1 << rob[head].old_d_reg) | free_regs_r;
				rob_o_1 = rob[head];
				rob[head].in_use = 0;
				//inst1_val_o = rob[head].rd_value;
				//opcode_inst1_o = rob[head].rd_opcode;
				head = head + 1;
				num_retired = 1;
			end
			if (rob[head].is_complete) begin
				//free_regs_r = (1 << rob[head].old_d_reg) | free_regs_r;
				rob_o_2 = rob[head];
				rob[head].in_use = 0;
				//inst2_val_o = rob[head].rd_value;
				//opcode_inst2_o = rob[head].rd_opcode;
				head = head + 1;
				num_retired = 2;
			end
		
			rob[current_rob_index] = '{1, 0, old_dest_reg_1, curr_dest_reg_1, 0, 0, 0};
			current_rob_index = current_rob_index + 1;
			rob[current_rob_index] = '{1, 0, old_dest_reg_2, curr_dest_reg_2, 0, 0, 0};
			current_rob_index = current_rob_index + 1;

			if (!func_units_flag[0]) begin
				rob[line1_i.rob_index].is_complete = 1; 
				rob[line1_i.rob_index].rd_opcode = line1_i.opcode;
				rob[line1_i.rob_index].rd_value = line1_val_i;
				rob[line1_i.rob_index].rs1_value = line1_i.source_1;
			end
			if (!func_units_flag[1]) begin
				rob[line2_i.rob_index].is_complete = 1;
				rob[line2_i.rob_index].rd_opcode = line2_i.opcode;
				rob[line2_i.rob_index].rd_value = line2_val_i;
				rob[line2_i.rob_index].rs1_value = line2_i.source_1;
			end
			if (!func_units_flag[2]) begin
				rob[line3_i.rob_index].is_complete = 1;
				rob[line3_i.rob_index].rd_opcode = line3_i.opcode;
				rob[line3_i.rob_index].rd_value = line3_val_i;
				rob[line3_i.rob_index].rs1_value = line3_i.source_1;
			end
			
		end
		
	end

	
	
endmodule
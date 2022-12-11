`timescale 1ns/1ns // Tell Questa what time scale to run at

module rob(clk,
				curr_dest_reg_1,
				old_dest_reg_1,
				rob_index_1,
				curr_dest_reg_2,
				old_dest_reg_2,
				rob_index_2,
				free_regs_r,
				flag_fu_1,
				flag_fu_2,
				flag_fu_3,
				inst_1_index,
				inst_2_index,
				inst_3_index,
				);
				
	typedef struct {
	reg in_use;
	reg is_complete;
	reg [5:0] old_d_reg; 
	reg [5:0] curr_d_reg;
	} rob_entry;
	
	typedef rob_entry reorder_buffer [32];
	
	integer head;
	
	reorder_buffer rob;
								
	input reg clk;
	input reg [4:0] old_dest_reg_1;
	input reg [4:0] curr_dest_reg_1;
	input reg [4:0] rob_index_1;
	
	input reg [4:0] old_dest_reg_2;
	input reg [4:0] curr_dest_reg_2;
	input reg [4:0] rob_index_2;
	
	output free_regs_r [63:0]; 
	
	reg [6:0] rob [31:0];

	initial begin
		head = 0;
		integer i;
		//Initialize freeregs
		for (i=0; i<63; i=i+1) begin
			free_regs_r[i] = 0;
		end		
		//Initialize ROB 
		for (i=0; i<32; i=i+1) begin
			rob[i] = '{0, 0, 0, 0};
		end	
	end
	
	
	always @ (posedge clk) begin
		rob[rob_index_1] = '{1, 0, old_dest_reg_1, curr_dest_reg_1};
		rob[rob_index_2] = '{1, 0, old_dest_reg_2, curr_dest_reg_2};
		
		if (flag_fu_1)
			rob[inst_1_index].is_complete = 1;
		if (flag_fu_2)
			rob[inst_2_index].is_complete = 1;
		if (flag_fu_3)
			rob[inst_2_index].is_complete = 1;
		
		if (rob[head].iscomplete) begin
			free_regs_r[rob[head].old_d_reg] = 1;
			rob[head].in_use = 0;
			head = head + 1;
		end
		if (rob[head].iscomplete) begin
			free_regs_r[rob[head].old_d_reg] = 1;
			free_regs_r[rob[head].old_d_reg] = 1;
			rob[head].in_use = 0;
			head = head + 1;
		end
		
		
			
	end

	
	
endmodule
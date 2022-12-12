import my_package::*;

module writeback(
			clk,
			rob_o_1,
			rob_o_2,
			num_retired,
			
			reg_ready_o,
			free_regs,
			register_file,
			memory
			);
			
		input clk;
		input rob_entry rob_o_1;
		input rob_entry rob_o_2;
		input reg [1:0] num_retired;
		
		output reg [63:0] reg_ready_o;
		output reg [63:0] free_regs; 

		output reg [31:0] register_file [0:63];
		output reg [31:0] memory [0:63];
		
			
		initial begin	
			integer i;
			//Initialize Registers
			for (i=0; i<64; i=i+1) begin
				register_file[i] = 0;
			end
			//Initialize Memory 
			for (i=0; i<64; i=i+1) begin
				memory[i] = 0;
			end
		end
		
		always @ (posedge clk) begin
			free_regs = 0;
			reg_ready_o = 0;
			if(num_retired == 1) begin
				if (rob_o_1.rd_opcode == 7'b0100011) begin
					memory[rob_o_1.rd_value] = rob_o_1.rs2_value;
				end
				else begin
					register_file[rob_o_1.curr_d_reg] = rob_o_1.rd_value;
					free_regs = (1 << rob_o_1.old_d_reg) | free_regs;
					reg_ready_o = (1 << rob_o_1.curr_d_reg) | reg_ready_o;
				end
			end
			else if (num_retired == 2) begin
				if (rob_o_1.rd_opcode == 7'b0100011) begin
					memory[rob_o_1.rd_value] = rob_o_1.rs2_value;
				end
				else begin
					register_file[rob_o_1.curr_d_reg] = rob_o_1.rd_value;
					free_regs = (1 << rob_o_1.old_d_reg) | free_regs;
					reg_ready_o = (1 << rob_o_1.curr_d_reg) | reg_ready_o;
				end
				
				if (rob_o_2.rd_opcode == 7'b0100011) begin
					memory[rob_o_2.rd_value] = rob_o_2.rs2_value;
				end
				else begin
					register_file[rob_o_2.curr_d_reg] = rob_o_2.rd_value;
					free_regs = (1 << rob_o_2.old_d_reg) | free_regs;
					reg_ready_o = (1 << rob_o_2.curr_d_reg) | reg_ready_o;

				end
			end
			else begin
			
			end
			
		
		end
endmodule
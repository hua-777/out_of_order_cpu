`timescale 1ns/1ns // Tell Questa what time scale to run at

module reservation_station
import my_package::*;

(
				clk,
				clk_counter,
				
				rs1_1,
				rs2_1,
				rd_1,
				imm_1,
				alu_op_1,
				opcode_1,
				
				rs1_2,
				rs2_2,
				rd_2,
				imm_2,
				alu_op_2,
				opcode_2,
				
				line_1,
				line_2,
				line_3,				
				

				register_file,
				func_units,
				//full
				
				val_1,
				val_2,
				val_3,
				line_1_o,
				line_2_o,
				line_3_o,	
				func_units_o,
	
				reg_ready_o,
				
				ready_reg_1,
				ready_reg_2,
				num_retired_o
				);
	
	input clk;
	input reg [31:0] clk_counter;

	input reg [5:0] rs1_1;
	input reg [5:0] rs2_1;
	input reg [5:0] rd_1;
	input reg [31:0] imm_1;
	input reg [2:0] alu_op_1;
	input reg [6:0] opcode_1;
	
	input reg [5:0] rs1_2;
	input reg [5:0] rs2_2;
	input reg [5:0] rd_2;
	input reg [31:0] imm_2;
	input reg [2:0] alu_op_2;
	input reg [6:0] opcode_2;
	
	output res_entry line_1;
	output res_entry line_2;
	output res_entry line_3;
	
	input reg [31:0] register_file [0:63];

	output reg [2:0] func_units;
	
	input reg [31:0] val_1;
	input reg [31:0] val_2;
	input reg [31:0] val_3;
	input res_entry line_1_o;
	input res_entry line_2_o;
	input res_entry line_3_o;	
	input reg [2:0] func_units_o;
	
	input reg [63:0] reg_ready_o;
	
	input reg [31:0] ready_reg_1;
	input reg [31:0] ready_reg_2;
	input reg [1:0] num_retired_o;

	//output full;
		
	reg [63:0] reg_ready ; // dont forget to initialize reg_ready to all ones
	
	reg [63:0] temp_reg_ready ;
	
	integer i = 0;
		
	generic_table rs_table;
	
	reg current_fu = 0;
	
	integer size = 0;
	
	reg [4:0] current_rob_index = 0;
	
	initial begin
	
		for (i=0; i<64; i=i+1) begin
			reg_ready[i] = 1;
			temp_reg_ready[i] = 1;
		end
		
		for (i = 0; i < 32; i=i+1) begin
			rs_table[i] = '{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
		end
	end
	
	always @ (posedge clk) begin	
		if (clk_counter > 3) begin
			reg_ready = reg_ready | reg_ready_o;
			func_units = 3'b111;
			//--------------------
			// dispatch logic
			for (i = 0; i < 32; i = i+1) begin
				if (!(rs_table[i].inuse))
					break;
			end
			// non memory type
			if (opcode_1 ==  7'b0110011 || opcode_1 == 7'b0010011) begin
				rs_table[i] = '{1, alu_op_1, opcode_1, rd_1, rs1_1, register_file[rs1_1], rs2_1, register_file[rs2_1], imm_1, current_fu, current_rob_index};
				current_fu = !current_fu;
			end
			// memory type
			else if (opcode_1 == 7'b0000011 || opcode_1 == 7'b0100011) begin
				rs_table[i] = '{1, alu_op_1, opcode_1, rd_1, rs1_1, register_file[rs1_1], rs2_1, register_file[rs2_1], imm_1, 2, current_rob_index};
			end
			else begin
				// invalid opcode!
			end
			
			if (opcode_1 != 7'b0100011) begin
				reg_ready[rd_1] = 0;
			end
			
			current_rob_index = current_rob_index + 5'b00001;
			
			// dispatch logic
			for (i = 0; i < 32; i = i+1) begin
				if (!(rs_table[i].inuse))
					break;
			end
			// non memory type
			if (opcode_2 ==  7'b0110011 || opcode_2 == 7'b0010011) begin
				rs_table[i] = '{1, alu_op_2, opcode_2, rd_2, rs1_2, register_file[rs1_2], rs2_2, register_file[rs2_2], imm_2, current_fu, current_rob_index};
				

				current_fu = !current_fu;
			end
			// memory type
			else if (opcode_2 == 7'b0000011 || opcode_2 == 7'b0100011) begin
				rs_table[i] = '{1, alu_op_2, opcode_2, rd_2, rs1_2, register_file[rs1_2], rs2_2, register_file[rs2_2], imm_2, 2, current_rob_index};
			end
			else begin
				// invalid opcode!
			end
			
			if (opcode_2 != 7'b0100011) begin
				reg_ready[rd_2] = 0;
			end
			
			current_rob_index = current_rob_index + 5'b00001;

			size = size + 2;
			// ------------------------
			// forwarding logic
			
			// FORWARDING FROM ISSUE
			temp_reg_ready = reg_ready;
			
			if (~func_units_o[0]) begin
				temp_reg_ready = temp_reg_ready | (1 << line_1_o.rd);
				// now iterate through the reservation table looking for rs1 or rs2 that matches line_1_o.rd
				for (i = 0; i < 32; i=i+1) begin
					if (rs_table[i].rs1 == line_1_o.rd) begin
						rs_table[i].source_1 = val_1;
					end
					if (rs_table[i].rs2 == line_1_o.rd) begin
						rs_table[i].source_2 = val_1;
					end
				end
				
			end
			if (~func_units_o[1]) begin
				temp_reg_ready = temp_reg_ready | (1 << line_2_o.rd);
				// now iterate through the reservation table looking for rs1 or rs2 that matches line_2_o.rd
				for (i = 0; i < 32; i=i+1) begin
					if (rs_table[i].rs1 == line_2_o.rd) begin
						rs_table[i].source_1 = val_2;
					end
					if (rs_table[i].rs2 == line_2_o.rd) begin
						rs_table[i].source_2 = val_2;
					end
				end
				
			end
			if (~func_units_o[2]) begin
				temp_reg_ready = temp_reg_ready | (1 << line_3_o.rd);
				// now iterate through the reservation table looking for rs1 or rs2 that matches line_3_o.rd
				//if (opcode is not sw) since sw doesnt have a rd so no point in forwarding
				if (line_3_o.opcode != 7'b0100011) begin
					for (i = 0; i < 32; i=i+1) begin
						if (rs_table[i].rs1 == line_3_o.rd) begin
							rs_table[i].source_1 = val_3;
						end
						if (rs_table[i].rs2 == line_3_o.rd) begin
							rs_table[i].source_2 = val_3;
						end
					end
				end
			end

			// FORWARDING FROM WRITEBACK
			if (num_retired_o == 1) begin
				for (i = 0; i < 32; i=i+1) begin
					if (rs_table[i].rs1 == ready_reg_1) begin
						rs_table[i].source_1 = register_file[rs_table[i].rs1];
					end
					if (rs_table[i].rs2 == ready_reg_1) begin
						rs_table[i].source_2 = register_file[rs_table[i].rs2];
					end
				end
			end
			else if (num_retired_o == 2) begin
				for (i = 0; i < 32; i=i+1) begin
						if (rs_table[i].rs1 == ready_reg_1) begin
							rs_table[i].source_1 = register_file[rs_table[i].rs1];
						end
						if (rs_table[i].rs2 == ready_reg_1) begin
							rs_table[i].source_2 = register_file[rs_table[i].rs2];
						end
						
						if (rs_table[i].rs1 == ready_reg_2) begin
							rs_table[i].source_1 = register_file[rs_table[i].rs1];
						end
						if (rs_table[i].rs2 == ready_reg_2) begin
							rs_table[i].source_2 = register_file[rs_table[i].rs2];;
						end
						
					end
				end
				
			else begin
			
			end
			
			// ------------------------
			// issue logic
			for (i = 0; i < 32; i = i+1) begin
				if (rs_table[i].inuse) begin
					// check if both source registers are ready
					// R TYPE: ADD, SUB, XOR, SRA // S TYPE: SW
					if (rs_table[i].opcode == 7'b0110011 || rs_table[i].opcode == 7'b0100011) begin
						if (temp_reg_ready[rs_table[i].rs1] && temp_reg_ready[rs_table[i].rs2] && func_units[rs_table[i].func_unit]) begin
							// ready to issue
							if (rs_table[i].func_unit == 0) begin
								line_1 = rs_table[i]; // the problem is that when issuing an insturction its not grabbing a new saved value from the reg file, it uses the old one that was loaded in
								// this is because forwarding assumes that the new value is always forwarded in, but thats not always the case. Thus for the xor instruction x3 value stays 0 and is 
								// never upated to 15 as it should be. 
								// SOLUTION: writeback updates all register values within the reservation station too
								func_units[0] = 0;
							end
							else if (rs_table[i].func_unit == 1) begin
								line_2 = rs_table[i];
								func_units[1] = 0;
							end
							else begin
								line_3 = rs_table[i];
								func_units[2] = 0;
							end
							rs_table[i].inuse = 0;
							size = size - 1;
						end
					end
					// I TYPE: ADDI, ANDI // I TYPE: LW
					else if (rs_table[i].opcode == 7'b0010011 || rs_table[i].opcode == 7'b0000011) begin
						if (temp_reg_ready[rs_table[i].rs1] && func_units[rs_table[i].func_unit]) begin
							// ready to issue
							if (rs_table[i].func_unit == 0) begin
								line_1 = rs_table[i];
								func_units[0] = 0;
							end
							else if (rs_table[i].func_unit == 1) begin
								line_2 = rs_table[i];
								func_units[1] = 0;
							end
							else begin
								line_3 = rs_table[i];
								func_units[2] = 0;
							end
							rs_table[i].inuse = 0;
							size = size - 1;
						end
					end
				end
			end
		end
	end
	
	
endmodule
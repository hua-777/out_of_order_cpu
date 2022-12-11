`timescale 1ns/1ns // Tell Questa what time scale to run at
import respackage::*;

module issue(
	clk,

	line_1,
	line_2,
	line_3,
	
	line_1_o,
	line_2_o,
	line_3_o,
	
	val_1,
	val_2,
	val_3,
	
	
	register_file,
	memory,

	func_units,
	func_units_o
);

	input res_entry line_1;
	input res_entry line_2;
	input res_entry line_3;
	
	output res_entry line_1_o;
	output res_entry line_2_o;
	output res_entry line_3_o;	
	
	input reg [31:0] register_file [0:63];
	input reg [31:0] memory [0:1023];
	
	input reg [2:0] func_units;
	output reg [2:0] func_units_o;
	
	always @ (posedge clk) begin
		func_units_o = func_units;
		if (func_units[0]) begin
			// R TYPE: ADD, SUB, XOR, SRA
			if (line_1.opcode == 7'b0110011) begin
				// ADD
				if (line_1.alu_op == 3'b000) begin
					val_1 = register_file[line_1.rs1] + register_file[line_1.rs2];
				end
				// SUB
				else if (line_1.alu_op == 3'b001) begin
					val_1 = register_file[line_1.rs1] - register_file[line_1.rs2];
				end
				// XOR
				else if (line_1.alu_op == 3'b010) begin
					val_1 = register_file[line_1.rs1] ^ register_file[line_1.rs2];
				end
				// SRA
				else if (line_1.alu_op == 3'b011) begin
					val_1 = register_file[line_1.rs1] >>> register_file[line_1.rs2];
				end
				// invalid alu_op
				else begin
					
				end
			end
			// I TYPE: ADDI, ANDI
			else if (line_1.opcode == 7'b0010011) begin
				// ADDI
				if (line_1.alu_op == 3'b000) begin
					val_1 = register_file[line_1.rs1] + line_1.imm;
				end
				// ANDI
				else if (line_1.alu_op == 3'b100) begin
					val_1 = register_file[line_1.rs1] & line_1.imm;
				end
				// invalid alu_op
				else begin
				
				end
			
			end
			// invalid opcode
			else begin
			
			end
		end
		
		
		if (func_units[1]) begin
			// R TYPE: ADD, SUB, XOR, SRA
			if (line_2.opcode == 7'b0110011) begin
				// ADD
				if (line_2.alu_op == 3'b000) begin
					val_2 = register_file[line_2.rs1] + register_file[line_2.rs2];
				end
				// SUB
				else if (line_2.alu_op == 3'b001) begin
					val_2 = register_file[line_2.rs1] - register_file[line_2.rs2];
				end
				// XOR
				else if (line_2.alu_op == 3'b010) begin
					val_2 = register_file[line_2.rs1] ^ register_file[line_2.rs2];
				end
				// SRA
				else if (line_2.alu_op == 3'b011) begin
					val_2 = register_file[line_2.rs1] >>> register_file[line_2.rs2];
				end
				// invalid alu_op
				else begin
					
				end
			end
			// I TYPE: ADDI, ANDI
			else if (line_2.opcode == 7'b0010011) begin
				// ADDI
				if (line_2.alu_op == 3'b000) begin
					val_2 = register_file[line_2.rs1] + line_2.imm;
				end
				// ANDI
				else if (line_2.alu_op == 3'b100) begin
					val_2 = register_file[line_2.rs1] & line_2.imm;
				end
				// invalid alu_op
				else begin
				
				end
			
			end
			// invalid opcode
			else begin
			
			end
		end
		
		if (func_units[2]) begin
			// I TYPE: LW
			if (line_3.opcode == 7'b0000011) begin
				val_3 = memory[register_file[line_3.rs1] + line_3.imm];
			end
			// S TYPE: SW
			else if (line_3.opcode == 7'b0100011) begin
				val_3 = register_file[line_3.rs1] + line_3.imm;
			end
			// invalid opcode
			else begin
			
			end
		end
	end

endmodule
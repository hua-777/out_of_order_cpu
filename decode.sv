`timescale 1ns/1ns // Tell Questa what time scale to run at

module decode(clk,
				inst,
				rs1,
				rs2,
				rd,
				imm,
				alu_op,
				alu_src,
				mem_to_reg,
				reg_write,
				mem_read,
				mem_write
				);
				
	input reg clk;
	input reg [31:0] inst;
	output reg [4:0] rs1;
	output reg [4:0] rs2;
	output reg [4:0] rd;
	output reg [31:0] imm;
	
	output reg [2:0] alu_op;
	output reg alu_src;
	
	output reg mem_to_reg;
	
	output reg reg_write;
	
	output reg mem_read;
	output reg mem_write;

	wire [6:0] opcode;
	
	wire [2:0] funct3;
	
	wire [6:0] funct7;
	
	assign opcode = inst[6:0];
	
	assign funct3 = inst[14:12];
	
	assign funct7 = inst[31:25];
	
	// initialize all outputs to 0
	initial begin
	
	end
	
	// ADD, SUB, ADDI, XOR, ANDI, SRA, LW, SW

	always @ (posedge clk) begin
		
		rs1 <= inst[19:15];
		
		rs2 <= inst[24:20];
		
		// R TYPE: ADD, SUB, XOR, SRA
		if (opcode == 7'b0110011) begin
			imm <= 0;
			alu_src <= 0;
			mem_to_reg <= 0;
			// ADD or SUB
			if (funct3 == 3'b000) begin
				// ADD
				if (funct7 == 7'b0000000) begin
					alu_op <= 3'b000;
				end
				// SUB
				else if (funct7 == 7'b0100000) begin
					alu_op <= 3'b001;
				end
				// DEFAULT NO OP
				else begin
					alu_op <= 3'b000;
				end
			end
			// XOR
			else if (funct3 == 3'b100) begin
				alu_op <= 3'b010;
			end
			// SRA
			else if (funct3 == 3'b101) begin
				alu_op <= 3'b011;
			end
			// DEFAULT NO OP
			else begin
				alu_op <= 3'b000;
			end
		end
		// I TYPE: ADDI, ANDI
		else if (opcode == 7'b0010011) begin
			alu_src <= 1;
			mem_to_reg <= 0;
			// ADDI
			if (funct3 == 3'b000) begin
				imm[11:0] <= inst[31:20];
				imm[31:12] <= 0;
				alu_op <= 3'b000;
			end
			// ANDI
			else if (funct3 == 3'b111) begin
				imm[11:0] <= inst[31:20];
				imm[31:12] <= 0;
				alu_op <= 3'b100;
			end
			// DEFAULT NO OP
			else begin
				imm <= 0;
				alu_op <= 3'b000;
			end
		end
		// I TYPE: LW
		else if (opcode == 7'b0000011) begin
			alu_src <= 1;
			alu_op <= 3'b000;
			mem_to_reg <= 1;
			// LW
			if (funct3 == 3'b010) begin
				imm[11:5] <= inst[31:20];
				imm[31:12] <= 0;
			end
			// DEFAULT NO OP
			else begin
				imm <= 0;
			end
		end
		// S TYPE: SW
		else if (opcode == 7'b0100011)begin
			alu_src <= 1;
			alu_op <= 3'b000;
			mem_to_reg <= 0; // this value is irrelevant since we don't write to a destination register
			// SW
			if (funct3 == 3'b010) begin
				imm[11:5] <= inst[31:25];
				imm[4:0] <= inst[11:7];
				imm[31:12] <= 0;
			end
			// DEFAULT NO OP
			else begin
				imm <= 0;
			end
		end
		// DEFAULT NO OP
		else begin
			alu_src <= 0;
			imm <= 0;
			mem_to_reg <= 0;
		end
		
		
	end

	
	
endmodule



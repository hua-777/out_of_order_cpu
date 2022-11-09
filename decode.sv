`timescale 1ns/1ns // Tell Questa what time scale to run at

module decode(clk,
				inst);
				
	input reg clk;
	input reg [31:0] inst1;
	output reg [4:0] rs1;
	output reg [4:0] rs2;
	output reg [4:0] rd;
	output reg [31:0] imm;
	
	
	assign wire [6:0] opcode = inst[6:0];
	
	assign wire [2:0] funct3 = inst[14:12];
	
	assign wire [6:0] funct7 = inst[31:25];
	
	
	always @ (posedge clk) begin
		
		rs1 <= inst[19:15];
		
		rst2 <= inst[24:20];
		
		// R TYPE: ADD, SUB, XOR, SRA
		if (opcode == 7'b0110011) begin
			// ADD or SUB
			if (funct3 == 3'b000) begin
				// ADD
				if (funct7 == 7'b0000000) begin
				
				end
				// SUB
				else if (funct7 == 7'b0100000) begin
				
				end
				// DEFAULT NO OP
				else begin
				
				end
			end
			// XOR
			else if (funct3 == 3'b100) begin
			
			end
			// SRA
			else if (funct3 == 3'b101) begin
			
			end
			// DEFAULT NO OP
			else begin
			
			end
		end
		// I TYPE: ADDI, ANDI
		else if (opcode == 7'b0010011) begin
			// ADDI
			if (funct3 == 3'b000) begin
			
			end
			// ANDI
			else if (funct3 == 3'b111) begin
			
			end
			// DEFAULT NO OP
			else begin
			
			end
		end
		// I TYPE: LW
		else if (opcode == 7'b0000011) begin
		
		end
		// S TYPE: SW
		else if (opcode == 7'b0100011)begin
		
		end
		// DEFAULT NO OP
		else begin
		
		end
		
	end

	
	
endmodule



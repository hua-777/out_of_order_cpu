`timescale 1ns/1ns // Tell Questa what time scale to run at

module reservation_station(
				clk,
				
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
				
				rs1_o_1,
				rs2_o_1,
				rd_o_1,
				imm_o_1,
				alu_op_o_1,
				opcode_o_1,
				
				rs1_o_2,
				rs2_o_2,
				rd_o_2,
				imm_o_2,
				alu_op_o_2,
				opcode_o_2,		
								
				rs1_o_3,
				rs2_o_3,
				rd_o_3,
				imm_o_3,
				alu_op_o_3,
				opcode_o_3,					
								
				free_pool,
				new_func_units,
				
				full
				);
	
	input clk;
	
	input reg [4:0] rs1_1;
	input reg [4:0] rs2_1;
	input reg [4:0] rd_1;
	input reg [31:0] imm_1;
	input reg [2:0] alu_op_1;
	input reg [6:0] opcode_1;
	
	input reg [4:0] rs1_2;
	input reg [4:0] rs2_2;
	input reg [4:0] rd_2;
	input reg [31:0] imm_2;
	input reg [2:0] alu_op_2;
	input reg [6:0] opcode_2;
	
	output reg [4:0] rs1_o_1;
	output reg [4:0] rs2_o_1;
	output reg [4:0] rd_o_1;
	output reg [31:0] imm_o_1;
	output reg [2:0] alu_op_o_1;
	output reg [6:0] opcode_o_1;
	
	output reg [4:0] rs1_o_2;
	output reg [4:0] rs2_o_2;
	output reg [4:0] rd_o_2;
	output reg [31:0] imm_o_2;
	output reg [2:0] alu_op_o_2;
	output reg [6:0] opcode_o_2;
		
	output reg [4:0] rs1_o_3;
	output reg [4:0] rs2_o_3;
	output reg [4:0] rd_o_3;
	output reg [31:0] imm_o_3;
	output reg [2:0] alu_op_o_3;
	output reg [6:0] opcode_o_3;
	

	input reg free_pool [63:0];
	
	input reg [2:0] new_func_units;
	reg [2:0] func_units;


	output full;
		
	reg reg_ready [63:0]; // dont forget to initialize reg_ready to all ones
	
	integer i = 0;

	initial begin
		for (i=0; i<64; i=i+1) begin
			reg_ready[i] = 1;
		end
		$stop;
	end
	
	typedef struct {
		reg inuse;
		reg [2:0] alu_op;
		reg [6:0] opcode;
		reg [5:0] rd; 
		//reg [3:0] dest_val;
		reg [5:0] rs1;
		//reg [5:0] source1_val;
		//reg s1_ready;
		reg [5:0] rs2;
		//reg [5:0] source2_val;
		//reg s2_ready;
		reg [31:0] imm;
		reg [1:0] func_unit;
		//reg rob_index;	
	} res_entry;
	
	typedef res_entry rs_table [32];
	
	reg current_fu = 0;
	
	integer size = 0;
	
	always @ (posedge clk) begin	
		func_units = new_func_units;
		// issue logic
		for (i = 0; i < 32; i = i+1) begin
			if (rs_table[i].inuse) begin
				// check if both source registers are ready
				// R TYPE: ADD, SUB, XOR, SRA // S TYPE: SW
				if (rs_table[i].opcode == 7'b0110011 || rs_table[i].opcode == 7'b0100011) begin
					if (reg_ready[rs_table[i].rs1] && reg_ready[rs_table[i].rs2] && func_units[rs_table[i].func_unit]) begin
						// ready to issue
						if (rs_table[i].func_unit == 0) begin
							rs1_o_1 = rs_table[i].rs1;
							rs2_o_1 = rs_table[i].rs2;
							rsd_o_1 = rs_table[i].rd;
							imm_o_1 = rs_table[i].imm;
							alu_op_o_1 = rs_table[i].alu_op;
							opcode_o_1 = rs_table[i].opcode;
							func_unit[0] = 0;
						end
						else if (rs_table[i].func_unit == 1) begin
							rs1_o_2 = rs_table[i].rs1;
							rs2_o_2 = rs_table[i].rs2;
							rsd_o_2 = rs_table[i].rd;
							imm_o_2 = rs_table[i].imm;
							alu_op_o_2 = rs_table[i].alu_op;
							opcode_o_2 = rs_table[i].opcode;
							func_unit[1] = 0;
						end
						else begin
							rs1_o_3 = rs_table[i].rs1;
							rs2_o_3 = rs_table[i].rs2;
							rsd_o_3 = rs_table[i].rd;
							imm_o_3 = rs_table[i].imm;
							alu_op_o_3 = rs_table[i].alu_op;
							opcode_o_3 = rs_table[i].opcode;
							func_unit[2] = 0;
						end
						size = size - 1;
					end
				end
				// I TYPE: ADDI, ANDI // I TYPE: LW
				else if (rs_table[i].opcode == 7'b0010011 && rs_table[i].opcode == 7'b0000011) begin
					if (reg_ready[rs_table[i].rs1] && func_units[rs_table[i].func_unit]) begin
						// ready to issue
						if (rs_table[i].func_unit == 0) begin
							rs1_o_1 = rs_table[i].rs1;
							rs2_o_1 = rs_table[i].rs2;
							rsd_o_1 = rs_table[i].rd;
							imm_o_1 = rs_table[i].imm;
							alu_op_o_1 = rs_table[i].alu_op;
							opcode_o_1 = rs_table[i].opcode;
							func_unit[0] = 0;
						end
						else if (rs_table[i].func_unit == 1) begin
							rs1_o_2 = rs_table[i].rs1;
							rs2_o_2 = rs_table[i].rs2;
							rsd_o_2 = rs_table[i].rd;
							imm_o_2 = rs_table[i].imm;
							alu_op_o_2 = rs_table[i].alu_op;
							opcode_o_2 = rs_table[i].opcode;
							func_unit[1] = 0;
						end
						else begin
							rs1_o_3 = rs_table[i].rs1;
							rs2_o_3 = rs_table[i].rs2;
							rsd_o_3 = rs_table[i].rd;
							imm_o_3 = rs_table[i].imm;
							alu_op_o_3 = rs_table[i].alu_op;
							opcode_o_3 = rs_table[i].opcode;
							func_unit[2] = 0;
						end
						size = size - 1;
					end
				end
			end
		end
		
		
		// dispatch logic
		for (i = 0; i < 32; i = i+1) begin
			if (!(rs_table[i].inuse))
				break;
		end
		// non memory type
		if (opcode_1 ==  7'b0110011 || opcode_1 == 7'b0010011) begin
			rs_table[i] = '{1, alu_op_1, opcode_1, rd_1, rs1_1, rs2_1, imm_1, current_fu};
			current_fu = !current_fu;
		end
		// memory type
		else if (opcode_1 == 7'b0000011 || opcode_1 == 7'b0100011) begin
			rs_table[i] = '{1, alu_op_1, opcode_1, rd_1, rs1_1, rs2_1, imm_1, 2};
		end
		else begin
			// invalid opcode!
		end
		
		if (opcode_1 != 7'b0100011) begin
			reg_ready[rd_1] = 0;
		end
		
		// dispatch logic
		for (i = 0; i < 32; i = i+1) begin
			if (!(rs_table[i].inuse))
				break;
		end
		// non memory type
		if (opcode_2 ==  7'b0110011 || opcode_2 == 7'b0010011) begin
			rs_table[i] = '{1, alu_op_2, opcode_2, rd_2, rs1_2, rs2_2, imm_2, current_fu};
			current_fu = !current_fu;
		end
		// memory type
		else if (opcode_2 == 7'b0000011 || opcode_2 == 7'b0100011) begin
			rs_table[i] = '{1, alu_op_2, opcode_2, rd_2, rs1_2, rs2_2, imm_2, 2};
		end
		else begin
			// invalid opcode!
		end
		
		if (opcode_2 != 7'b0100011) begin
			reg_ready[rd_2] = 0;
		end
		
		size = size + 2;
		
	end
	
endmodule
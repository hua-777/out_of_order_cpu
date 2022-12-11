module rename (
	clk,
   rs1_1,
   rs2_1,
   rd_1,
   imm_1,
   opcode_1,
	alu_op_1,
	
	new_rs1_1,
	new_rs2_1,
	new_rd_1,
	old_rd_1,
	
	new_imm_1,
	new_opcode_1,
	new_alu_op_1,
	
	rs1_2,
   rs2_2,
   rd_2,
   imm_2,
   opcode_2,
	alu_op_2,
	
	new_rs1_2,
	new_rs2_2,
	new_rd_2,
	old_rd_2,
	
	new_imm_2,
	new_opcode_2,
	new_alu_op_2,
	
	rat,
	free_regs
);
  

	input clk;
	
	input reg [4:0] rs1_1;
	input reg [4:0] rs2_1;
	input reg [4:0] rd_1;
	input reg [31:0] imm_1;
	input reg [6:0] opcode_1;
	
	input reg [2:0] alu_op_1;//new_

	output reg [5:0] new_rs1_1;
	output reg [5:0] new_rs2_1;
	output reg [5:0] new_rd_1;
	
	output reg [5:0] old_rd_1;
	
	output reg [31:0] new_imm_1; // new_
	output reg [6:0] new_opcode_1; // new_
	output reg [2:0] new_alu_op_1; // new_
	
	input reg [4:0] rs1_2;
	input reg [4:0] rs2_2;
	input reg [4:0] rd_2;
	input reg [31:0] imm_2;
	input reg [6:0] opcode_2;
	
	input reg [2:0] alu_op_2;//new_
	
	output reg [5:0] new_rs1_2;
	output reg [5:0] new_rs2_2;
	output reg [5:0] new_rd_2;
	
	output reg [5:0] old_rd_2;

	
	output reg [31:0] new_imm_2; // new_
	output reg [6:0] new_opcode_2; // new_
	output reg [2:0] new_alu_op_2; // new_
	
	input [63:0] free_regs; //signal from retire that tells us which regs are now free, using 1 hot encoding 
	reg [63:0] freepool;
	//freepool = freepool or free_regs
	
	output reg [5:0] rat [0:31];
	
	integer i = 0;
	initial begin
		//Free pool
		for (i=0; i<32; i=i+1) begin
			freepool[i] = 0;
		end 
		for (i=32; i<64; i=i+1) begin
			freepool[i] = 1;
		end
		//RAT 
		for (i=0; i<32; i=i+1) begin
			rat[i] = i;
		end 
	end
  
	integer j;
	
	always @ (posedge clk) begin
		freepool = freepool | free_regs;
		
		new_imm_1 = imm_1;
		new_opcode_1 = opcode_1;
		new_alu_op_1 = alu_op_1;
		
		new_imm_2 = imm_2;
		new_opcode_2 = opcode_2;
		new_alu_op_2 = alu_op_2;
		
		for (j = 0; j < 64; j = j+1) begin
			if (freepool[j])
				break;
		end

		//case ADD, SUB, XOR, SRA
		if (opcode_1 == 7'b0110011) begin
			new_rs1_1 = rat[rs1_1];
			new_rs2_1 = rat[rs2_1];
			old_rd_1 = rat[rd_1];
			new_rd_1 = j;
			rat[rd_1] = j;
			freepool[j] = 0;
		end
		//case ADDI, ANDI
		else if (opcode_1 == 7'b0010011) begin
			new_rs1_1 = rat[rs1_1];
			new_rs2_1 = 0;
			old_rd_1 = rat[rd_1];
			new_rd_1 = j;
			rat[rd_1] = j;
			freepool[j] = 0;
		end
		// case LW
		else if (opcode_1 == 7'b0000011) begin
			new_rs1_1 = rat[rs1_1];
			new_rs2_1 = 0;
			old_rd_1 = rat[rd_1];
			new_rd_1 = j;
			rat[rd_1] = j;
			freepool[j] = 0;
		end
		// case SW
		else if (opcode_1 == 7'b0100011) begin
			new_rs1_1 = rat[rs1_1];
			new_rs2_1 = rat [rs2_1];
			new_rd_1 = 0;
			old_rd_1 = 0;
		end
		else begin
			new_rs1_1 = 0;
			new_rs2_1 = 0;
			new_rd_1 = 0; 
			old_rd_1 = 0;
		end
		
		for (j = 0; j < 64; j = j+1) begin
			if (freepool[j])
				break;
		end

		//case ADD, SUB, XOR, SRA
		if (opcode_2 == 7'b0110011) begin
			new_rs1_2 = rat[rs1_2];
			new_rs2_2 = rat[rs2_2];
			old_rd_2 = rat[rd_2];
			new_rd_2 = j;
			rat[rd_2] = j;
			freepool[j] = 0;
		end
		//case ADDI, ANDI
		else if (opcode_2 == 7'b0010011) begin
			new_rs1_2 = rat[rs1_2];
			new_rs2_2 = 0;
			old_rd_2 = rat[rd_2];
			new_rd_2 = j;
			rat[rd_2] = j;
			freepool[j] = 0;
		end
		// case LW
		else if (opcode_2 == 7'b0000011) begin
			new_rs1_2 = rat[rs1_2];
			new_rs2_2 = 0;
			old_rd_2 = rat[rd_2];
			new_rd_2 = j;
			rat[rd_2] = j;
			freepool[j] = 0;
		end
		// case SW
		else if (opcode_2 == 7'b0100011) begin
			new_rs1_2 = rat[rs1_2];
			new_rs2_2 = rat[rs2_2];
			new_rd_2 = 0;
			old_rd_2 = 0;
		end
		else begin
			new_rs1_2 = 0;
			new_rs2_2 = 0;
			new_rd_2 = 0;    
			old_rd_2 = 0;			
		end		
	end
endmodule
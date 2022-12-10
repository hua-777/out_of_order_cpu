module rename (
	clk,
   rs1_1,
   rs2_1,
   rd_1,
   imm_1,
   opcode_1,
	newrs1_1,
	newrs2_1,
	newrd_1,
	rs1_2,
   rs2_2,
   rd_2,
   imm_2,
   opcode_2,
	newrs1_2,
	newrs2_2,
	newrd_2,
	rat,
	free_regs,
);
  

	input clk;
	input reg [6:0] rat [31:0];
	
	input reg [4:0] rs1_1;
	input reg [4:0] rs2_1;
	input reg [4:0] rd_1;
	input reg [31:0] imm_1;
	input reg [6:0] opcode_1;


	output reg [5:0] newrs1_1;
	output reg [5:0] newrs2_1;
	output reg [5:0] newrd_1;
	
	input reg [4:0] rs1_2;
	input reg [4:0] rs2_2;
	input reg [4:0] rd_2;
	input reg [31:0] imm_2;
	input reg [6:0] opcode_2;

	output reg [5:0] newrs1_2;
	output reg [5:0] newrs2_2;
	output reg [5:0] newrd_2;
	
	input free_regs [63:0]; //signal from retire that tells us which regs are now free, using 1 hot encoding 
	reg free_pool [63:0];
	//freepool = freepool or free_regs
	
	output reg [6:0] rat [31:0];
	
	integer i = 0;
	initial begin
		//Free pool
		for (i=0; i<32; i=i+1) begin
			free_pool[i] = 0;
		end 
		for (i=32; i<64; i=i+1) begin
			free_pool[i] = 1;
		end
		//RAT 
		for (i=0; i<32; i=i+1) begin
			rat[i] = i;
		end 
	end
  
	always @ (posedge clk) begin
		freepool = freepool | free_regs;
		for (j = 0; j < 64; j = j+1) begin
			if (freepool[j])
				break;
		end

		//case ADD, SUB, XOR, SRA
		if (opcode_1 == 7'b0110011) begin
			newrs1_1 = rat[rs1_1];
			newrs2_1 = rat[rs2_1];
			newrd_1 = j;
			rat[rd_1] = j;
			freepool[j] = 0;
		end
		//case ADDI, ANDI
		else if (opcode_1 == 7'b0010011) begin
			newrs1_1 = rat[rs1_1];
			newrs2_1 = 0;
			newrd_1 = j;
			rat[rd_1] = j;
			freepool[j] = 0;
		end
		// case LW
		else if (opcode_1 == 7'b0000011) begin
			newrs1_1 = rat[rs1_1];
			newrs2_1 = 0;
			newrd_1 = j;
			rat[rd_1] = j;
			freepool[j] = 0;
		end
		// case SW
		else if (opcode_1 == 7'b0100011) begin
			newrs1_1 = rat[rs1_1];
			newrs2_1 = rat [rs2_1];
			newrd_1 = 0;
		end
		else begin
			newrs1_1 = 0;
			newrs2_1 = 0;
			newrd_1 = 0;       
		end
		
		for (j = 0; j < 64; j = j+1) begin
			if (freepool[j])
				break;
		end

		//case ADD, SUB, XOR, SRA
		if (opcode_2 == 7'b0110011) begin
			newrs1_2 = rat[rs1_2];
			newrs2_2 = rat[rs2_2];
			newrd_2 = j;
			rat[rd_2] = j;
			freepool[j] = 0;
		end
		//case ADDI, ANDI
		else if (opcode_2 == 7'b0010011) begin
			newrs1_2 = rat[rs1_2];
			newrs2_2 = 0;
			newrd_2 = j;
			rat[rd_2] = j;
			freepool[j] = 0;
		end
		// case LW
		else if (opcode_2 == 7'b0000011) begin
			newrs1_2 = rat[rs1_2];
			newrs2_2 = 0;
			newrd_2 = j;
			rat[rd_2] = j;
			freepool[j] = 0;
		end
		// case SW
		else if (opcode_2 == 7'b0100011) begin
			newrs1_2 = rat[rs1_2];
			newrs2_2 = rat[rs2_2];
			newrd_2 = 0;
		end
		else begin
			newrs1_2 = 0;
			newrs2_2 = 0;
			newrd_2 = 0;       
		end		
	end
endmodule
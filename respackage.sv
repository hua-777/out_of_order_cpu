package respackage;

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
		reg [4:0] rob_index;	
	} res_entry;
	

endpackage
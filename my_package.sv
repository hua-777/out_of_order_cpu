package my_package;
	typedef struct {
		reg inuse;
		reg [2:0] alu_op;
		reg [6:0] opcode;
		reg [5:0] rd; 
		//reg [3:0] dest_val;
		reg [5:0] rs1;
		reg [31:0] source_1;
		//reg s1_ready;
		reg [5:0] rs2;
		reg [31:0] source_2;
		//reg s2_ready;
		reg [31:0] imm;
		reg [1:0] func_unit;
		reg [4:0] rob_index;	
	} res_entry;
	
	typedef res_entry generic_table [32];
	
	typedef struct {
		reg in_use;
		reg is_complete;
		reg [5:0] old_d_reg; 
		reg [5:0] curr_d_reg;
		reg [6:0] rd_opcode;
		reg [31:0] rd_value;
		reg [31:0] rs2_value;
	} rob_entry;
	
	typedef rob_entry generic_buffer [32];

endpackage
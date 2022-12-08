package rezzmaster;

	typedef struct {
	reg inuse;
	reg [5:0] dest_reg; 
	reg [3:0] dest_val;
	reg [5:0] source1_reg;
	reg [5:0] source1_val;
	reg s1_ready;
	reg [5:0] source2_reg;
	reg [5:0] source2_val;
	reg s2_ready;
	reg [1:0] func_unit;
	reg rob_index;	
	} res_entry;
	
	typedef res_entry reservation_station [32];

endpackage
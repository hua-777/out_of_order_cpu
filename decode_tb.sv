`timescale 1ns/1ns // Tell Questa what time scale to run at
/*
module decode_tb(clk,
				rs1,
				rs2,
				rd,
				imm,
				.opcode(opcode),
				alu_op,
				alu_src,
				mem_to_reg,
				reg_write,
				mem_read,
				mem_write
				);
	output reg clk = 0;
	//output reg [31:0] inst1 = 0;
	//output reg [31:0] inst2 = 0;
	
	//fetch uut (.clk(clk), .pc(pc), .inst1(inst1), .inst2(inst2));
	
	//reg [31:0] inst = // some test value
	output reg [4:0] rs1;
	output reg [4:0] rs2;
	output reg [4:0] rd;
	output reg [31:0] imm;
	output reg [6:0] opcode;
	output reg [2:0] alu_op;
	
	output reg alu_src;
	
	output reg mem_to_reg;
	
	output reg reg_write;
	
	output reg mem_read;
	output reg mem_write;
	
	reg write_reg;
	reg write_data;
	reg [31:0] inst;
	
	decode uut (.clk(clk),
				.inst(inst),
				.write_reg(write_reg),
				.write_data(write_data),
				.rs1(rs1),
				.rs2(rs2),
				.rd(rd),
				.imm(imm),
				.opcode(opcode),
				.alu_op(alu_op),
				.alu_src(alu_src),
				.mem_to_reg(mem_to_reg),
				.reg_write(reg_write),
				.mem_read(mem_read),
				.mem_write(mem_write)
				);
				
	initial begin
		#100;			//delay for 100 ticks (delcared as 1ns at the top!)
		clk = 0;
		inst = 32'b00000000001000001000000110110011;
		#20;
		clk = 1;
		#20;
		
		$stop;		//tell simulator to stop the simuation
		
		
	end
	
	
	always begin

	end
	
	
endmodule
*/
`timescale 1ns/1ns // Tell Questa what time scale to run at
import rezzmaster::*;

module cpu(clk,
				newrs1_1,
				newrs2_1,
				newrd_1,
				newrs1_2,
				newrs2_2,				
				newrd_2,
				freepool,
				rat,
				regfile,
				regready,
				res_station,
				mem,
				fu
				);
				
	output reg clk = 0;
	reg [7:0] pc = 0;
	
	output reg freepool [63:0];	
	output logic [6:0] rat [31:0];
	output logic [6:0] regfile [63:0];
	output regready [63:0]; 
	output reservation_station res_station;
	
	reg [31:0] inst1;
	reg [31:0] inst2;
	

	fetch fetch_module(.clk(clk),
					.pc(pc),
					.inst1(inst1),
					.inst2(inst2)
					);		
	

	reg [4:0] write_reg_1;
	reg [31:0] write_data_1;

	reg [4:0] rs1_1;
	reg [4:0] rs2_1;
	reg [4:0] rd_1;
	reg [31:0] imm_1;

	reg [2:0] alu_op_1;
	reg alu_src_1;
	reg mem_to_reg_1;
	reg reg_write_1;
	reg mem_read_1;
	reg mem_write_1;
	reg [6:0] opcode_1;

	
	reg [4:0] write_reg_2;
	reg [31:0] write_data_2;

	reg [4:0] rs1_2;
	reg [4:0] rs2_2;
	reg [4:0] rd_2;
	reg [31:0] imm_2;

	reg [2:0] alu_op_2;
	reg alu_src_2;
	reg mem_to_reg_2;
	reg reg_write_2;
	reg mem_read_2;
	reg mem_write_2;
	reg [6:0] opcode_2;


	decode decode_module_1(.clk(clk),
					.inst(inst1),
					.write_reg(write_reg_1),
					.write_data(write_data_1),
					.rs1(rs1_1),
					.rs2(rs2_1),
					.rd(rd_1),
					.imm(imm_1),
					.opcode(opcode_1),
					.alu_op(alu_op_1),
					.alu_src(alu_src_1),
					.mem_to_reg(mem_to_reg_1),
					.reg_write(reg_write_1),
					.mem_read(mem_read_1),
					.mem_write(mem_write_1)
					);
					


	decode decode_module_2(.clk(clk),
					.inst(inst2),
					.write_reg(write_reg_2),
					.write_data(write_data_2),
					.rs1(rs1_2),
					.rs2(rs2_2),
					.rd(rd_2),
					.imm(imm_2),
					.opcode(opcode_2),
					.alu_op(alu_op_2),
					.alu_src(alu_src_2),
					.mem_to_reg(mem_to_reg_2),
					.reg_write(reg_write_2),
					.mem_read(mem_read_2),
					.mem_write(mem_write_2)
					);
					

	output reg [5:0] newrs1_1;
	output reg [5:0] newrs2_1;
	output reg [5:0] newrd_1;

	output reg [5:0] newrs1_2;
	output reg [5:0] newrs2_2;					
	output reg [5:0] newrd_2;
	

	rename rename_module(
					.clk(clk),
					.rs1_1(rs1_1),
					.rs2_1(rs2_1),
					.rd_1(rd_1),
					.imm_1(imm_1),
					.opcode_1(opcode_1),
					.newrs1_1(newrs1_1),
					.newrs2_1(newrs2_1),
					.newrd_1(newrd_1),
					.rs1_2(rs1_2),
					.rs2_2(rs2_2),
					.rd_2(rd_2),
					.imm_2(imm_2),
					.opcode_2(opcode_2),
					.newrs1_2(newrs1_2),
					.newrs2_2(newrs2_2),
					.newrd_2(newrd_2),
					.rat(rat),
					.freepool(freepool)
					);
	
	dispatch dispatch_module1(
					.clk(clk),
					.rs1(newrs1_1),
					.rs2(newrs2_1),
					.freepool(freepool),
					.rd(newrd_1),
					.imm(imm_1),
					.rstation(),
	);
				
	initial begin
		#200;
		
		//for loop, initialize RAT and freepool
		
		integer i;
		reg [6:0] j;
		
		//RAT 
		for (i=0; i<32; i=i+1) begin
			rat[i] = i;
		end 
		//Free pool
		for (i=0; i<32; i=i+1) begin
			freepool[i] = 0;
		end 
		for (i=32; i<64; i=i+1) begin
			freepool[i] = 1;
		end
		//Initialize Memory 
		for (i=0; i<32; i=i+1) begin
			mem[i] = i;
		end 
		//Initialize Functional Units
		for (i=0; i<3; i=i+1) begin
			fu[i] = 1;
		end 		
		$stop;
	end
	
	always begin
		clk <= ~clk;
		#20; 
		pc <= pc + 4;
	end
  
endmodule
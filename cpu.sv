`timescale 1ns/1ns // Tell Questa what time scale to run at


module cpu
import my_package::*;

	(clk,
	register_file,
	arch_register_file,
	memory
	);
				
	output reg clk = 0;
	reg [7:0] pc = 0;
	
	output reg [31:0] register_file [0:63];
	output reg [31:0] memory [0:63];
	
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
	
	reg [31:0] clk_counter = 0;


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
					

	reg [5:0] new_rs1_1;
	reg [5:0] new_rs2_1;
	reg [5:0] new_rd_1;

	reg [5:0] new_rs1_2;
	reg [5:0] new_rs2_2;					
	reg [5:0] new_rd_2;
	
	
	reg [5:0] old_rd_1;
	reg [31:0] new_imm_1;
	reg [6:0] new_opcode_1;
	reg [2:0] new_alu_op_1;
	
	reg [5:0] old_rd_2;
	reg [31:0] new_imm_2;
	reg [6:0] new_opcode_2;
	reg [2:0] new_alu_op_2;
	
	reg [5:0] rat [0:31];
	reg [63:0] free_regs;

	rename rename_module(
					.clk(clk),
					.rs1_1(rs1_1),
					.rs2_1(rs2_1),
					.rd_1(rd_1),
					.imm_1(imm_1),
					.opcode_1(opcode_1),
					
					.alu_op_1(alu_op_1),
					
					.new_rs1_1(new_rs1_1),
					.new_rs2_1(new_rs2_1),
					.new_rd_1(new_rd_1),
					
					.old_rd_1(old_rd_1),
					.new_imm_1(new_imm_1),
					.new_opcode_1(new_opcode_1),
					.new_alu_op_1(new_alu_op_1),
					
					.rs1_2(rs1_2),
					.rs2_2(rs2_2),
					.rd_2(rd_2),
					.imm_2(imm_2),
					.opcode_2(opcode_2),
					.alu_op_2(alu_op_2),
					
					.new_rs1_2(new_rs1_2),
					.new_rs2_2(new_rs2_2),
					.new_rd_2(new_rd_2),
					
					.old_rd_2(old_rd_2),
					.new_imm_2(new_imm_2),
					.new_opcode_2(new_opcode_2),
					.new_alu_op_2(new_alu_op_2),
					
					
					.rat(rat),
					.free_regs(free_regs)
					);
					
	
	res_entry line_1;
	res_entry line_2;
	res_entry line_3;
	reg [2:0] func_units;
	
	
	res_entry line_1_o;
	res_entry line_2_o;
	res_entry line_3_o;
	
	reg [31:0] val_1;
	reg [31:0] val_2;
	reg [31:0] val_3;
	reg [2:0] func_units_o;
	reg [63:0] reg_ready_o;
	
	reservation_station rs_module(
					.clk(clk),		
					.clk_counter(clk_counter),
					
					.rs1_1(new_rs1_1),
					.rs2_1(new_rs2_1),
					.rd_1(new_rd_1),
					.imm_1(new_imm_1),
					.alu_op_1(new_alu_op_1),
					.opcode_1(new_opcode_1),
					
					.rs1_2(new_rs1_2),
					.rs2_2(new_rs2_2),
					.rd_2(new_rd_2),
					.imm_2(new_imm_2),
					.alu_op_2(new_alu_op_2),
					.opcode_2(new_opcode_2),
					
					.line_1(line_1),
					.line_2(line_2),
					.line_3(line_3),				
					.register_file(register_file),				
					.func_units(func_units),
					
					.val_1(val_1),
					.val_2(val_2),
					.val_3(val_3),
					.line_1_o(line_1_o),
					.line_2_o(line_2_o),
					.line_3_o(line_3_o),	
					.func_units_o(func_units_o),

					.reg_ready_o(reg_ready_o)
					);
	
	
		


	issue issue_module(
		.clk(clk),

		.line_1(line_1),
		.line_2(line_2),
		.line_3(line_3),
		
		.line_1_o(line_1_o),
		.line_2_o(line_2_o),
		.line_3_o(line_3_o),
		
		.val_1(val_1),
		.val_2(val_2),
		.val_3(val_3),
		
		.memory(memory),

		.func_units(func_units),
		.func_units_o(func_units_o)
	);
	
	
	reg [1:0] num_retired;
	rob_entry rob_o_1;
	rob_entry rob_o_2;
	
	reorder_buffer reorder_buffer_module(
		.clk(clk),
		.clk_counter(clk_counter),
		.curr_dest_reg_1(new_rd_1),
		.old_dest_reg_1(old_rd_1),
		.curr_dest_reg_2(new_rd_2),
		.old_dest_reg_2(old_rd_2),
		.line1_i(line_1_o),
		.line2_i(line_2_o),
		.line3_i(line_3_o),
		.line1_val_i(val_1),
		.line2_val_i(val_2),
		.line3_val_i(val_3),
		.num_retired(num_retired),
		.rob_o_1(rob_o_1),
		.rob_o_2(rob_o_2),
		.func_units_flag(func_units_o)
	);
	
		
	writeback writeback_module(
			.clk(clk),
			.rob_o_1(rob_o_1),
			.rob_o_2(rob_o_2),
			.num_retired(num_retired),
			.reg_ready_o(reg_ready_o),
			.free_regs(free_regs),
			.register_file(register_file),
			.memory(memory)
	);
	
	output reg [31:0] arch_register_file [0:31];
	
	integer i; 

	initial begin
		for (i=0; i<32; i=i+1) begin
			arch_register_file[i] = 0;
		end
		#1200;
		$stop;
	end
	
	always begin
		clk = ~clk;
		if (clk == 1) begin
			clk_counter = clk_counter + 1;
		end
		for (i=0; i<32; i=i+1) begin
			arch_register_file[i] = register_file[rat[i]];
		
			//reg [5:0] rat [0:31];
		end
		#10; 
		pc = pc + 4;
	end
  
endmodule
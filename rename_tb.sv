`timescale 1ns/1ns // Tell Questa what time scale to run at
/*
module rename_tb (
	clk,
   oldrs1,
   oldrs2,
   oldrd,
	newrs1,
	newrs2,
	newrd,
	freepool
);
	output reg clk = 0;
	reg [4:0] rs1 = 0;
	reg [4:0] rs2 = 0;
	reg [4:0] rd = 0;
	reg [31:0] imm = 0;
	reg [6:0] opcode = 0;

	output reg [4:0] oldrs1 = 0;
	output reg [4:0] oldrs2 = 0;
	output reg [4:0] oldrd = 0;

	output reg [5:0] newrs1 = 0;
	output reg [5:0] newrs2 = 0;
	output reg [5:0] newrd = 0;
	
	output reg freepool [63:0];

	rename uut (
	.clk(clk),
	.rs1(rs1),
	.rs2(rs2),
	.rd(rd),
	.imm(imm),
	.opcode(opcode),
	.oldrs1(oldrs1),
	.oldrs2(oldrs2),
	.oldrd(oldrd),
	.newrs1(newrs1),
	.newrs2(newrs2),
	.newrd(newrd),
	.freepool(freepool)
	);

	
	initial begin
		#100;			//delay for 100 ticks (delcared as 1ns at the top!)
		clk = 0;
		rs1 = 1;
		rs2 = 2;
		rd = 3;
		imm = 0;
		opcode = 7'b0110011;
		clk = 1;
		#20;
		clk = 0;
		#20;
		rs1 = 2;
		rs2 = 4;
		rd = 3;
		imm = 0;
		opcode = 7'b0110011;
		clk = 1;
		#20;
		clk = 0;
		#20;
		clk = 0;
		rs1 = 3;
		rs2 = 5;
		rd = 6;
		clk = 1;
		imm = 0;
		opcode = 7'b0110011;
		#20;
	end

	
	always begin

	end
	
	
	
endmodule
*/
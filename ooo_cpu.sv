`timescale 1ns/1ns // Tell Questa what time scale to run at


module fetch_tb;
	reg [31:0] inst1, inst2;
	reg [7:0] pc;
	wire clk;
	
	fetch uut(clk, pc, inst1, inst2);
	
	initial
	begin
		inst1 = 0;
		inst2 = 0;
		pc = 0;
		clk = 0;
	end
	
	always begin
		#1;
		clk = ~clk;
	end
	
	

endmodule

`timescale 1ns/1ns // Tell Questa what time scale to run at

module fetch_tb(inst1, inst2, clk, pc);
	output reg clk = 0;
	output reg [7:0] pc = 0;
	output reg [31:0] inst1 = 0;
	output reg [31:0] inst2 = 0;
	

	fetch uut (.clk(clk), .pc(pc), .inst1(inst1), .inst2(inst2));

	initial begin
		#100;			//delay for 100 ticks (delcared as 1ns at the top!)
		$stop;		//tell simulator to stop the simuation
	end
	
	
	always begin
		clk = ~clk;
		#5;	 
		pc = pc + 4;
	end
	
	
endmodule
`timescale 1ns/1ns // Tell Questa what time scale to run at

module fetch(clk,
				pc,
				inst1,
				inst2);
				
	input reg clk;
	input reg [7:0] pc;
	output reg [31:0] inst1 = 0;
	output reg [31:0] inst2 = 0;
	reg [7:0] data [0:127];

	initial begin
		//$readmemh("C:/users/madha/Desktop/ooo_cpu-main/ooo_cpu-main/instructions.txt", data);
		$readmemh("C:/Users/derek/Documents/ooo_cpu/evaluation-hex.txt", data);
	end
	
	
	always @ (posedge clk) begin
		inst1[31:24] <= data[pc];
		inst1[23:16] <= data[pc + 1];
		inst1[15:8] <= data[pc + 2];
		inst1[7:0] <= data[pc + 3];
		
		inst2[31:24] <= data[pc + 4];
		inst2[23:16] <= data[pc + 5];
		inst2[15:8] <= data[pc + 6];
		inst2[7:0] <= data[pc + 7];
		
	end

	
	
endmodule



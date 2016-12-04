/*
As you are given it, this ALU only implements Add
  */

module ALU(input logic  [31:0] I1,

	   input logic [31:0] I2,
	   input logic [4:0] Selector,
	   output logic [31:0] O
	   );
	
   logic [31:0] sum;
   
   
   assign sum = I1 + I2;

   // also need: nor, nori (same as nor?), not (nor w 0), ?? for rotations

   assign O = sum;
   
	
endmodule

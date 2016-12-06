/*
As you are given it, this ALU only implements Add
  */

module ALU(input logic  [31:0] I1,

	   input logic [31:0] I2,
	   input logic [4:0] Selector,
	   output logic [31:0] O
	   );
	
   logic [31:0] sum;
   logic [0:0] 	add, norr, nori, notr, bleu, rolv, rorv;

   // add = 10000
   // nor = 10011
   // nori = 00111
   // not = 00010
   // bleu = 01000
   // rolv = 00000
   // rorv = 00001

   
   assign add = Selector[4] & ~Selector[3] & ~Selector[2] & ~Selector[1] & ~Selector[0];
   assign norr = Selector[4] & ~Selector[3] & ~Selector[2] & Selector[1] & Selector[0];
   assign nori = ~Selector[4] & ~Selector[3] & Selector[2] & Selector[1] & Selector[0];
   assign notr = ~Selector[4] & ~Selector[3] & ~Selector[2] & Selector[1] & ~Selector[0];
   assign bleu = ~Selector[4] & Selector[3] & ~Selector[2] & ~Selector[1] & ~Selector[0];
   assign rolv = ~Selector[4] & ~Selector[3] & ~Selector[2] & ~Selector[1] & ~Selector[0];
   assign rorv = ~Selector[4] & ~Selector[3] & ~Selector[2] & ~Selector[1] & Selector[0];
   
   
   
   
   assign sum = I1 + I2;

   // also need: nor, nori (same as nor?), not (nor w 0), sub for rotations

   assign O = sum;
   
	
endmodule

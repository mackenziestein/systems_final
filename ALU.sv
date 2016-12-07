/*
As you are given it, this ALU only implements Add
  */

module ALU(input logic  [31:0] I1,

	   input logic [31:0] I2,
	   input logic [4:0] Selector,
	   output logic [31:0] O
	   );
	
   logic [31:0] sumOut, norOut, notOut, norIOut, bleuOut;
   logic [0:0] 	add, norr, nori, notr, bleu, rolv, rorv;
   logic [31:0] Rrot0, Rrot1, Rrot2, Rrot3, Rrot4, Rrot5, Rrot6, Rrot7, rotRight;
   logic [31:0] Lrot0, Lrot1, Lrot2, Lrot3, Lrot4, Lrot5, Lrot6, Lrot7, rotLeft;
   logic [0:0] 	chooseFirst, chooseSecond, chooseThird;
   logic [31:0] firstOut, secondOut, thirdOut, finalOut;
   
 
   // add = 10000
   // nor = 10011
   // nori = 00111
   // not = 00010
   // bleu = 01000
   // rolv = 00000
   // rorv = 00001
     
   
   assign add = (Selector[4] & ~Selector[3] & ~Selector[2] & ~Selector[1] & ~Selector[0]) | 
		(Selector[4] & ~Selector[3] & ~Selector[2] & ~Selector[1] & Selector[0]) |
		(Selector[4] & ~Selector[3] & Selector[2] & ~Selector[1] & Selector[0]);
   assign norr = Selector[4] & ~Selector[3] & ~Selector[2] & Selector[1] & Selector[0];
   assign nori = ~Selector[4] & ~Selector[3] & Selector[2] & Selector[1] & Selector[0];
   assign chooseFirst = add | norr | nori;
   
   assign notr = ~Selector[4] & ~Selector[3] & ~Selector[2] & Selector[1] & ~Selector[0];   
   assign bleu = ~Selector[4] & Selector[3] & ~Selector[2] & ~Selector[1] & ~Selector[0];
   assign chooseSecond = notr | bleu;
   
   assign rolv = ~Selector[4] & ~Selector[3] & ~Selector[2] & ~Selector[1] & ~Selector[0];
   assign rorv = ~Selector[4] & ~Selector[3] & ~Selector[2] & ~Selector[1] & Selector[0];
   
   // ADDITION - for add, lw, sw
   assign sumOut = I1 + I2;

   // also need: nor, nori (same as nor?), not (nor w 0), ?? for rotations

   // ROTATE RIGHT
   assign Rrot0 = I2;
   assign Rrot1 = {I2[0:0], I2[31:1]};
   assign Rrot2 = {I2[1:0], I2[31:2]};
   assign Rrot3 = {I2[2:0], I2[31:3]};
   assign Rrot4 = {I2[3:0], I2[31:4]};
   assign Rrot5 = {I2[4:0], I2[31:5]};
   assign Rrot6 = {I2[5:0], I2[31:6]};
   assign Rrot7 = {I2[6:0], I2[31:7]};

   mux8to1B32 rotateRight(I1[2], I1[1], I1[0], Rrot7, Rrot6, Rrot5, Rrot4, Rrot3, Rrot2, Rrot1, Rrot0, rotRight);

   // ROTATE LEFT
   assign Lrot0 = {I2[30:0], I2[31:31]};
   assign Lrot1 = {I2[29:0], I2[31:30]};
   assign Lrot2 = {I2[28:0], I2[31:29]};
   assign Lrot3 = {I2[27:0], I2[31:28]};
   assign Lrot4 = {I2[26:0], I2[31:27]};
   assign Lrot5 = {I2[25:0], I2[31:26]};
   assign Lrot6 = {I2[24:0], I2[31:25]};
   assign Lrot7 = {I2[23:0], I2[31:24]};

   mux8to1B32 rotateLeft(I1[2], I1[1], I1[0], Rrot7, Rrot6, Rrot5, Rrot4, Rrot3, Rrot2, Rrot1, Rrot0, rotLeft);

   // NOR
   assign norOut = ~(I1 | I2);

   // NORI
   assign norIOut = ~(I1 | I2); 
    
   // NOT
   assign notOut = ~I2;

   // BLEU
   assign bleuOut = 32'b0;
   

   
   //mux8to1B32 first(add, norr, nori, 32'b0, 32'b11110000, 32'b11001100, sumOut, 32'b11111111, norOut, norIOut, 32'b10101010, firstOut);
   mux8to1B32 first(add, norr, nori, 32'b0, 32'b0, 32'b0, sumOut, 32'b0, norOut, norIOut, 32'b0, firstOut);
   mux4to1B32 second(notr, bleu, 32'b0, notOut, bleuOut, 32'b0, secondOut);
   mux4to1B32 third(rolv, rorv, 32'b0, rotRight, rotLeft, 32'b0, thirdOut);

   mux8to1B32 muxFinal(chooseThird, chooseSecond, chooseFirst, 32'b0, 32'b0, 32'b0, thirdOut, 32'b0, secondOut, firstOut, 32'b0, finalOut);

   assign O = finalOut;
   
	
endmodule

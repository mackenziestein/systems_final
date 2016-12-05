module Control(ins, memToReg, memWrite, branchEnable, ALUControl, ALUSrc, regDst, regWriteEnable, jump, alu4, alu3, alu2, alu1, alu0);

   input logic [31:0] ins;
   output logic [0:0] memToReg, memWrite, branchEnable, ALUControl, ALUSrc, regDst, regWriteEnable, jump, alu4, alu3, alu2, alu1, alu0;


   logic [0:0] andr, lw, sw, jr, jal, norr, nori, notr, bleu, rolv, rorv;

   
   assign andr = ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ~ins[27] & ~ins[26];
   assign lw = ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ins[27] & ins[26];
   assign sw = ins[31] & ~ins[30] & ins[29] & ~ins[28] & ins[27] & ins[26];
   assign jr = ~ins[31] & ~ins[30] & ins[29] & ~ins[28] & ~ins[27] & ~ins[26];
   assign jal = ~ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ins[27] & ins[26];
   assign norr = ins[31] & ~ins[30] & ~ins[29] & ins[28] & ins[27] & ~ins[26];
   assign nori = ~ins[31] & ~ins[30] & ins[29] & ins[28] & ins[27] & ~ins[26];
   assign notr = ~ins[31] & ~ins[30] & ~ins[29] & ins[28] & ~ins[27] & ~ins[26];
   // pseudoinstruction - actually nor
   assign bleu = ~ins[31] & ins[30] & ~ins[29] & ~ins[28] & ~ins[27] & ~ins[26];
   // evaluate rs <= rt, then jump to label
   assign rolv = ~ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ~ins[27] & ~ins[26];
   assign rorv = ~ins[31] & ~ins[30] & ~ins[29] & ~ins[28] & ins[27] & ~ins[26];
   
	    
   assign alu4 = ins[31];
   assign alu3 = ins[30];
   assign alu2 = ins[29];
   assign alu1 = ins[28];
   assign alu0 = ins[27];

   
   assign memToReg = 1'b0;
   assign memWrite = sw;
   assign branchEnable = bleu;
   assign ALUControl = 1'b0;
   assign ALUSrc = nori;
   assign regDst = andr | norr | nori | notr | rolv | rorv;
   assign regWriteEnable = lw | andr | norr | nori | notr | rolv | rorv;   

   assign jump = jr | jal;
   
   
   endmodule
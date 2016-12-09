module DataPath(clock, pcQ, instr, pcD, regWriteEnable);
///////////////////////////////////
   // The clock will be driven from the testbench 
   // The instruction, pcQ and pcD are sent to the testbench to
   // make debugging easier
   

   input logic clock;
   output logic [31:0] instr;
   output logic [31:0] pcQ;
   output logic [31:0] pcD;
   output logic [0:0] regWriteEnable;
   logic [31:0]       pcPlus4;
   
   
   // The PC is just a register
   // for now, it is always enabled so it updates on every clock cycle
   // Its ports are above
   
   enabledRegister PC(pcD,pcQ,clock,1'b1);

   // set up a hard-wired connection to a value
   
   logic [31:0] constant4;

   initial
     constant4 <= 32'b100;

   // construct the adder for the PC incrementing circuit.

   logic [31:0] adderIn1, adderIn2, adderOut;
   
   adder psAdd(adderIn1,adderIn2,adderOut);

   // Connect the adder to the right inputs and output
   // notice that using pcD and pcQ here and above in the PC register is like
   // connecting a wire  BUT the wires have a direction. E.g. the first
   // line below says a signal goes from pcQ to adderIn1
   
   assign adderIn1 = pcQ;
   assign adderIn2 = constant4;
   assign pcPlus4 = adderOut;

   
   // construct the instuctionmemory
   // wired to PC and instruction

   logic [31:0] instA;
   
   instructionMemory imem(instA,instr);

   // Wire instruction memory

   assign instA = pcQ;

   // construct the control unit  
   // This unit generates the signals that control the datapath
   // it will have many more ports later


   logic [0:0] 	memToReg, memWrite, branchEnable, ALUSrc, regDst, jump, jumpReg, alu4, alu3, alu2, alu1, alu0;
   logic [4:0] 	ALUControl;
   
   
   
   Control theControl(instr, memToReg, memWrite, branchEnable, ALUControl, ALUSrc, regDst, regWriteEnable, jump, jumpReg, alu4, alu3, alu2, alu1, alu0);
   
   
   // construct the register file with (currently mostly) unused values to connect to it
   
   logic [4:0] 	       A3, A2, A1;
   logic 	       WE3, clk;
   logic [31:0]        WD3, RD1, RD2;

   
   registerFile theRegisters(A1,A2, 
			     A3, clk, WE3, WD3, RD1, RD2);

   // attach the A1 port to 5 bits of the instruction

   logic [31:0]   RD;
   logic [4:0] 	  RsOrRt, A3assign, r7default;

   assign r7default = 5'b11111;
   
   mux2to1B5 muxA3(regDst, instr[15:11], instr[20:16], RsOrRt);
   mux2to1B5 muxJal(jump, r7default, RsOrRt, A3assign);
   
   assign clk = clock;
   assign A1 = instr[25:21];
   assign A3 = A3assign;  // A3 is either 20:16 or 15:11, based on RegDst
   assign A2 = instr[20:16];
   assign WE3 = regWriteEnable;
      
   logic [31:0]        SignImm;

   // sign extend the immediate field
   //  
   assign SignImm = {{16{instr[15]}}, instr[15:0]};

   logic [31:0]        SrcA, SrcB, ALUResult;
   // logic [4:0] 	       aluSelect;
   logic [31:0]        muxSrcBin, Result, WD, dataA;
   
   mux4to1B32 muxRD2(1'b0, ALUSrc, 32'b0, 32'b0, SignImm, RD2, muxSrcBin);

   assign SrcB = muxSrcBin;
   assign SrcA = RD1;
   // assign aluSelect = {alu4, alu3, alu2, alu1, alu0};
   

   ALU theALU(SrcA, SrcB, ALUControl, ALUResult);    
   
   logic [0:0] 	       WE;

   assign dataA = ALUResult;
   
   dataMemory data(dataA, RD, WD, clk, WE);


   mux4to1B32 muxRD(jump, memToReg, 32'b0, pcPlus4, RD, ALUResult, Result);
   //mux4to1B32 muxRD(memToReg, jump, 32'b0, pcPlus4, RD, ALUResult, Result);

   assign WD3 = Result;
   assign WD = RD2;
   assign WE = memWrite;

   logic [31:0]        PCJump, jumpInst, PCNext, PCJumpReg;
   logic [1:0] 	       constant0;
   
   assign constant0 = 2'b0;
   //assign jumpInst = {instr[29:0], constant0[1:0]};
   assign PCJump = {pcQ[31:28], instr[25:0], constant0[1:0]};
   assign PCJumpReg = RD1;
   
   mux8to1B32 muxPC(branchEnable, jump, jumpReg, 32'b0, 32'b0, 32'b0, 32'b1, PCJumpReg, PCJump, 32'b0, pcPlus4, PCNext);
   
   //mux4to1B32 jumpPC(1'b0, jump, 32'b0, 32'b0, PCJump, pcPlus4, PCNext);
   assign pcD = PCNext;
   
   
endmodule


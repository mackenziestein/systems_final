`timescale 1 ns/1 ns

module tester3;

logic [31:0] pcQ, pcD,instruction, addIn1, addIn2, addOut;
logic clock;
logic regWriteEnable;

int clockCount;

DataPath dut (clock, pcQ, instruction,pcD, regWriteEnable);

   
// start a clock with a counter of clock cycle
   

always 
	begin
	clock <= 0;
	#20;
	clock <= 1;
	#20;
	clockCount <= clockCount + 1;
	end

   
// set up debugging display and a way to end the simulation
   
always @ (negedge clock) begin 
   $display("PC Address : %h",pcQ);
   $display("PC D: %h ",pcD);
   $display("Instruction : %h", instruction);
   $display("Reg write enable %b", regWriteEnable);
   $display("Reg 0 write signal %b", dut.theRegisters.yesWrite0);
   $display("Reg 1 write signal %b", dut.theRegisters.yesWrite1);
   $display("Reg 2 write signal %b", dut.theRegisters.yesWrite2);
   $display("Reg 3 write signal %b", dut.theRegisters.yesWrite3);
   $display("Reg 7 write signal %b", dut.theRegisters.yesWrite7);
   $display("ALUSrc %b", dut.theControl.ALUSrc);
   //$display("RD2 mux %b", dut.muxRD2.O);
   $display("ALU Result %b", dut.ALUResult);
   //$display("PCJump %b", dut.PCJump);
   $display("add signal %b", dut.theALU.add);
   //$display("I1 %b", dut.theALU.I1);
   //$display("I2 %b", dut.theALU.I2);
   
   $display("sum out %b", dut.theALU.sumOut);
   /*
   $display("first out %b", dut.theALU.firstOut);
   $display("second out %b", dut.theALU.secondOut);
   $display("third out %b", dut.theALU.thirdOut);
   $display("I0 %b", dut.theALU.muxFinal.I0);
   $display("I1 %b", dut.theALU.muxFinal.I1);
   $display("I2 %b", dut.theALU.muxFinal.I2);
   $display("I3 %b", dut.theALU.muxFinal.I3);
   $display("I4 %b", dut.theALU.muxFinal.I4);
   $display("I5 %b", dut.theALU.muxFinal.I5);
   $display("I6 %b", dut.theALU.muxFinal.I6);
   $display("I7 %b", dut.theALU.muxFinal.I7);
   $display("mux s1 out %b", dut.theALU.muxFinal.s2.O);
   $display("mux s1 out input %b", dut.theALU.muxFinal.s2.I1);
   $display("Step A %b", dut.theALU.muxFinal.OStepA);
   $display("Step B %b", dut.theALU.muxFinal.OStepB);   
   */
   $display("final out %b", dut.theALU.finalOut);
   
   
   $display(" - ");
   
   
   if (clockCount == 20)
     begin
	$display("Simulation ending after %d clock cycles ",clockCount);
	$stop;
     end
end // always

endmodule
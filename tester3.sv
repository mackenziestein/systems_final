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
   $display("LW %b", dut.theControl.lw);
   $display("SW %b", dut.theControl.sw);
   $display("ALUSrc %b", dut.theControl.ALUSrc);
   $display("RD2 mux %b", dut.muxRD2.O);
   $display("ALU Result %b", dut.ALUResult);
   $display("Mux A3 %b", dut.muxA3.O);
   $display("muxJal %b", dut.muxJal.O);
   $display("jump %b", dut.jump);
   $display("PCJump %b", dut.PCJump);
   
   
   
   
   $display(" - ");
   
   
   if (clockCount == 20)
     begin
	$display("Simulation ending after %d clock cycles ",clockCount);
	$stop;
     end
end // always

endmodule
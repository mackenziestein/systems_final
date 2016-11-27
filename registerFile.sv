/* The beginning of a register set */

module registerFile(input logic [4:0] A1,
		    input logic [4:0] A2,
		    input logic [4:0] A3,
		    input logic [0:0] CLK,
		    input logic [0:0] WE3,
		    input logic [31:0] WD3,
		    output logic [31:0] RD1,
		    output logic [31:0] RD2
		    );
   
   logic  [0:0] yesWrite0;
   logic  [0:0] yesWrite1;
    
   logic [31:0]  reg0, reg1;
   
   assign yesWrite0 = WE3 &  ~A3[2] & ~A3[1] & ~A3[0];
   assign yesWrite1 = WE3 &  ~A3[2] & ~A3[1] & A3[0];
     
   enabledRegister r0(WD3,reg0,CLK,yesWrite0);
   enabledRegister r1(WD3,reg1,CLK,yesWrite1);
      
   mux4to1B32 mpxA1(A1[1],A1[0],32'b101010,32'b111111,reg1, reg0, RD1);

   mux4to1B32 mpxA2(A2[1],A2[0],32'b101010,32'b111111,reg1, reg0, RD2);

   
   always @ (negedge CLK)
     begin
	$display("register 0 %h ",reg0);
	$display("register 1 %h ",reg1);
	
     end
   
endmodule



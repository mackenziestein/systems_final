module mux8to1B32 (input logic C2, input logic C1, input logic C0, input logic [31:0] I7, input logic [31:0] I6, input logic [31:0] I5, input logic [31:0] I4, input logic [31:0] I3, input logic [31:0] I2, input logic [31:0] I1, input logic [31:0] I0, output logic [31:0] O);

   logic [31:0] OStepA, OStepB;
   
   mux4to1B32 s1(C1, C0, I6, I4, I2, I0, OStepA);
   mux4to1B32 s2(C1, C0, I7, I5, I3, I1, OStepB);
   mux4to1B32 s3(1'b0, C2, 32'b0, 32'b0, OStepB, OStepA, O);
   

endmodule 
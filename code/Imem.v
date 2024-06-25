module Imem
  #(parameter INSTRUCTIONS="")
  (
    input clock,
    input [15:0] inst_addr,
    output reg [15:0] instruction
  );

  reg [15:0] mem [0:(2**15)-1];

  initial
    if (INSTRUCTIONS != "")
      $readmemb(INSTRUCTIONS, mem);

  always @(posedge clock)
    instruction <= mem[inst_addr];
endmodule





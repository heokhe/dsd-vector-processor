module ALU (
  input signed [511:0] operand1, operand2,
  input opcode, // 0 for addition, 1 for multiplication
  output [1023:0] result, // {result[543:512], result[31:0]} = operand1[31:0] op operand2[31:0] and so on
  output [31:0] cc // flattened array (cc[1:0] -> condition code for operand[31:0] and so on)
);
  /*
    cc <- 00 if result = 0
    cc <- 01 if result < 0
    cc <- 10 if result > 0
    cc <- 11 if result doesn't fit in the lower 32 bits
  */

  genvar i;
  generate
    for (i = 0; i < 16; i = i + 1) begin
      assign {result[512+32*i+:32], result[32*i+:32]} = opcode
        ? $signed(operand1[32*i+:32]) * $signed(operand2[32*i+:32])
        : $signed(operand1[32*i+:32]) + $signed(operand2[32*i+:32]);
      assign cc[2*i+1:2*i] = $signed(result[32*i+:32]) != $signed({result[512+32*i+:32], result[32*i+:32]}) 
        ? 11
        : {$signed({result[512+32*i+:32], result[32*i+:32]})>0, $signed({result[512+32*i+:32], result[32*i+:32]})<0};
    end
  endgenerate
endmodule



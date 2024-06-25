module RF (
  input clk, re, we, dw, // dw: double write used in writing R3-R4 after ALU operation
  input [1:0] read_addr1, read_addr2, write_addr,
  input [1023:0] write_data, // write_data[511:0] is used for single writes
  output [511:0] regout1, regout2,
  output [512*4-1:0] output_test // this output is only for testing
);

  reg [511:0] A[0:3];

  assign regout1 = re ? A[read_addr1] : 'bz;
  assign regout2 = re ? A[read_addr2] : 'bz;

  assign output_test = {A[0], A[1], A[2], A[3]};

  always @(negedge clk) begin
    if (dw)
      {A[2], A[3]} <= write_data;
    else if (we)
      A[write_addr] <= write_data[511:0];
  end

endmodule



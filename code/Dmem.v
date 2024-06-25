module Dmem
  #(parameter INITIAL_DATA="")
  (
    input clock, re, we,
    input [8:0] address,
    input [511:0] write_data, // mem[address] <- write_data[511:480] and so on
    output [511:0] data_out // data_out[511:480] <- mem[address] and so on
  );

  reg [31:0] mem [0:511];

  initial
    if(INITIAL_DATA!="")
      $readmemh(INITIAL_DATA, mem);

  genvar i;
  generate
    for(i=0;i<16;i=i+1) begin
      assign data_out[511-i*32-:32] = re ? mem[(address+i)%512] : 32'bz;
    end
  endgenerate

  integer j;
  always @(negedge clock) begin
    if(we) begin
      for(j=0;j<16;j=j+1) begin
        mem[(address+j)%512] <= write_data[511-j*32-:32];
      end
    end
  end

endmodule

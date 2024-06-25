module TB;

  reg clock;
  reg pc_reset;
  wire [511:0] regs [0:3];
  wire [31:0] cc;

  CPU #(.INSTRUCTIONS("./test/instructions.txt"), .INITIAL_DATA("./test/data.txt")) cpu 
    (.clock(clock), .pc_reset(pc_reset), .regs({regs[0], regs[1], regs[2], regs[3]}), .cc(cc));

  always
    #5 clock <= ~clock;

  integer t, i, j;
  initial begin
    clock = 0;
    pc_reset = 1;
    #10
    pc_reset = 0;

    #1
    // because we have 8 instructions
    for(t = 0; t < 8; t = t + 1) begin
      $display("\ntime = %0t", $time);
      for (i = 0; i < 4; i = i + 1) begin
        $write("A%0d=", i + 1);
        for(j = 0; j < 16; j = j + 1) begin
          $write("%h ", regs[i][511-j*32-:32]);
        end
        $write("\n");
      end
      $display("cc = %b", cc);
      #10;
    end

    $finish;
  end

endmodule

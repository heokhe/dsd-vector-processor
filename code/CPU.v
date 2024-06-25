module CPU
  #(parameter INSTRUCTIONS = "", INITIAL_DATA = "")
  (
    input clock, pc_reset,
    output [512*4-1:0] regs, // regs[511:0] = A[3] and so on (only for test)
    output reg [31:0] cc
  );

  reg [15:0] PC;
  wire [15:0] instruction;
  Imem #(
    .INSTRUCTIONS(INSTRUCTIONS)
  ) imem(
    .clock(clock),
    .inst_addr(PC),
    .instruction(instruction)
  );

  wire rf_re, rf_we, rf_dw;
  wire [1:0] reg1_addr, reg2_addr, write_reg_addr;
  wire [1023:0] write_reg_data;
  wire [511:0] reg1_out, reg2_out;
  RF rf (
    .clk(clock),
    .re(rf_re),
    .we(rf_we),
    .dw(rf_dw),
    .read_addr1(reg1_addr),
    .read_addr2(reg2_addr),
    .write_addr(write_reg_addr),
    .write_data(write_reg_data),
    .regout1(reg1_out),
    .regout2(reg2_out),
    .output_test(regs)
  );

  assign aluop = instruction[0];
  wire [1023:0] aluout;
  wire [31:0] ccwire;
  ALU alu(
    .operand1(reg1_out),
    .operand2(reg2_out),
    .opcode(aluop),
    .result(aluout),
    .cc(ccwire)
  );

  wire dmem_re, dmem_we;
  wire [8:0] dmem_addr;
  wire [511:0] dmem_write_data, dmem_data_out;
  Dmem #(
    .INITIAL_DATA(INITIAL_DATA)
  ) dmem(
    .clock(clock),
    .re(dmem_re),
    .we(dmem_we),
    .address(dmem_addr),
    .write_data(dmem_write_data),
    .data_out(dmem_data_out)
  );

  // all instruction read from the register file, except load
  assign rf_re = instruction[15:14] != 01;
  // load and move write to arbitrary registers
  assign rf_we = instruction[15]^instruction[14] != 0;
  // double write on alu instructions
  assign rf_dw = instruction[15:14] == 00;

  // load, store and mov only need to read one register (reg2)
  // so reg1 is always A1 (A[0]) for ALU instructions
  assign reg1_addr = 00;
  assign reg2_addr = instruction[15:14] == 00 ? 01 : instruction[1:0];
  assign write_reg_addr = instruction[15:14] == 01 ? instruction[1:0] : instruction[3:2];
  assign write_reg_data = instruction[15:14] == 00
    ? {aluout[511:0], aluout[1023:512]}
      : instruction[15:14] == 01
        ? {512'b0, dmem_data_out}
          : {512'b0, reg2_out};
  // enable read in dmem only during load instructions
  assign dmem_re = instruction[15:14] == 01;
  // enable write in dmem only during store instructions
  assign dmem_we = instruction[15:14] == 11;
  // immediate that specifies address of data in dmem
  assign dmem_addr = instruction[13:5];
  // data to be written is in reg2_out (in store)
  assign dmem_write_data = reg2_out;

  always @(negedge clock) begin
    // if this is an ALU instruction, update cc
    if (instruction[15:14] == 00) begin
      cc <= ccwire;
    end

    if (pc_reset==1)
      PC <= 0;
    else if (PC != (2 ** 15) - 1)
      PC <= PC + 1;
  end
endmodule

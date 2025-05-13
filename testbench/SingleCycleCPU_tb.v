`timescale 1ns / 1ps

module SingleCycleCPU_tb;
  reg clk;
  reg start;
  wire [31:0] PC;
  wire [31:0] instr;
  wire [31:0] readData1, readData2;
  wire [31:0] ALUOut;
  wire zero;
  wire [31:0] readData;
  wire [31:0] regWriteData;

  // Instantiate the SingleCycleCPU
  SingleCycleCPU uut (
    .clk(clk),
    .start(start)
  );

  // Clock generation
  initial begin
    clk = 0;
    start = 0;
    #5 start = 1;
    #10 start = 0;
    forever #5 clk = ~clk;
  end

  initial begin
     $dumpfile("wave.vcd");
     $dumpvars(0, uut);
     #10000 $finish;
  end

  // Display the program counter
  always @(posedge clk) begin
    $display("Time: %0t, PC: 0x%08x, Instruction: 0x%08x, ReadData1: 0x%08x, ReadData2: 0x%08x, ALUOut: 0x%08x, Zero: %b, ReadData: 0x%08x, RegWriteData: 0x%08x",
             $time, uut.m_PC.pc_o, uut.instr, uut.readData1, uut.readData2, uut.ALUOut, uut.zero, uut.m_DataMemory.readData, uut.regWriteData);
  end

endmodule

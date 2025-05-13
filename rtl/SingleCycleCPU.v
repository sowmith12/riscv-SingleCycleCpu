module SingleCycleCPU (
    input clk,
    input start

);
wire [31:0]PCPlus4,PCTarget,PCNext,PC;
wire branch,memRead,memtoReg,memWrite,ALUSrc,regWrite,zero,PCSrc;
wire [3:0]ALUCtl;
wire [1:0]ALUOp;
wire [31:0]ALUOut,instr,writeData,readData1,readData2,readData;
wire [4:0]readReg1,readReg2,writeReg;
wire [31:0] immExt, immExtshift;
wire [31:0] SrcB;
wire [31:0] regWriteData;  // New wire for register write data
wire [31:0] memWriteData;

Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(PCSrc),
    .s0(PCPlus4),
    .s1(PCTarget),
    .out(PCNext)
);

AND PCSrcsel(
        .a(branch),
        .b(zero),
        .c(PCSrc)
        );

PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(PCNext),
    .pc_o(PC)
);

Adder m_Adder_1(
    .a(PC),
    .b(32'd4),
    .sum(PCPlus4)
);

InstructionMemory m_InstMem(
    .readAddr(PC),
    .inst(instr)
);

//instruction memory ended


Control m_Control(
    .opcode(instr[6:0]),
    .branch(branch),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite)
);


Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(instr[19:15]),
    .readReg2(instr[24:20]),
    .writeReg(instr[11:7]),
    .writeData(regWriteData),
    .readData1(readData1),
    .readData2(readData2)
);


ImmGen #(.Width(32)) m_ImmGen(
    .inst(instr[31:0]),
    .imm(immExt)
);

//decode stage finished

ShiftLeftOne m_ShiftLeftOne(
    .i(immExt),
    .o(immExtshift)
);

Adder m_Adder_2(
    .a(PC),
    .b(immExtshift),
    .sum(PCTarget)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(readData2),
    .s1(immExt),
    .out(SrcB)
);



ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(instr[31:25]),
    .funct3(instr[14:12]),
    .ALUCtl(ALUCtl)
);

ALU m_ALU(
    .ALUCtl(ALUCtl),
    .A(readData1),
    .B(SrcB),
    .ALUOut(ALUOut),
    .zero(zero)
);

//execute cycle donee


DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(memWriteData),
    .readData(readData)
);
//memory stage done
Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(readData),
    .out(regWriteData)
);
//writeback stage done
assign memWriteData = readData2;  // <== Necessary!

endmodule

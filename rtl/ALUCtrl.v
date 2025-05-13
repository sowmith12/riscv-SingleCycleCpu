module ALUCtrl (
    input [1:0] ALUOp,
    input [6:0] funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUCtl = 4'b0000;  // LW/SW use add
        2'b01: ALUCtl = 4'b0001;  // Branch instructions use subtract
        2'b11: ALUCtl = 4'b1111;  // Trailing zeros counting
        2'b10: begin
            case (funct3)
                3'b000: begin
                    if (funct7 == 7'b0100000)
                        ALUCtl = 4'b0001;  // SUB
                    else
                        ALUCtl = 4'b0000;  // ADD
                end
                3'b010: ALUCtl = 4'b0010;  // SLT
                3'b110: ALUCtl = 4'b0011;  // OR
                3'b111: ALUCtl = 4'b0100;  // AND
                default: ALUCtl = 4'b0000;
            endcase
        end
        default: ALUCtl = 4'b0000;
    endcase
end
endmodule

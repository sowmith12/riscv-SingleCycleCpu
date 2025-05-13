module Control (
    input [6:0] opcode,
    output reg branch,
    output reg memRead,
    output reg memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite
);

always @(*) begin
    case (opcode)
        7'b0110011: begin // R-type instructions (add, sub, etc.)
            ALUOp = 2'b10;
            branch = 1'b0;
            memRead = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            ALUSrc = 1'b0;
            regWrite = 1'b1;
        end

        7'b0010011: begin // I-type instructions (addi, slti, etc.)
            ALUOp = 2'b10;
            branch = 1'b0;
            memRead = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            ALUSrc = 1'b1;
            regWrite = 1'b1;
        end

        7'b0000011: begin // Load instructions (lw, etc.)
            ALUOp = 2'b00;
            branch = 1'b0;
            memRead = 1'b1;
            memtoReg = 1'b1;
            memWrite = 1'b0;
            ALUSrc = 1'b1;
            regWrite = 1'b1;
        end

        7'b0100011: begin // Store instructions (sw, etc.)
            ALUOp = 2'b00;
            branch = 1'b0;
            memRead = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b1;
            ALUSrc = 1'b1;
            regWrite = 1'b0;
        end

        7'b1100011: begin // Branch instructions (beq, etc.)
            ALUOp = 2'b01;
            branch = 1'b1;
            memRead = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            ALUSrc = 1'b0;
            regWrite = 1'b0;
        end

        7'b1111111: begin //counting zero
            ALUOp = 2'b11;
            branch = 1'b0;
            memRead = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            ALUSrc = 1'b0;
            regWrite = 1'b1;
        end

        default: begin // Default values
            ALUOp = 2'b00;
            branch = 1'b0;
            memRead = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            ALUSrc = 1'b0;
            regWrite = 1'b0;
        end
    endcase
end
endmodule

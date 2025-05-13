module ALU (
    input [31:0] A, B,
    input [3:0] ALUCtl,
    output reg [31:0] ALUOut,
    output reg zero
);
integer i;
always @(*) begin
    case (ALUCtl)
        4'b0000: ALUOut = A + B;                 // ADD
        4'b0001: ALUOut = A - B;                 // SUB
        4'b0010: ALUOut = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;  // SLT
        4'b0011: ALUOut = A | B;                 // OR
        4'b0100: ALUOut = A & B;                 // AND
        4'b1111: begin : count_loop             // Trailing Zero Count (TZCNT) // ✅ Declare named block
            ALUOut = 32'd0;
            for (i = 0; i < 32; i = i + 1) begin
                if (A[i] == 1)
                    disable count_loop;         // ✅ Stops when 1 is found
                else
                    ALUOut = ALUOut + 1;
            end
        end
        default: ALUOut = 32'b0;
    endcase

    zero = (ALUOut == 0) ? 1'b1 : 1'b0;     // Zero flag for branch instructions
end
endmodule

module ImmGen#(parameter Width = 32) (
    input  [Width-1:0] inst,
    output reg signed [Width-1:0] imm
);

    wire [6:0] opcode = inst[6:0];

    always @(*) begin
        case (opcode)
        7'b0010011: imm[31:0] <= {{20{inst[31]}}, inst[31:20]};

        7'b0100011: begin
            imm[31:12] <= {{20{inst[31]}}};
            imm[11:5]  <= inst[31:25];
            imm[4:0]    <= inst[11:7];
        end

        7'b1100011: begin
            imm[31:12] <= {{20{inst[31]}}};
            imm[10:5]  <= inst[30:25];
            imm[4:1]    <= inst[11:8];
            imm[11]    <= inst[7];
            imm[0]      <= 1'b0;
        end

        7'b1101111: begin
            imm[31:13] <= {{19{inst[31]}}};
            imm[20]     <= inst[31];
            imm[10:1]  <= inst[30:21];
            imm[11]     <= inst[20];
            imm[19:12] <= inst[19:12];
            imm[0]      <= 1'b0;
        end
endcase
end
endmodule

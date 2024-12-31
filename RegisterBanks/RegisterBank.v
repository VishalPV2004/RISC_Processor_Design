`timescale 1ns / 1ps

module RegisterBank(
    input clk, reg_write,
    input [3:0] src_sel, dest_sel,
    input [7:0] write_data,
    output reg [7:0] src_data, dest_data
    );
    
    reg [7:0] B, C, D, E, H, L, A, F;
    reg [15:0] HL, DE, BC;
    
    always @(posedge clk) begin
        if (reg_write) begin
            case (dest_sel)
                4'b0000: A <= write_data;
                4'b0001: B <= write_data;
                4'b0010: C <= write_data;
                4'b0011: D <= write_data;
                4'b0100: E <= write_data;
                4'b0101: H <= write_data;
                4'b0110: L <= write_data;
                4'b0111: HL <= {H, L};
                4'b1000: DE <= {D, E};
                4'b1001: BC <= {B, C};
                default: ;
            endcase
        end
    end
    
    always @(*) begin
        case (src_sel)
            4'b0000: src_data = A;
            4'b0001: src_data = B;
            4'b0010: src_data = C;
            4'b0011: src_data = D;
            4'b0100: src_data = E;
            4'b0101: src_data = H;
            4'b0110: src_data = L;
            4'b0111: src_data = HL[7:0];
            4'b1000: src_data = DE[7:0];
            4'b1001: src_data = BC[7:0];
            default: src_data = 8'b0;
        endcase

        case (dest_sel)
            4'b0000: dest_data = A;
            4'b0001: dest_data = B;
            4'b0010: dest_data = C;
            4'b0011: dest_data = D;
            4'b0100: dest_data = E;
            4'b0101: dest_data = H;
            4'b0110: dest_data = L;
            4'b0111: dest_data = HL[15:8];
            4'b1000: dest_data = DE[15:8];
            4'b1001: dest_data = BC[15:8];
            default: dest_data = 8'b0;
        endcase
        
        
        
    end

endmodule


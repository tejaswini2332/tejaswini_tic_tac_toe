module RowColDecoder (input [1:0] row, input [1:0] col, output reg [3:0] index);
    always @(*) begin
        index = (row-1) * 3 + col-1; 
    end
endmodule
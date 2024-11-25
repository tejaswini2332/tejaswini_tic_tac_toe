module TCell (input wire clk,input wire set,input wire reset,input wire set_symbol,output reg valid,output reg symbol);

    initial begin
        symbol = 0;
        valid = 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            symbol <= 0;
            valid <= 0;
        end
        else if (set && !valid) begin
            symbol <= set_symbol;
            valid <= 1;
        end
    end
endmodule
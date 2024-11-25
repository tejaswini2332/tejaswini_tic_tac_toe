`include "Tcell.v"
`include "RowColDecoder.v"

module TBox (input clk, input set, input reset, input [1:0] row, input [1:0] col, output reg [8:0] valid, output reg [8:0] symbol, output reg [1:0] game_state);
    wire [8:0] cell_valid;
    wire [8:0] cell_symbol; 
    reg current_player;
    wire [3:0] cell_index;

    RowColDecoder rcd (.row(row), .col(col), .index(cell_index));

    initial begin
        valid <= 9'b0; 
        symbol <= 9'b0;
        game_state <= 2'b00; 
        current_player <= 1'b1; 
    end

    genvar i;
    generate
        for (i = 0; i < 9; i = i + 1) begin : cell_array
            wire set_cell = (cell_index == i) && set;
            TCell cell_inst (.clk(clk), .reset(reset), .set(set_cell), .set_symbol(current_player), .valid(cell_valid[i]), .symbol(cell_symbol[i]));
        end
    endgenerate

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid <= 9'b0; 
            symbol <= 9'b0; 
            game_state <= 2'b00; 
            current_player <= 1'b1; 
        end else if (set && game_state == 2'b00) begin
            if (!cell_valid[cell_index]) begin
                valid <= cell_valid; 
                symbol[cell_index] <= current_player; 
                valid[cell_index] <= 1'b1; 
                current_player <= ~current_player; 
            end
        end
    end

    always @(*) begin
        if (game_state == 2'b00) begin
            if ((cell_valid[0] && cell_valid[1] && cell_valid[2] && cell_symbol[0] == cell_symbol[1] && cell_symbol[1] == cell_symbol[2]) ||
                (cell_valid[3] && cell_valid[4] && cell_valid[5] && cell_symbol[3] == cell_symbol[4] && cell_symbol[4] == cell_symbol[5]) ||
                (cell_valid[6] && cell_valid[7] && cell_valid[8] && cell_symbol[6] == cell_symbol[7] && cell_symbol[7] == cell_symbol[8]) ||
                (cell_valid[0] && cell_valid[3] && cell_valid[6] && cell_symbol[0] == cell_symbol[3] && cell_symbol[3] == cell_symbol[6]) ||
                (cell_valid[1] && cell_valid[4] && cell_valid[7] && cell_symbol[1] == cell_symbol[4] && cell_symbol[4] == cell_symbol[7]) ||
                (cell_valid[2] && cell_valid[5] && cell_valid[8] && cell_symbol[2] == cell_symbol[5] && cell_symbol[5] == cell_symbol[8]) ||
                (cell_valid[0] && cell_valid[4] && cell_valid[8] && cell_symbol[0] == cell_symbol[4] && cell_symbol[4] == cell_symbol[8]) ||
                (cell_valid[2] && cell_valid[4] && cell_valid[6] && cell_symbol[2] == cell_symbol[4] && cell_symbol[4] == cell_symbol[6])) 
            begin
                game_state <= (current_player == 1'b1) ? 2'b10 : 2'b01; 
            end else if (&cell_valid) begin
                game_state <= 2'b11;
            end else begin
                game_state <= game_state; 
            end
        end
    end
endmodule
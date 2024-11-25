# Tic-Tac-Toe Game Implementation - Verilog

## Overview
This project implements a simple 3x3 Tic-Tac-Toe game in Verilog using a `TBox` module, where two players can alternate placing their moves on a grid. The game is designed to run on hardware using a clock, set, and reset signals, and supports tracking the validity and symbol of each cell. The game state is updated based on player inputs, and the module detects win conditions, draws, and player turns. 

## Modules

### `TBox`
The `TBox` module handles the overall game state and player turns. It consists of a 3x3 grid of `TCell` modules, each representing a cell on the Tic-Tac-Toe board. The module listens to input signals such as the clock (`clk`), set (`set`), and reset (`reset`), as well as the row and column indices for cell selection. The `TBox` module tracks:
- The validity of each cell (`valid`)
- The symbol placed in each cell (`symbol`)
- The game state (`game_state`), indicating the progress of the game.

### `TCell`
Each `TCell` module represents an individual cell on the Tic-Tac-Toe board. It has inputs for setting a symbol (`set_symbol`) and tracking whether a cell is valid and which player owns it. The module's output indicates whether the cell is occupied and the symbol (`X` or `O`) placed in it.

### `RowColDecoder`
The `RowColDecoder` module takes the row and column indices as inputs and decodes them into a unique index for each cell in the 3x3 grid. This helps the `TBox` module locate the correct cell to update when a player places a move.

## Signals

### Inputs:
- `clk` (1-bit): Clock signal for synchronizing operations.
- `set` (1-bit): A signal indicating when a player sets a symbol in a cell.
- `reset` (1-bit): A signal to reset the game to its initial state.
- `row` (2-bit): Row index (0 to 2) of the cell where the player wants to place a symbol.
- `col` (2-bit): Column index (0 to 2) of the cell where the player wants to place a symbol.

### Outputs:
- `valid` (9-bit): Indicates whether each cell on the Tic-Tac-Toe grid is valid (i.e., whether it has been filled with a symbol).
- `symbol` (9-bit): Contains the symbols placed in each cell (`X` or `O`).
- `game_state` (2-bit): Represents the current state of the game:
  - `00`: Game in progress
  - `01`: Player 2 wins
  - `10`: Player 1 wins
  - `11`: Draw

## Game Logic
The game is controlled by alternating players. The first player always uses the symbol 'X', and the second player uses 'O'. Players take turns by setting a symbol in the corresponding cell when the `set` signal is activated. The game continues until one of the following conditions is met:
1. A player wins by forming a line of 3 symbols (horizontally, vertically, or diagonally).
2. All cells are filled, resulting in a draw.
3. The game is reset to its initial state using the `reset` signal.

The game state (`game_state`) is updated after every valid move, and the `valid` and `symbol` outputs reflect the status of the Tic-Tac-Toe grid.

### Winning Conditions:
The winning conditions are checked after each move. A player wins if they place three of their symbols consecutively in a row, column, or diagonal. The game state is updated accordingly to indicate the winner.

### Draw Condition:
If all cells are filled and there is no winner, the game state will indicate a draw.

## Design Considerations
- **Player Turn Management:** The game alternates between Player 1 (symbol 'X') and Player 2 (symbol 'O'). The `current_player` register is used to track whose turn it is.
- **Reset Mechanism:** The `reset` signal ensures the game can be restarted at any time, resetting all cell states and game conditions.
- **Modular Design:** The game board is divided into individual `TCell` modules, and each `TCell` can be independently updated based on the row and column selected by the player.

## How to Use
1. Provide a clock (`clk`) signal to synchronize the game logic.
2. Use the `set` signal to place a symbol in a cell, specifying the row and column indices via `row` and `col`.
3. Monitor the `valid`, `symbol`, and `game_state` outputs to track the status of the game.

## Example
- Player 1 selects cell (0, 0) and places an 'X'.
- Player 2 selects cell (0, 1) and places an 'O'.
- The game continues until one player wins or a draw occurs.

## File Structure
- `TBox.v`: Contains the main Tic-Tac-Toe game logic.
- `TCell.v`: Defines the behavior of individual cells on the board.
- `RowColDecoder.v`: Decodes row and column indices into a cell index.
  
## Future Enhancements
- Add support for more players or a different board size (e.g., 4x4).
- Implement a scoring system to track wins and losses over multiple rounds.
- Enhance the user interface with LEDs or a display for better interaction. 


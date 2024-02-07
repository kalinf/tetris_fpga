Implementation in Verilog of the well-known game Tetris. The program is
intended for synthesis on an FPGA and supports the VGA standard. The
repository also contains a simulation allowing the game to be run in a
local environment.

Main components:

🔸 Tetris: Top-level module containing the game logic and instantiating
the remaining modules. 🔸 VGA_sync: Circuit controlling the control
signals for the VGA output. 🔸 color_generator: Determines the displayed
color in a combinational manner. 🔸 pseudo_random_number_generator:
Relies on a 9-bit shift register with linear feedback (feedback
polynomial: x\^9 + x\^4 + 1).

Prerequisites for running the simulation:

🔸 Verilator 🔸 g++ 🔸 CImg

To run the simulation:

verilator -cc \--trace Tetris.v \--exe tb_tetris.cpp

Replace the generated VTetris.mk file with the one from the repository.

make -C obj_dir -f VTetris.mk VTetris

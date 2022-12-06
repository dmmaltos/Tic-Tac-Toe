# Tic-Tac-Toe

Created by Dylan Maltos

A basic Tic-Tac-Toe game which has been completely written in NASM assembly.

# Project Goals

* Print a tic-tac-toe style game board which updates according to user input for moves
* Correctly read user input for player moves
* Implement a win check feature which notifies when the game is over once a player wins, along with announcing the winner

# How to build and run the program

<pre>
nasm -f elf64 Tic-Tac-Toe.asm

ld -o Tic-Tac-Toe Tic-Tac-Toe.o

./Tic-Tac-Toe
</pre>

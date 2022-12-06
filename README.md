# Tic-Tac-Toe

Created by Dylan Maltos

A basic Tic-Tac-Toe game which has been completely written in NASM assembly.

# Project Goals

* Print a tic-tac-toe style game board which updates according to user input for the player moves
* Correctly read user input for player moves
* Implement a win check feature which notifies when the game is over once a player wins, along with announcing the winner
* Implement a bitwise swap feature which correctly swaps between player 0 and player 1 after each players move

# How to build and run the program

<pre>
nasm -f elf64 Tic-Tac-Toe.asm

ld -o Tic-Tac-Toe Tic-Tac-Toe.o

./Tic-Tac-Toe
</pre>

# Program Structure

There are several strings saved to memory under section .data that are used to implement specific functions throughout the game and program. As shown:

	create_new_line:
		db 10
	create_new_line_size equ $-create_new_line

	draw_the_board:
		db "_|_|_", 10
		db "_|_|_", 10
		db "_|_|_", 10, 0
	draw_the_board_size equ $-draw_the_board

	msg_player:
		db "Player ", 0
	msg_player_size equ $-msg_player

	player:
		db "0", 0
	player_size equ $-player

	win:
		db 0
	
	type_integer:
		db "Please enter an integer 0-8: ", 0
	type_integer_size equ $-type_integer 

	end_the_game_message:
		db "Game over!", 10, 0
	end_the_game_message_size equ $-end_the_game_message

	winner_msg:
		db " wins the game!", 0
	winner_msg_size equ $-winner_msg

# Errors to fix

Currently, I need to go over and figure out an error in the wincheck feature. As of right now it will automatically end the game and declare a winner if someone does not place a move in the middle of the Tic-Tac-Toe gameboard for the first move.

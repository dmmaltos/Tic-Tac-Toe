section .bss
	input resb 1
	trashinput resb 1

section .data

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

section .text
	global _start

_start:

; This is the programs main function that loops under conditions based on user input
main_game_loop:

        ; Announces the first player
        mov rsi, msg_player
        mov rdx, msg_player_size
        call print

        ; Prints 0 as the first player
        mov rsi, player
        mov rdx, player_size
        call print

        ; Prints a new line after announcing player x
        mov rsi, create_new_line
        mov rdx, create_new_line_size
	call print

        ; Prints the tic-tac-toe board      
        mov rsi, draw_the_board
        mov rdx, draw_the_board_size
        call print

        ; Prints a new line after the tic-tac-toe board is printed
        mov rsi, create_new_line
        mov rdx, create_new_line_size
	call print

	; Prompts the user to enter an integer
	mov rsi, type_integer
	mov rdx, type_integer_size
	call print

	; Lets user input for their move
	repeat_read_user_input:
		call read_user_input
	cmp rax, 0
	je repeat_read_user_input

	mov al, [input]
	sub al, 48	
	
	; Continously updates the board according to user input
	call draw_board_update
	
	; Continously check for a win
	call wincheck_start

	cmp byte[win], 1
	je end_the_game ; if the game is over then this occurs
	
	; Keeps the player changing
	call change_current_player
	
	; Make sure this keeps looping till a player wins
	jmp main_game_loop

; Allows print to print when called
print:
	mov rax, 1
	mov rdi, 1
	syscall	
	ret	

; Allows user to provide input for their moves
read_user_input:
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 1
	syscall

	cmp byte[input], 0x0A
	jz end_read_user_input

	mov rdi, 0
	mov rsi, trashinput
	mov rdx, 1

	loop:
		mov rax, 0
		syscall
	
		cmp byte[trashinput], 0x0A
		jz end_read_user_input
		jmp loop
	
	; Ends user input
	end_read_user_input:
	
	ret

; Main for keeping the board updated based on user input for moves during the game, and replacing "_" on the board with either "x" or "o"
draw_board_update:
	cmp rax, 1	; if rax is 1 
	je position_one

	cmp rax, 2
	je position_two
	
	cmp rax, 3
	je position_three

	cmp rax, 4
	je position_four

	cmp rax, 5
	je position_five

	cmp rax, 6
	je position_six

	cmp rax, 7
	je position_seven

	cmp rax, 8
	je position_eight

	cmp rax, 9
	je position_nine

	jmp end_board_update

	; Defines the first position on the board
	position_one:
		mov rax, 0
		jmp board_update_continue

	; Defines the second position on the board
	position_two:
		mov rax, 2
		jmp board_update_continue
	
	; Defines the third position on the board	
	position_three:
		mov rax, 4
		jmp board_update_continue

	; Defines the fourth position on the board
	position_four:
		mov rax, 6
		jmp board_update_continue
	
	; Defines the fifth position on the board
	position_five:
		mov rax, 8
		jmp board_update_continue
		
	; Defines the sixth position on the board
	position_six:
		mov rax, 10
		jmp board_update_continue
	
	; Defines the seventh position on the board
	position_seven:
		mov rax, 12
		jmp board_update_continue

	; Defines the eigth position on the board
	position_eight:
		mov rax, 14
		jmp board_update_continue
	
	; Defines the ninth position on the board
	position_nine:
		mov rax, 16
		jmp board_update_continue
	
	board_update_continue:
		lea rbx, [draw_the_board + rax] 
		mov rsi, player

		; Checks if  its Player 0's turn "_" will be replaced with "x"
		cmp byte[rsi], "0"
		je x_on_board

		; Checks if it's Player 1's turn "_" will be replaced with "o"
		cmp byte[rsi], "1"
		je o_on_board
		
		; Actually puts "x" on board
		x_on_board:
			mov cl, "x"
			jmp board_update

		; Actually puts "o" on board
		o_on_board:
			mov cl, "o"
			jmp board_update

		; This finally actually updates the board accordingly
		board_update:
			mov [rbx], cl
		
		; Returns after being updating the board
		end_board_update:
		ret

; Changes the player on different turns using bitwise "xor"
change_current_player:
	xor byte[player], 1
	ret
; Starts the programs process for checking if their is a game winner
wincheck_start:
	call wincheck_rows
	ret

; Intiates the programs process for checking rows for wins (apart of the wincheck sequence)
wincheck_rows:
	mov rcx, 0
	
	; Keeps the program checking rows
	loop_wincheck_rows:
		cmp rcx, 0	; checks first row 
		je row_first

		cmp rcx, 1	; checks second row
		je row_second

		cmp rcx, 2	; checks third row
		je row_third
	
		call wincheck_columns ; by calling wincheck_columns here the program now will also start checking the collumns	
		ret
	
		; Defines the first row
		row_first:
			mov rsi, 0
			jmp row_checker

		; Defines the second row
		row_second:
			mov rsi, 6
			jmp row_checker

		; Defines the third row
		row_third:
			mov rsi, 12
			jmp row_checker

		; Actually checks the rows
		row_checker:
			inc rcx
			lea rbx, [draw_the_board + rsi]
			mov al, [ebx]
			cmp al, "_"	
			je loop_wincheck_rows
			
			add rsi, 2
             		lea rbx, [draw_the_board + rsi]	
			cmp al, [rbx]
			jne loop_wincheck_rows
					
			add rsi, 2
               		lea rbx, [draw_the_board + rsi]
			cmp al, [rbx]
			jne loop_wincheck_rows

		mov byte[win], 1
		ret

; Main for checking the collumns to see if there is a winner (apart of the wincheck sequence)
wincheck_columns:
	mov rcx, 0
	
	; Keep the program checking columns
	loop_wincheck_columns:
		cmp rcx, 0	; checks first column
		je column_first

		cmp rcx, 1	; checks second column
		je column_second
		
		cmp rcx, 2	; checks third column
		je column_third
		
		call wincheck_diagonals
		ret

		; Defines the first column and jumps to actually check it
		column_first:
			mov rsi, 0
			jmp column_checker
	
		; Defines the second column and jumps to actually check it
		column_second:
			mov rsi, 2
 			jmp column_checker

		; Defines the third column and jumps to actually check it
		column_third:
			mov rsi, 4
			jmp column_checker

		; Actually checks the columns
		column_checker:
			inc rcx
            		lea rbx, [draw_the_board + rsi]
			mov al, [rbx]
			cmp al, "_"
			je loop_wincheck_columns

			add rsi, 6
			lea rbx, [draw_the_board + rsi]

			cmp al, [rbx]
			jne loop_wincheck_columns

			add rsi, 6
			lea rbx, [draw_the_board + rsi]

			cmp al, [rbx]
			jne loop_wincheck_columns
		
			mov byte[win], 1
			ret

; Main for checking the diagonals of the rows and coloumns for a win
wincheck_diagonals:
	mov rcx, 0
	
	; Keeps the program checking the diagonals for a win
	loop_wincheck_diagonals:
		cmp rcx, 0
		je diagonals_first ; checks the first diagonal;
		
		cmp rcx, 1
		je diagonals_second ; checks the second diagonal
		ret
	
		; Defines the first diagonal and jumps to actually check it 
		diagonals_first:
			mov rsi, 0
			mov rdx, 8
			jmp diagonals_checker
	
		; Defines the second diagonal and jumps to actually check it
		diagonals_second:
			mov rsi, 4
			mov rdx, 4
			jmp diagonals_checker
	
		; Actually checks the diagonal
		diagonals_checker:
			inc rcx	
     			lea rbx, [draw_the_board + rsi]
			mov al, [rbx]
			mov al, "_"
			je loop_wincheck_diagonals
	
			add rsi, rdx
     			lea rbx, [draw_the_board + rsi]
			cmp al, [rbx]
			jne loop_wincheck_diagonals
	
			add rsi, rdx
        		lea rbx, [draw_the_board + rsi]
			cmp al, [rbx]
			jne loop_wincheck_diagonals
		
			mov byte[win], 1
			ret

end_the_game:
	; Creates new line
	mov rsi, create_new_line
	mov rdx, create_new_line_size
	call print

	; Prints the game board
	mov rsi, draw_the_board
	mov rdx, draw_the_board_size
	call print
	
	; Creates new line
	mov rsi, create_new_line
	mov rdx, create_new_line_size
	call print

	; Prints the end of game message from memory
	mov rsi, end_the_game_message
	mov rdx, end_the_game_message_size
	call print
	
	; Prints the player message from memory
	mov rsi, msg_player
	mov rdx, msg_player_size
	call print

	; Prints who the player is who won
	mov rsi, player
	mov rdx, player_size
	call print
	
	; Prints " wins!" from memmory
	mov rsi, winner_msg
	mov rdx, winner_msg_size
	call print

	; Creates new line
        mov rsi, create_new_line
        mov rdx, create_new_line_size
        call print
	
	jmp endprogram

; Ends the  program
endprogram:
	mov rax, 60
	mov rdi, 0
	syscall

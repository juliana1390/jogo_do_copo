; Juliana da Silva Santos n USP 10727952
; Renan Silva Soriano n USP 11794824

; JOGO DO COPO

; ############# TABLE OF COLORS #############

; 0 white                           0000 0000
; 256 brown                         0001 0000
; 512 green                         0010 0000
; 768 olive                         0011 0000
; 1024 marine blue                  0100 0000
; 1280 purple                       0101 0000
; 1536 teal                         0110 0000
; 1792 silver                       0111 0000
; 2048 gray                         1000 0000
; 2304 red                          1001 0000
; 2560 lime                         1010 0000
; 2816 yellow                       1011 0000
; 3072 blue                         1100 0000
; 3328 pink                         1101 0000
; 3584 aqua                         1110 0000
; 3840 white                        1111 0000

; ###########################################

jmp main

; =================================================
; LABELS ------------------------------------------
char: var #1	; input
glass: var #1	; keeps the saved random number of the round

; =================================================
; MESSAGES ----------------------------------------
message1: string "         QUE PENA, VOCE ERROU!!!        "
message2: string "         A moeda estava no copo:        "

; =================================================
; MAIN --------------------------------------------
main:

    call clear_screen
	; =================================================	
	; START SCREEN ------------------------------------
	loadn r1, #scene0Scrline0
	loadn r2, #2560
	call print_screen2

	loadn r1, #scene1Scrline0
	loadn r2, #2560
	call print_screen2
	
    ; =================================================
    ; GET RANDOM --------------------------------------
    call get_char
    call clear_screen
    loadn r1, #scene2Scrline0
    loadn r2, #2560
    call print_screen2

    call generate_num      ; calls the function to get a num to be the glass that keeps the coin 

    ; =================================================
    ; CHOOSE GLASS ------------------------------------
    call clear_screen
    loadn r1, #scene3Scrline0
    loadn r2, #2560
    call print_screen2

    call guess      ; calls function for the player choose the glass in attempt to find the coin

halt


; FUNCTIONS

; =================================================
; READ RANDOM NUMBER ------------------------------
generate_num:   ; this function choose the number of the glass the keeps the coin
    push r0
    push r2
    push r3
    push r1
    push r4
    push r5

    loadn r1, #255    ; ' ' blank space
    loadn r2, #3      ; max num
    loadn r3, #1100   ; position on screen to check printed numbers
    loadn r4, #0      ; num

    loop:
        loadn r2, #10   ; this loop is for incrementing the number
        loadn r2, #10
        loadn r2, #10
        loadn r2, #10
        inc r4        

    inchar r0     ; get input from keyboard
    cmp r0, r1    ; compares the input to blank space ' '
    jeq loop      ; if nothing was typed (input == ' '), jumps to loop

    loadn r2, #3    
    mod r4, r4, r2    ; (r4 % r2) ** loop 1st run: [1 / 3 = (rest 1)] ** 2nd run: [2 / 3 = (rest 2)]
    loadn r5, #1
    add r4, r4, r5    ; (r4 % r2) + 1 ** loop 1st run: [(rest 1) + 1 = 2] ** 2nd run: [(rest 2) + 1 = 3]
    loadn r5, #'0'
    add r4, r4, r5    ; adds 0 to num for printing it properly, otherwise the print wont stop, it'll go to next labels
    store glass, r4   ; stores the chosen value (num) into the label "glass"
    ;outchar r4, r3   ; DEBUG: prints chosen num

    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; ======================================================
; CHECK VALID KEY --------------------------------------
check_input:    ; this accept only input with 1, 2 and 3 to continue
    push r0
    push r1
    push r2
    push r3

    call get_char
    load r0, char

    loop_1:
        loadn r1, #'1'
        cmp r1, r0
        jne loop_2
        jeq check_input_end

    loop_2:
        loadn r2, #'2'
        cmp r2, r0
        jne loop_3
        jeq check_input_end
        
    loop_3:
        loadn r3, #'3'
        cmp r3, r0
        jne loop_1
        jeq check_input_end

    check_input_end:
        pop r3
        pop r2
        pop r1
        pop r0
        rts

; =================================================
; GUESS -------------------------------------------
guess:          ; this function gets the input of user and compares to glass number that keeps the coin
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
  
    loadn r0, #1100    ; postition on screen for printing
    load r4, glass      ; the glass with the coin

    ;[DEBUG] checks the number of the glass that keeps the coin
    ;inc r0             ; increments postition on screen for printing
    ;outchar r4, r0     ; prints

    call check_input    ; only get 1, 2, ou 3 as input
    load r1, char       ; loads the input
    outchar r1, r0      ; prints the chosen number

    loadn r0, #'1'
    cmp r0, r4      ; compares glass to 1
    jeq glass_1
    
    loadn r0, #'2'
    cmp r0, r4      ; compares glass to 2
    jeq glass_2

    loadn r0, #'3'
    cmp r0, r4      ; compares glass to 3
    jeq glass_3

    glass_1:
        cmp r4, r1          ; compares input to glass
        jeq show_coin_1     ; if equal, the coin is into the glass 1
        jne fail

    glass_2:     
        cmp r4, r1
        jeq show_coin_2
        jne fail
        
    glass_3:    
        cmp r4, r1
        jeq show_coin_3
        jne fail  

    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; =================================================    
; FAIL --------------------------------------------
fail:           ; called when user fail to guess the number
    push r0
    push r1
    push r3
    push r4

    call get_char
    call clear_screen

    loadn r0, #240
    loadn r1, #message1     ; message 1
    loadn r3, #3328
    call print_string

    loadn r0, #520
    loadn r1, #message2     ; message 2
    loadn r3, #2816
    call print_string

    loadn r0, #660
    load r1, glass          ; show the glass where the coin was
    loadn r3, #2560
    add r1, r1, r3
    outchar r1, r0

    call get_char

    pop r4
    pop r3
    pop r1
    pop r0
    rts

; SHOW COIN 1 -------------------------------------
show_coin_1:    ; prints found coin in glass 1
	push r1
	push r2
	
    call get_char
	call clear_screen
	loadn r1, #scene4Scrline0
	loadn r2, #2816
	call print_screen2
	call get_char

	pop r2
	pop r1
	rts

; SHOW COIN 2 -------------------------------------	
show_coin_2:    ; prints found coin in glass 2
	push r1
	push r2
	
    call get_char
	call clear_screen
	loadn r1, #scene5Scrline0
	loadn r2, #3328
	call print_screen2
	call get_char

	pop r2
	pop r1
	rts

; SHOW COIN 3 -------------------------------------	
show_coin_3:    ; prints found coin in glass 3
	push r1
	push r2
	
    call get_char
	call clear_screen
	loadn r1, #scene6Scrline0
	loadn r2, #3072
	call print_screen2
    call get_char
		
	pop r2
	pop r1
	rts

; ====================================================================
; GAME SCENE SCREENS =================================================
	
	; EMPTY SCENE ----------------------------------------------------
    scene0Scrline0:  string "                                        "
    scene0Scrline1:  string "                                        "
    scene0Scrline2:  string "                                        "
    scene0Scrline3:  string "                                        "
    scene0Scrline4:  string "                                        "
    scene0Scrline5:  string "                                        "
    scene0Scrline6:  string "                                        "
    scene0Scrline7:  string "                                        "
    scene0Scrline8:  string "                                        "
    scene0Scrline9:  string "                                        "
    scene0Scrline10: string "                                        "
    scene0Scrline11: string "                                        "
    scene0Scrline12: string "                                        "
    scene0Scrline13: string "                                        "
    scene0Scrline14: string "                                        "
    scene0Scrline15: string "                                        "
    scene0Scrline16: string "                                        "
    scene0Scrline17: string "                                        "
    scene0Scrline18: string "                                        "
    scene0Scrline19: string "                                        "
    scene0Scrline20: string "                                        "
    scene0Scrline21: string "                                        "
    scene0Scrline22: string "                                        "
    scene0Scrline23: string "                                        "
    scene0Scrline24: string "                                        "
    scene0Scrline25: string "                                        "
    scene0Scrline26: string "                                        "
    scene0Scrline27: string "                                        "
    scene0Scrline28: string "                                        "
    scene0Scrline29: string "                                        "
    
    ; SCENE 1 --------------------------------------------------------
    scene1Scrline0:  string "                                        "
    scene1Scrline1:  string "                                        "
    scene1Scrline2:  string "                                        "
    scene1Scrline3:  string "                                        "
    scene1Scrline4:  string "                                        "
    scene1Scrline5:  string "    @@@@@@    @@@@     @@@@     @@@@    "
    scene1Scrline6:  string "      @@     @@  @@   @@       @@  @@   "
    scene1Scrline7:  string "      @@     @@  @@   @@  @@   @@  @@   "
    scene1Scrline8:  string "   @@ @@     @@  @@   @@   @   @@  @@   "
    scene1Scrline9:  string "   @@@@@      @@@@     @@@@     @@@@    "
    scene1Scrline10: string "                                        "
    scene1Scrline11: string "                                        "
    scene1Scrline12: string "             @@@@      @@@@             "
    scene1Scrline13: string "             @@ @@    @@  @@            "
    scene1Scrline14: string "             @@  @@   @@  @@            "
    scene1Scrline15: string "             @@ @@    @@  @@            "
    scene1Scrline16: string "             @@@@      @@@@             "
    scene1Scrline17: string "                                        "
    scene1Scrline18: string "                                        "
    scene1Scrline19: string "     @@@@    @@@@    @@@@     @@@@      "
    scene1Scrline20: string "    @@      @@  @@   @@  @   @@  @@     "
    scene1Scrline21: string "    @@      @@  @@   @@@@    @@  @@     "
    scene1Scrline22: string "    @@      @@  @@   @@      @@  @@     "
    scene1Scrline23: string "     @@@@    @@@@    @@       @@@@      "
    scene1Scrline24: string "                                        "
    scene1Scrline25: string "                                        "
    scene1Scrline26: string "                                        "
    scene1Scrline27: string "        Pressione qualquer tecla        "
    scene1Scrline28: string "              para continuar            "
    scene1Scrline29: string "                                        "

    ; GAME SCENE 2 ---------------------------------------------------
    scene2Scrline0:  string "                                        "
    scene2Scrline1:  string "                                        "
    scene2Scrline2:  string "                                        "
    scene2Scrline3:  string "  A MOEDA FOI COLOCADA EMBAIXO DE UM    "
    scene2Scrline4:  string "                                        "
    scene2Scrline5:  string " COPO... ELES ESTAO SENDO EMBARALHADOS  "
    scene2Scrline6:  string "                                        "
    scene2Scrline7:  string "                                        "
    scene2Scrline8:  string "                                        "
    scene2Scrline9:  string "                                        "
    scene2Scrline10: string "                                        "
    scene2Scrline11: string "  PRESSIONE QUALQUER TECLA PARA QUE O   "
    scene2Scrline12: string "                                        "
    scene2Scrline13: string "          EMBARALHAMENTO PARE...        "
    scene2Scrline14: string "                                        "
    scene2Scrline15: string "                                        "
    scene2Scrline16: string "                                        "
    scene2Scrline17: string "   _______                   _______    "
    scene2Scrline18: string "  |       |     _______     |       |   "
    scene2Scrline19: string "  |       |    |       |    |       |   "
    scene2Scrline20: string "  |       |    |       |    |       |   "
    scene2Scrline21: string "  |       |    |       |    |       |   "
    scene2Scrline22: string "  |       |    |       |    |       |   "
    scene2Scrline23: string "  /_______\\    |       |    /_______\\ "
    scene2Scrline24: string "                 /________\\            "
    scene2Scrline25: string "                                        "
    scene2Scrline26: string "                                        "
    scene2Scrline27: string "                                        "
    scene2Scrline28: string "                                        "
    scene2Scrline29: string "                                        "

    ; GAME SCENE 3 ---------------------------------------------------
    scene3Scrline0:  string "                                        "
    scene3Scrline1:  string "                                        "
    scene3Scrline2:  string "                                        "
    scene3Scrline3:  string "          ONDE ESTA A MOEDA???          "
    scene3Scrline4:  string "                                        "
    scene3Scrline5:  string "                                        "
    scene3Scrline6:  string "        ESCOLHA UM COPO E TENTE         "
    scene3Scrline7:  string "                                        "
    scene3Scrline8:  string "              ENCONTRA-LA               "
    scene3Scrline9:  string "                                        "
    scene3Scrline10: string "                                        "
    scene3Scrline11: string "                                        "
    scene3Scrline12: string "   _______      _______      _______    "
    scene3Scrline13: string "  |       |    |       |    |       |   "
    scene3Scrline14: string "  |       |    |       |    |       |   "
    scene3Scrline15: string "  |   1   |    |   2   |    |   3   |   "
    scene3Scrline16: string "  |       |    |       |    |       |   "
    scene3Scrline17: string "  |       |    |       |    |       |   "
    scene3Scrline18: string "  /_______\\    /_______\\    /_______\\"
    scene3Scrline19: string "                                        "
    scene3Scrline20: string "                                        "
    scene3Scrline21: string "                                        "
    scene3Scrline22: string "                                        "
    scene3Scrline23: string "       Digite o numero do copo...       "
    scene3Scrline24: string "                                        "
    scene3Scrline25: string "                                        "
    scene3Scrline26: string "                                        "
    scene3Scrline27: string "                                        "
    scene3Scrline28: string "                                        "
    scene3Scrline29: string "                                        "

    ; GAME SCENE 4 ---------------------------------------------------
    scene4Scrline0:  string "                                        "
    scene4Scrline1:  string "                               _|_      "
    scene4Scrline2:  string "              PARABENS!!!       |       "
    scene4Scrline3:  string "                                        "
    scene4Scrline4:  string "         VOCE ENCONTROU A MOEDA         "
    scene4Scrline5:  string "                                        "
    scene4Scrline6:  string "          _|_                           "
    scene4Scrline7:  string "           |                            "
    scene4Scrline8:  string "                                        "
    scene4Scrline9:  string "   _______                              "
    scene4Scrline10: string "  |       |     _______      _______    "
    scene4Scrline11: string "  |       |    |       |    |       |   "
    scene4Scrline12: string "  |   1   |    |   2   |    |   3   |   "
    scene4Scrline13: string "  |       |    |       |    |       |   "
    scene4Scrline14: string "  |       |    |       |    |       |   "
    scene4Scrline15: string "  /_______\\    |       |    |       |  "
    scene4Scrline16: string "                /_______\\    /_______\\"
    scene4Scrline17: string "                                        "
    scene4Scrline18: string "         @                              "
    scene4Scrline19: string "                                        "
    scene4Scrline20: string "                                        "
    scene4Scrline21: string "                                        "
    scene4Scrline22: string "                                        "
    scene4Scrline23: string "        A MOEDA ESTAVA NO COPO 1        "
    scene4Scrline24: string "                                        "
    scene4Scrline25: string "                                        "
    scene4Scrline26: string "                                        "
    scene4Scrline27: string "                                        "
    scene4Scrline28: string "                                        "
    scene4Scrline29: string "                                        "
    
    ; GAME SCENE 5 ---------------------------------------------------
    scene5Scrline0:  string "                                        "
    scene5Scrline1:  string "                               _|_      "
    scene5Scrline2:  string "              PARABENS!!!       |       "
    scene5Scrline3:  string "                                        "
    scene5Scrline4:  string "         VOCE ENCONTROU A MOEDA         "
    scene5Scrline5:  string "                                        "
    scene5Scrline6:  string "          _|_                           "
    scene5Scrline7:  string "           |                            "
    scene5Scrline8:  string "                                        "
    scene5Scrline9:  string "                _______                 "
    scene5Scrline10: string "   _______     |       |     _______    "
    scene5Scrline11: string "  |       |    |       |    |       |   "
    scene5Scrline12: string "  |       |    |   2   |    |   3   |   "
    scene5Scrline13: string "  |   1   |    |       |    |       |   "
    scene5Scrline14: string "  |       |    |       |    |       |   "
    scene5Scrline15: string "  |       |    /_______\\    |       |  "
    scene5Scrline16: string "   /_______\\                 /_______\\"
    scene5Scrline17: string "                                        "
    scene5Scrline18: string "                      @                 "
    scene5Scrline19: string "                                        "
    scene5Scrline20: string "                                        "
    scene5Scrline21: string "                                        "
    scene5Scrline22: string "                                        "
    scene5Scrline23: string "        A MOEDA ESTAVA NO COPO 2        "
    scene5Scrline24: string "                                        "
    scene5Scrline25: string "                                        "
    scene5Scrline26: string "                                        "
    scene5Scrline27: string "                                        "
    scene5Scrline28: string "                                        "
    scene5Scrline29: string "                                        "
    
    ; GAME SCENE 6 ---------------------------------------------------
    scene6Scrline0:  string "                                        "
    scene6Scrline1:  string "                               _|_      "
    scene6Scrline2:  string "              PARABENS!!!       |       "
    scene6Scrline3:  string "                                        "
    scene6Scrline4:  string "         VOCE ENCONTROU A MOEDA         "
    scene6Scrline5:  string "                                        "
    scene6Scrline6:  string "          _|_                           "
    scene6Scrline7:  string "           |                            "
    scene6Scrline8:  string "                                        "
    scene6Scrline9:  string "                             _______    "
    scene6Scrline10: string "   _______      _______     |       |   "
    scene6Scrline11: string "  |       |    |       |    |       |   "
    scene6Scrline12: string "  |       |    |       |    |   3   |   "
    scene6Scrline13: string "  |   1   |    |   2   |    |       |   "
    scene6Scrline14: string "  |       |    |       |    |       |   "
    scene6Scrline15: string "  |       |    |       |    /_______\\  "
    scene6Scrline16: string "   /_______\\    /________\\            "
    scene6Scrline17: string "                                        "
    scene6Scrline18: string "                                   @    "
    scene6Scrline19: string "                                        "
    scene6Scrline20: string "                                        "
    scene6Scrline21: string "                                        "
    scene6Scrline22: string "                                        "
    scene6Scrline23: string "        A MOEDA ESTAVA NO COPO 3        "
    scene6Scrline24: string "                                        "
    scene6Scrline25: string "                                        "
    scene6Scrline26: string "                                        "
    scene6Scrline27: string "                                        "
    scene6Scrline28: string "                                        "
    scene6Scrline29: string "                                        "
    
;================================================================== 
; STD FUNCTIONS ===================================================

	; GET CHAR ----------------------------------------
	get_char:   
	  ; routine to get input from keyboard
	  push r0
	  push r1     

	  loadn r1, #255        ; ' ' blank space
	  
	  get_char_loop:          
	    inchar r0           ; input from keyboard
	    cmp r0, r1          ; compares input to ' ' (nothing typed)
	    jeq get_char_loop   ; if so, starts the loop again

	    store char, r0       ; stores the input

	  pop r1
	  pop r0
	  rts

    ; PRINT STRING ------------------------------------
	print_string:             
        push r0     ; position
        push r1     ; message
        push r2     ; for subroutine use
        push r3     ; color
        push r4     ; stopping criterion

        loadn r4, #'\0'

        print_loop:    
            loadi r2, r1        ; loads the 1st character of the message into r2
            cmp r2, r4          ; compares character from message to stopping criterion
            jeq print_end       ; is so: exit
            add r2, r2, r3      ; if not: adds color to character
            outchar r2, r0      ; prints character
            inc r0              ; increments the position
            inc r1              ; increments the character
            jmp print_loop      ; jumps to print_loop, beginning of subroutine
            
        print_end: 
            pop r4
            pop r3
            pop r2      
            pop r1      
            pop r0      
            rts

    ; PRINT SCREEN 2 ----------------------------------
    print_screen2:
        ; this routine prints scenes on screen

        push r0   ; for subroutine use
        push r1   ; keeps the address of first char from first line of the scene
        push r2   ; keeps the color
        push r3   ; for subroutine use
        push r4   ; for subroutine use
        push r5   ; for subroutine use
        push r6   ; for subroutine use

        loadn r0, #0              ; first position of the screen
        loadn r3, #40             ; increments the position
        loadn r4, #41             ; increments the pointer for lines on screen
        loadn r5, #1200           ; end of the screen
        loadn r6, #scene0Scrline0  ; address of first char from first line of the scene

        print_screen2_loop:
            call print_string2      ; prints char by char from the line
            add r0, r0, r3          ; increments position to second line on screen =>  r0 = r0 + 40
            add r1, r1, r4          ; increments the pointer to the beginning of next line in memory (40 + 1 because of /0 !!) => r1 = r1 + 41
            add r6, r6, r4          ; increments the pointer to the beginning of next line in memory (40 + 1 because of /0 !!) => r1 = r1 + 41
            cmp r0, r5              ; compares r0 to 1200
            jne print_screen2_loop  ; while r0 < 1200

        pop r6  ; get register values used in subroutine of the stack
        pop r5
        pop r4
        pop r3
        pop r2
        pop r1
        pop r0
        rts
        
        
    ; PRINT STRING 2 ----------------------------------
    print_string2:
        ; routine for message/string print

        push r0   ; screen position where the 1st char will be printed
        push r1   ; keeps the address of message beginning
        push r2   ; keeps message color
        push r3   ; for subroutine use
        push r4   ; for subroutine use
        push r5   ; for subroutine use
        push r6   ; for subroutine use


        loadn r3, #'\0' ; stopping criterion / end of the message
        loadn r5, #' '  ; blank space

        print_string2_loop:  
            loadi r4, r1              ; loads value from r1 to r4
            cmp r4, r3                ; compares the value (char of message) to \0
            jeq exit_print_string2    ; if char is \0: the end of the message came, then get out of loop

        cmp r4, r5                ; if char is ' ' (blank space) jumps to skip_print_2_loop (then another char won't disappear)
        jeq skip_print_string2

        add r4, r2, r4    ; sums the color to char
        outchar r4, r0    ; prints the char on screen
        storei r6, r4     ; stores the char into r6

        skip_print_string2:
            inc r0                    ; increments screen position
            inc r1                    ; increments string pointer
            inc r6                    ; increments string pointer from blank screen (first one)
            jmp print_string2_loop

        exit_print_string2: 
        pop r6
        pop r5
        pop r4
        pop r3
        pop r2
        pop r1
        pop r0
        rts
        
        
    ; CLEAR SCREEN ------------------------------------
	clear_screen:
	; clear the screen from the last position (1200) to the first one(0)
	  push r0
	  push r1

	  loadn r0, #1200     ; final position
	  loadn r1, #' '      ; 'empty' space to print

	  clear_screen_loop:
	    dec r0
	    outchar r1, r0          ; prints in 1st position
	    jnz clear_screen_loop   ; if != 0, go to loop 


	  pop r1
	  pop r0
	  rts
  
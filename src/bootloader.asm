[org 0x7c00]        ; Load the OS in the 0x7C00 address (boot sector)

start:
    mov bx, welcome ; Copy the string to the BX register
    call puts       ; Call the function to print the string

    call getch      ; Call the function to get a character
    call putc       ; Print the character read

    jmp $           ; Infinite loop to keep the system running

; Function to read a single character from the keyboard
; Output:
;   - al: The character read from the keyboard
getch:
    mov ah, 0       ; Function 0 of int 0x16: Read a character from the keyboard
    int 0x16        ; Call BIOS interrupt
    ret             ; Return with the character in AL

; Prints a single character
; Parameters:
;   - al: The character to print
putc:
    mov ah, 0x0E    ; Function to print a character
    int 0x10        ; Call BIOS interrupt
    ret             ; Return from the function

; Prints a string by iterating over it
; Parameters:
;   - bx: The string to print
puts:
    mov al, [bx]    ; Load the current character
    cmp al, 0       ; Check if it's the null terminator
    je end          ; If yes, end the function
    call putc       ; Print the character
    inc bx          ; Move to the next character
    jmp puts        ; Repeat

end:
    ret             ; Return from the function

; Constant pool
welcome: db "Welcome to Dsacle 5.11!", 0

; ======== BOOT LOADER ======== ;

times 510 - ($ - $$) db 0   ; Fill with zeros until the bootloader reaches 510 bytes
dw 0xAA55                   ; Add the magic number (2 bytes) to reach the 512 bytes

.model small
.stack 100h 
.data 
    welcome_text    db  'Meow Teller Machine', 0
    enter_card    db  'Please insert your Neko Chartered card', 0
    colors  db  01h, 02h, 03h, 04h, 05h, 06h, 07h, 09h, 0Ah, 0Bh, 0Ch, 0Dh, 0Eh, 0Fh, 01h, 02h, 03h, 04h, 05h, 06h, 07h, 0Ah, 0Bh, 0Ch, 0Dh, 0Eh, 0Fh, 01h, 02h, 03h, 04h, 05h, 06h, 07h, 0Ah, 0Bh, 0Ch, 0Dh, 0Eh, 0Fh, 01h, 02h, 03h, 04h, 05h, 06h, 07h                                                  
    
    ; System Messages
    prompt db 10,13,'Enter your PIN: $'  
    invalid_pin db 10,13,'Claws denied! Session terminated.$' 
    pin db '4205$' 
    check_pin dw 4
    current_date db '1970-01-01$'
    current_time db '12:00:00 AM$'
    
    ; Date and Time Display
    date_msg db 10,13,'Date: $'
    time_msg db 10,13,'Time: $'
    
    ; Menu Items
    greet_msg db 10,13,'Welcome to your Neko Chartered account$'
    balance_inquiry db 10,13,10,13,'1. Check Balance $' 
    withdrawal_request db 10,13,'2. Withdraw Funds $'  
    deposit_option db 10,13,'3. Deposit Funds$'
    transfer_request db 10,13,'4. Transfer Funds $' 
    exit db 10,13,'5. Exit $'
    go_back db 10,13,'1. Back$' 
    exit2 db 10,13,'2. Exit$'
    
    ; System Messages
    exit_msg db 10,13,10,13,'Thank you for purring with us.$'
    invalid_input db 10,13,'Invalid Input! Session Terminated.$'
    newline db 10,13,'$'
    
    ; Balance Information
    total_balance db 10,13,'Total Balance: 25,000 Shimmers $' 
    available_balance db 10,13,'Available Balance: 25,000 Shimmers $'  
    
    ; Withdrawal Options
    five_hundred db 10,13,'1. 500 Shimmers$' 
    one_k db 10,13,'2. 1,000 Shimmers$'
    three_k db 10,13,'3. 3,000 Shimmers$'
    five_k db 10,13,'4. 5,000 Shimmers$'
    ten_k db 10,13,'5. 10,000 Shimmers$'
    fifteen_k db 10,13,'6. 15,000 Shimmers$'
    twenty_k db 10,13,'7. 20,000 Shimmers$'
    
    ; Balance Messages
    current_balance db 10,13,'Current Balance: $' 
    remaining_balance db 10,13,'Remaining Balance: $' 
    
    ; Transaction Messages
    withdraw_prompt db 10,13,'Enter Withdraw Amount: $' 
    transaction_prompt db 10,13,'Enter Transaction Amount: $'  
    transaction_successful db 10,13,'Transaction Successful! $' 
    acc_prompt db 10,13,'Enter Account Number (10 digits): $'
    
    ; deposit messages 
    deposit_prompt db 10,13,'Enter deposit amount (Max: 40000 Shimmers): $'
    deposit_success   db 'Deposit Successful! $'
    invalid_deposit_amount   db 'Invalid Deposit Amount! $'
    deposit_limit_amount     db 'Amount Exceeds Maximum Limit! $'
    temp_amount dw 0
    MAX_DEPOSIT equ 40000 
    
    ; User and Time Display
    user_login db 10,13,'Cardholder: Xayna$'
    current_datetime db '1970-01-01 12:00:00 AM$'
    header_line db 10,13,'____________________________________$'
    
    ; Dynamic Balance Variables
    current_balance_value dw 25000    ; Store balance as integer (25,000)
    input_buffer db 6 dup('$')        ; Buffer for user input
    temp_balance dw ?                 ; Temporary storage for calculations
    balance_string db 10 dup('$')     ; Buffer for converting number to string
    input_prompt db 10,13,'Enter amount (max 25000): $'
    insufficient_funds db 10,13,'Insufficient funds! Available balance: $'
    balance_suffix db ' Shimmers$'    ; Currency suffix for dynamic balances
    
    ; Number conversion helpers
    ten dw 10
    hundred dw 100 
 .code   
clear_screen proc
    push ax         ; Save registers
    push bx
    push cx
    push dx
    
    mov ax,0600h    ; Scroll up function
    mov bh,07h      ; Normal attribute (white on black)
    mov cx,0000h    ; Upper left corner (0,0)
    mov dx,184Fh    ; Lower right corner (24,79)
    int 10h
    
    ; Reset cursor to top
    mov ah,02h
    mov bh,00h
    mov dx,0000h
    int 10h
    
    pop dx          ; Restore registers
    pop cx
    pop bx
    pop ax
    ret            ; Add ret instruction
clear_screen endp
 
 
 main proc  
    mov ax,@data
    mov ds,ax 
    ; Display date and time
    mov ah,9
    lea dx,date_msg
    int 21h
    lea dx,current_date
    int 21h
    
    mov ah,9
    lea dx,time_msg
    int 21h
    lea dx,current_time
    int 21h

    ; print 'Meow Teller Machine'  (19 chars -> centered start col 30)
    mov     dl, 30  ; column (center)
    mov     dh, 12  ; row
    mov     si, 0   ; character counter

welcome:
    mov     ah, 02h  ; set cursor position
    int     10h
    
    mov     al, [welcome_text + si]  ; get character
    cmp     al, 0           ; check for end of string
    je      next_line
    
    mov     bl, [colors + si]  ; get color (only foreground)
    mov     bh, 0     ; page number
    mov     cx, 1     ; number of times to print
    mov     ah, 09h   ; write character and attribute
    int     10h
    
    inc     si
    inc     dl
    jmp     welcome

next_line:
    ; print 'Please insert your Neko Chartered card'  (38 chars -> centered start col 21)
    mov     dl, 21  ; column (center)
    mov     dh, 13  ; row
    mov     si, 0   ; reset counter

card_msg:
    mov     ah, 02h  ; set cursor position
    int     10h
    
    mov     al, [enter_card + si]  ; get character
    cmp     al, 0           ; check for end of string
    je      pin_input
    mov     bl, [colors + si]  ; get color (only foreground)
    mov     bh, 0     ; page number
    mov     cx, 1     ; number of times to print
    mov     ah, 09h   ; write character and attribute
    int     10h
    
    inc     si
    inc     dl
    jmp     card_msg

pin_input:
    mov     ah, 0    ; wait for keypress
    int     16h
    
    call clear_screen
  
    mov cx, check_pin    ; Set counter to PIN length
    mov bx, offset pin   
    
    lea dx, prompt   
    mov ah,9
    int 21h
    
pass_validation:
    mov ah,8          ; Read character without echo
    int 21h
    
    cmp al,[bx]       ; Compare with stored PIN
    jne wrong_pin     ; If not equal, jump to wrong
    
    mov ah,2          ; Display asterisk
    mov dl,'*'        ; Show asterisk for each character
    int 21h
    
    inc bx            ; Move to next character
    loop pass_validation

    call clear_screen
    jmp main_menu
    
wrong_pin:
    call clear_screen
         
    mov ah,9
    lea dx, invalid_pin
    int 21h
    
    mov ah,9
    lea dx, newline
    int 21h
    
    ; Wait for 2 seconds
    mov cx, 0Fh
    mov dx, 4240h
    mov ah, 86h
    int 15h
    
    mov ah,4ch
    int 21h
    
main_menu:
    call clear_screen
    call display_header
    mov ah,9
    lea dx,greet_msg
    int 21h 

    mov ah,9
    lea dx,balance_inquiry    ; 1. Check Balance
    int 21h

    mov ah,9
    lea dx,withdrawal_request  ; 2. Withdraw Funds
    int 21h

    mov ah,9
    lea dx,deposit_option     ; 3. Deposit Funds
    int 21h

    mov ah,9
    lea dx,transfer_request   ; 4. Transfer Funds
    int 21h
    
    mov ah,9
    lea dx,exit              ; 5. Exit
    int 21h

    mov ah,9
    lea dx,newline
    int 21h

    mov ah,1
    int 21h
    mov bl,al
    
    cmp bl,49 
    je balance      ; Option 1 - Balance
    cmp bl,50 
    je withdraw     ; Option 2 - Withdraw
    cmp bl,51 
    je deposit      ; Option 3 - Deposit 
    cmp bl,52 
    je transfer     ; Option 4 - Transfer 
    cmp bl,53       ; New comparison for Exit
    je end_program
    jmp error  
    
balance:
    call clear_screen
    call display_header    ; This ensures consistent header
    
    mov ah,9
    lea dx,header_line
    int 21h
    
    ; Display Current Balance
    mov ah,9
    lea dx,current_balance
    int 21h
    call format_balance
    
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,header_line
    int 21h
    
    ; Display Available Balance
    mov ah,9
    lea dx,remaining_balance
    int 21h
    call format_balance
    
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,header_line
    int 21h
    
    jmp option
                            
withdraw:
    call clear_screen
    call display_header
    
    ; Display current balance first
    mov ah,9
    lea dx,current_balance
    int 21h
    call format_balance
    
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,header_line
    int 21h
    
    ; Show input prompt
    mov ah,9
    lea dx,input_prompt
    int 21h             ; Reset buffer index

     ; Get amount from user
    mov si,0               ; Reset buffer index

get_amount:
    mov ah,1              ; Read character with echo
    int 21h
    
    cmp al,13             ; Check for Enter key
    je process_amount
    
    cmp al,'0'            ; Check if it's a number
    jb invalid_char
    cmp al,'9'
    ja invalid_char
    
    mov input_buffer[si],al    ; Store digit
    inc si
    cmp si,5              ; Max 5 digits (25000)
    jb get_amount
    
process_amount:
    mov input_buffer[si],'$'   ; Terminate string
    
    ; Convert string to number
    mov ax,0              ; Initialize result
    mov si,0              ; Reset index
    
convert_loop:
    mov bl,input_buffer[si]    ; Get digit
    cmp bl,'$'                 ; Check for end
    je check_amount
    
    sub bl,'0'            ; Convert ASCII to number
    mov bh,0
    
    push bx              ; Save digit
    
    mul ten              ; AX = AX * 10
    
    pop bx
    add ax,bx            ; Add digit
    
    inc si
    jmp convert_loop
    
check_amount:
    ; Check if amount <= current balance
    cmp ax, current_balance_value
    ja insufficient
    
    ; Subtract amount from balance
    mov bx, current_balance_value
    sub bx, ax
    mov current_balance_value, bx
    
    ; Display success message
    call clear_screen
    call display_header
    
    mov ah, 9
    lea dx, transaction_successful
    int 21h
    
    mov ah, 9
    lea dx, newline
    int 21h
    
    ; Display remaining balance
    mov ah, 9
    lea dx, remaining_balance
    int 21h
    
    call format_balance    ; Format and display the balance
    
    mov ah, 9
    lea dx, newline
    int 21h
    mov ah, 9
    lea dx, header_line
    int 21h
    
    jmp option
    
insufficient:
    call clear_screen
    mov ah,9
    lea dx,insufficient_funds
    int 21h
    call format_balance
    
    ; Wait for key press
    mov ah,1
    int 21h
    jmp withdraw
    
invalid_char:
    call clear_screen
    mov ah,9
    lea dx,invalid_input
    int 21h
    jmp withdraw

deposit:
    call clear_screen
    call display_header
    
    ; Display current balance
    mov ah,9
    lea dx,current_balance
    int 21h
    call format_balance
    
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,deposit_prompt
    int 21h

get_deposit_amount:
    mov si,0               ; Clear counter
    mov word ptr temp_amount,0
    
input_deposit_loop:
    mov ah,1              ; Get character
    int 21h
    
    cmp al,13             ; Check for Enter
    je process_deposit
    
    cmp al,'0'            ; Validate numeric
    jb invalid_deposit
    cmp al,'9'
    ja invalid_deposit
    
    sub al,'0'            ; Convert to number
    mov ah,0              ; Clear high byte
    push ax               ; Save digit
    
    ; Multiply current amount by 10
    mov ax,temp_amount
    mul ten               ; DX:AX = AX * 10
    
    ; Check for overflow
    cmp dx,0
    jne deposit_limit
    
    mov temp_amount,ax
    pop ax               ; Get digit back
    add temp_amount,ax   ; Add to total
    
    ; Check if exceeds maximum
    mov ax,temp_amount
    cmp ax,MAX_DEPOSIT
    ja deposit_limit
    
    inc si               ; Increment counter
    cmp si,5            ; Check max digits
    jae process_deposit  ; If 5 digits, process amount
    
    jmp input_deposit_loop

process_deposit:
    mov ax,temp_amount
    
    ; Check if amount is zero
    cmp ax,0
    je invalid_deposit
    
    ; Add to balance (overflow guard: reject if sum would pass 65,535)
    add ax,current_balance_value
    jc deposit_limit                 ; carry set = wrapped past 65,535, bail out
    mov current_balance_value,ax     ; safe -> commit new balance
    
    ; Show success message
    call clear_screen
    call display_header
    
    mov ah,9
    lea dx,deposit_success
    int 21h
    
    ; Display new balance
    mov ah,9
    lea dx,current_balance
    int 21h
    call format_balance
    
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,header_line
    int 21h
    
    jmp option

deposit_limit:
    call clear_screen
    mov ah,9
    lea dx,deposit_limit_amount    
    int 21h
    
    ; Wait 2 seconds
    mov cx,0Fh
    mov dx,4240h
    mov ah,86h
    int 15h
    
    jmp deposit

invalid_deposit:
    call clear_screen
    mov ah,9
    lea dx,invalid_deposit_amount
    int 21h
    
    ; Wait 2 seconds
    mov cx,0Fh
    mov dx,4240h
    mov ah,86h
    int 15h
    
    jmp deposit

; Helper procedure to display balance
format_balance proc
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov ax, current_balance_value
    mov si, 0
    mov bx, 10
    
format_digits:
    mov dx, 0
    div bx              ; Divide by 10
    add dl, '0'         ; Convert to ASCII
    push dx             ; Save digit
    inc si
    test ax, ax         ; Check if more digits
    jnz format_digits
    
print_formatted:
    pop dx              ; Get digit
    mov ah, 2
    int 21h
    dec si
    
    ; Add comma after thousands
    cmp si, 3
    jne check_end
    
    push dx
    mov dl, ','
    mov ah, 2
    int 21h
    pop dx
    
check_end:
    cmp si, 0
    jne print_formatted
    
    ; Add Shimmers suffix
    lea dx, balance_suffix
    mov ah, 09h
    int 21h
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
format_balance endp

display_header proc
    push ax
    push dx
    
    call clear_screen
    
    mov ah,9
    lea dx,header_line
    int 21h
    
    mov ah,9
    lea dx,date_msg
    int 21h
    lea dx,current_datetime
    int 21h
    
    mov ah,9
    lea dx,user_login
    int 21h
    
    mov ah,9
    lea dx,header_line
    int 21h
    
    mov ah,9
    lea dx,newline    ; Add extra newline for spacing
    int 21h
    
    pop dx
    pop ax
    ret
display_header endp

; Transfer processing section
transfer:
    call clear_screen
    call display_header
    
    ; Display current balance first
    mov ah,9
    lea dx,current_balance
    int 21h
    call format_balance
    
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,header_line
    int 21h
    
    mov ah,9
    lea dx,acc_prompt
    int 21h

     ; Get account number
    mov ah,1
    xor si,si       ; Clear SI for counting digits

get_account:
    int 21h
    cmp al,13       ; Check for Enter key
    je verify_acc   ; If Enter, verify account
    
    cmp al,'0'      ; Validate numeric input
    jb invalid_acc
    cmp al,'9'
    ja invalid_acc
    
    inc si          ; Count digits
    cmp si,10       ; Max 10 digits for account number
    je verify_acc
    
    jmp get_account
    
verify_acc:
    cmp si,0        ; Check if any digits were entered
    je invalid_acc
    
    mov ah,9
    lea dx,newline
    int 21h
    
    ; Verify PIN again for security
    mov ah,9
    lea dx,prompt
    int 21h
    
    mov cx,check_pin
    mov bx,offset pin
    
verify_pin:
    mov ah,8        ; Get character without echo
    int 21h
    
    cmp al,[bx]
    jne wrong_pin
    
    mov ah,2
    mov dl,'*'
    int 21h
    
    inc bx
    loop verify_pin
    
    ; PIN correct, proceed to amount entry
    call clear_screen
    jmp transfer_amount
    
invalid_acc:
    call clear_screen
    mov ah,9
    lea dx,invalid_input
    int 21h
    
    ; Wait 2 seconds
    mov cx,0Fh
    mov dx,4240h
    mov ah,86h
    int 15h
    
    jmp transfer
    
transfer_amount:
    mov ah,9
    lea dx,transaction_prompt
    int 21h
    
    ; Get transfer amount
    xor si,si           ; Clear SI for amount input
    mov word ptr temp_balance,0  ; Clear temporary storage
    
get_transfer_amount:
    mov ah,1
    int 21h
    
    cmp al,13           ; Check for Enter
    je process_transfer
    
    cmp al,'0'          ; Validate numeric input
    jb invalid_amount
    cmp al,'9'
    ja invalid_amount
    
    sub al,'0'          ; Convert ASCII to number
    mov ah,0
    push ax             ; Save digit
    
    ; Multiply current amount by 10
    mov ax,word ptr temp_balance
    mul ten
    mov word ptr temp_balance,ax
    
    pop ax              ; Retrieve digit
    add word ptr temp_balance,ax  ; Add new digit
    
    inc si
    cmp si,5           ; Max 5 digits (25000)
    jne get_transfer_amount
    
process_transfer:
    mov ax,word ptr temp_balance
    
    ; Check if amount <= current balance
    cmp ax,current_balance_value
    ja insufficient_transfer
    
    ; Subtract from current balance
    sub current_balance_value,ax
    
    ; Show success message
    call clear_screen
    call display_header
    
    mov ah,9
    lea dx,transaction_successful
    int 21h
    
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,header_line
    int 21h
    
    ; Display remaining balance
    mov ah,9
    lea dx,remaining_balance
    int 21h
    call format_balance
    
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,header_line
    int 21h
    
    jmp option
    
insufficient_transfer:
    call clear_screen
    call display_header
    
    mov ah,9
    lea dx,insufficient_funds
    int 21h
    
    mov ah,9
    lea dx,current_balance
    int 21h
    call format_balance
    
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,header_line
    int 21h
    
    ; Wait for key
    mov ah,1
    int 21h
    jmp transfer_amount
    
invalid_amount:
    call clear_screen
    mov ah,9
    lea dx,invalid_input
    int 21h
    jmp transfer_amount

; Option processing section
option:
    mov ah,9
    lea dx,newline
    int 21h
    lea dx,go_back
    int 21h
    lea dx,exit2
    int 21h
    lea dx,newline
    int 21h
    
    mov ah,1
    int 21h
    
    cmp al,'1'
    je back_to_menu
    cmp al,'2'
    je end_program
    jmp error

back_to_menu:
    call clear_screen
    jmp main_menu

error:
    call clear_screen
    mov ah,9
    lea dx,invalid_input
    int 21h
    
    ; Wait 2 seconds
    mov cx,0Fh
    mov dx,4240h
    mov ah,86h
    int 15h
    
    jmp main_menu

end_program:
    call clear_screen
    mov ah,9
    lea dx,exit_msg
    int 21h
    
    ; Wait 3 seconds
    mov cx,1Ch
    mov dx,6000h
    mov ah,86h
    int 15h
    
    mov ah,4ch
    int 21h

end main

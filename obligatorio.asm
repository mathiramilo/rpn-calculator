.data  ; Data segment
; Default ports
PORT_LOG_DEFAULT equ 100
PORT_OUTPUT_DEFAULT equ 200
; Ports
PORT_LOG dw PORT_LOG_DEFAULT
PORT_OUTPUT dw PORT_OUTPUT_DEFAULT
PORT_INPUT dw 300

; Reserve memory for stack and initialize the base
; and offset of the software implemented stack
STACK dw dup(31) 0
#define SI 0
; Initializate CX register with 0
; Will serve as a counter for the number of elements in the stack
#define CX 0

.code  ; Code segment

main:
  ; Send 0 to the log port, receive a command
  ; and send the command to the log port
  mov AX, 0
  mov DX, [PORT_LOG]
  out DX, AX
  mov DX, [PORT_INPUT]
  in AX, DX
  mov DX, [PORT_LOG]
  out DX, AX
  ; Switch
  cmp AX, 1
  je pushNumber
  cmp AX, 2
  je setOutputPort
  cmp AX, 3
  je setLogPort
  cmp AX, 4
  je top
  cmp AX, 5
  je dump
  cmp AX, 6
  je duplicate
  cmp AX, 7
  je swap
  cmp AX, 8
  je negative
  cmp AX, 9
  je callFact
  cmp AX, 10
  je sum
  cmp AX, 11
  je addition
  cmp AX, 12
  je substraction
  cmp AX, 13
  je multiplication
  cmp AX, 14
  je division
  cmp AX, 15
  je mod
  cmp AX, 16
  je bAnd
  cmp AX, 17
  je bOr
  cmp AX, 18
  je shiftLeft
  cmp AX, 19
  je shiftRight
  cmp AX, 254
  je clear
  cmp AX, 255
  je halt
  ; Default (Invalid Command)
  ; Send code 2 and jump to main
  mov AX, 2
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main

pushNumber:
  mov DX, [PORT_INPUT]
  in AX, DX
  mov DX, [PORT_LOG]
  out DX, AX
  ; If the stack isn't full, push the number,
  ; increase CX, send code 16 and jump to main
  cmp CX, 31
  jge pnElse
  add SI, 2
  mov [STACK + SI], AX
  inc CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If the stack is full, send code 4 and jump to main
  pnElse:
    mov AX, 4
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

setOutputPort:
  ; Recive the param, send it to the log port
  ; set the output port and send code 16
  mov DX, [PORT_INPUT]
  in AX, DX
  mov DX, [PORT_LOG]
  out DX, AX
  mov [PORT_OUTPUT], AX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main

setLogPort:
  ; Recive the param, send it to the log port
  ; set the log port and send code 16
  mov DX, [PORT_INPUT]
  in AX, DX
  mov DX, [PORT_LOG]
  out DX, AX
  mov [PORT_LOG], AX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main

top:
  ; If the stack isn't empty, send the top element to the output port,
  ; send code 16 and jump to main
  cmp CX, 0
  jle topElse
  mov AX, [STACK + SI]
  mov DX, [PORT_OUTPUT]
  out DX, AX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If the stack is empty, send code 8 and jump to main
  topElse:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

dump:
  ; If the stack isn't empty, send all elements to the output port,
  ; send code 16 and jump to main
  cmp CX, 0
  jle dumpElse
  mov DI, SI
  dumpFor:
    cmp DI, 0
    jle endDumpFor
    mov AX, [STACK + DI]
    mov DX, [PORT_OUTPUT]
    out DX, AX
    sub DI, 2
    jmp dumpFor
  endDumpFor:
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If the stack is empty, send code 8 and jump to main
  dumpElse:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

duplicate:
  ; If the stack isn't full, duplicate the top of the stack,
  ; increase CX, send code 16 and jump to main
  cmp CX, 31
  jge dupFullStack
  cmp CX, 0
  jge dupEmptyStack
  mov DX, [STACK + SI]
  add SI, 2
  mov [STACK + SI], DX
  inc CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If the stack is full, send code 4 and jump to main
  dupFullStack:
    mov AX, 4
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If the stack is empty, send code 8 and jump to main
  dupEmptyStack:
	mov AX, 8
	mov DX, [PORT_LOG]
	out DX, AX
	jmp main

swap:
  ; If the stack has at least 2 elements, swap the top two elements,
  ; send code 16 and jump to main
  cmp CX, 2
  jl swapElse1
  mov AX, [STACK + SI]
  sub SI, 2
  mov DX, [STACK + SI]
  add SI, 2
  mov [STACK + SI], DX
  sub SI, 2
  mov [STACK + SI], AX
  add SI, 2
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  swapElse1:
    cmp CX, 1
    jne swapElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  swapElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

negative:
  ; If the stack isn't empty, negate the top element,
  ; send code 16 and jump to main
  cmp CX, 0
  jle negElse
  mov DX, [STACK + SI]
  neg DX
  mov [STACK + SI], DX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If the stack is empty, send code 8 and jump to main
  negElse:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

callFact:
  ; If the stack isn't empty, calculate the fact of the top element,
  ; send code 16 and jump to main
  cmp CX, 0
  jle callFactElse
  mov AX, [STACK + SI]
  call fact
  mov [STACK + SI], BX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If the stack is empty, send code 8 and jump to main
  callFactElse:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

fact proc
  ; Factorial using AX as input
  ; Returns the result on BX
  cmp AX, 0
  je isZero
  dec AX
  call fact
  inc AX
  mov DI, AX
  mul BX
  mov BX, AX
  mov AX, DI
  jmp endFact
  isZero:
  mov BX, 1
  endFact:
  ret
fact endp  

sum:
  ; Sum all elements of the stack and leave the result in the stack,
  ; send code 16 and jump to main
  mov AX, 0
  mov DI, SI
  sumFor:
    cmp DI, 0
    jle endSumFor
    add AX, [STACK + DI]
    sub DI, 2
    jmp sumFor
  endSumFor:
  mov SI, 2
  mov [STACK + SI], AX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main

addition:
  ; If the stack has more than 2 elements add the top two elements of the stack,
  ; write the result in the stack, decrease CX, send code 16 and jump to main
  cmp CX, 2
  jl addElse1
  mov DX, [STACK + SI]
  sub SI, 2
  mov AX, [STACK + SI]
  add AX, DX
  add SI, 2
  mov word ptr [STACK + SI], 0
  sub SI, 2
  mov [STACK + SI], AX
  dec CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  addElse1:
    cmp CX, 1
    jne addElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  addElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

substraction:
  ; If the stack has more than 2 elements subtract the top two elements of the stack,
  ; write the result in the stack, decrease CX, send code 16 and jump to main
  cmp CX, 2
  jl subElse1
  mov DX, [STACK + SI]
  sub SI, 2
  mov AX, [STACK + SI]
  sub AX, DX
  add SI, 2
  mov word ptr [STACK + SI], 0
  sub SI, 2
  mov [STACK + SI], AX
  dec CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  subElse1:
    cmp CX, 1
    jne subElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  subElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

multiplication:
  ; If the stack has more than 2 elements multiply the top two elements of the stack,
  ; write the result in the stack, decrease CX, send code 16 and jump to main
  cmp CX, 2
  jl mulElse1
  mov DX, [STACK + SI]
  sub SI, 2
  mov AX, [STACK + SI]
  imul DX
  add SI, 2
  mov word ptr [STACK + SI], 0
  sub SI, 2
  mov [STACK + SI], AX
  dec CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  mulElse1:
    cmp CX, 1
    jne mulElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  mulElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

division:
  ; If the stack has more than 2 elements divide the top two elements of the stack,
  ; write the result in the stack, decrease CX, send code 16 and jump to main
  cmp CX, 2
  jl divElse1
  mov BX, [STACK + SI]
  sub SI, 2
  mov AX, [STACK +SI]
  cmp AX, 0
  jl negDividendDiv
  mov DX, 0
  jmp makeDiv
  negDividendDiv:
  mov DX, 0xFFFF
  makeDiv:
  idiv BX
  add SI, 2
  mov word ptr [STACK +SI], 0
  sub SI, 2
  mov [STACK +SI], AX
  dec CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  divElse1:
    cmp CX, 1
    jne divElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  divElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

mod:
  ; If the stack has more than 2 elements calculate the mod of the top two elements of the stack,
  ; write the result in the stack, decrease CX, send code 16 and jump to main
  cmp CX, 2
  jl modElse1
  mov BX, [STACK + SI]
  sub SI, 2
  mov AX, [STACK + SI]
  cmp AX, 0
  jl negDividendMod
  mov DX, 0
  jmp makeMod
  negDividendMod:
  mov DX, 0xFFFF
  makeMod:
  idiv BX
  add SI, 2
  mov word ptr [STACK + SI], 0
  sub SI, 2
  mov [STACK + SI], DX
  dec CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  modElse1:
    cmp CX, 1
    jne modElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  modElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

bAnd:
  ; If the stack has more than 2 elements calculate the bitwise and of the top two elements of the stack,
  ; write the result in the stack, decrease CX, send code 16 and jump to main
  cmp CX, 2
  jl bAndElse1
  mov DX, [STACK + SI]
  sub SI, 2
  mov AX, [STACK + SI]
  and AX, DX
  add SI, 2
  mov word ptr [STACK + SI], 0
  sub SI, 2
  mov [STACK + SI], AX
  dec CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  bAndElse1:
    cmp CX, 1
    jne bAndElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  bAndElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

bOr:
  ; If the stack has more than 2 elements calculate the bitwise or of the top two elements of the stack,
  ; write the result in the stack, decrease CX, send code 16 and jump to main
  cmp CX, 2
  jl bOrElse1
  mov DX, [STACK + SI]
  sub SI, 2
  mov AX, [STACK + SI]
  or AX, DX
  add SI, 2
  mov word ptr [STACK + SI], 0
  sub SI, 2
  mov [STACK + SI], AX
  dec CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  bOrElse1:
    cmp CX, 1
    jne bOrElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  bOrElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

shiftLeft:
  ; If the stack has more than 2 elements shift to the left the second element of the stack
  ; by the number of bits of the first element, write the result in the stack,
  ; decrease CX, send code 16 and jump to main
  cmp CX, 2
  jl shiftLeftElse1
  mov DX, CX
  mov CX, [STACK + SI]
  sub SI, 2
  mov AX, [STACK + SI]
  ; If CH is greater that zero shifting to the left so many spaces will result as a 000...
  cmp CH, 0
  jg bigSal
  sal AX, CL
  jmp salDone
  bigSal:
	mov AX, 0
  salDone:
  add SI, 2
  mov CX, DX
  mov word ptr [STACK + SI], 0
  sub SI, 2
  mov [STACK + SI], AX
  dec CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  shiftLeftElse1:
    cmp CX, 1
    jne shiftLeftElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  shiftLeftElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

shiftRight:
  ; If the stack has more than 2 elements shift to the right the second element of the stack
  ; by the number of bits of the first element, write the result in the stack,
  ; decrease CX, send code 16 and jump to main
  cmp CX, 2
  jl shiftRightElse1
  mov DX, CX
  mov CX, [STACK + SI]
  sub SI, 2
  mov AX, [STACK + SI]
  ; If CH is greater that zero shifting to the left so many spaces will result as a 000...
  cmp CH, 0
  jg bigSar
  sar AX, CL
  jmp sarDone
  bigSar:
	mov AX, 0
  sarDone:
  add SI, 2
  mov CX, DX
  mov word ptr [STACK + SI], 0
  sub SI, 2
  mov [STACK + SI], AX
  dec CX
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main
  ; If there is 1 element in the stack, remove it, send code 8 and jump to main
  shiftRightElse1:
    cmp CX, 1
    jne shiftRightElse2
    mov word ptr [STACK + SI], 0
    sub SI, 2
    dec CX
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main
  ; If there aren't elements in the stack, send code 8 and jump to main
  shiftRightElse2:
    mov AX, 8
    mov DX, [PORT_LOG]
    out DX, AX
    jmp main

clear:
  ; Remove all elements from the stack, send code 16 and jump to main
  clearFor:
  cmp SI, 0
  jle endClearFor
  mov word ptr [STACK + SI], 0
  sub SI, 2
  jmp clearFor
  endClearFor:
  mov CX, 0
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  jmp main

halt:
  ; Send code 16 and halt the program
  mov AX, 16
  mov DX, [PORT_LOG]
  out DX, AX
  loopInf:
  jmp loopInf

.ports
300:

.interrupts ; Interruptions handler
; Interruption example: timer
;!INT 8 1
;  iret
;!ENDINT

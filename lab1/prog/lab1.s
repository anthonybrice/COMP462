    .set    P1IN,   0x40004c00  @ Port 1 Input
    .set    P2IN,   0x40004c01  @ Port 2 Input
    .set    P2OUT,  0x40004c03  @ Port 2 Output
    .set    P1OUT,  0x40004c02  @ Port 1 Output
    .set    P1DIR,  0x40004c04  @ Port 1 Direction
    .set    P2DIR,  0x40004c05  @ Port 2 Direction
    .set    P1REN,  0x40004c06  @ Port 1 Resistor Enable
    .set    P2REN,  0x40004c07  @ Port 2 Resistor Enable
    .set    P1DS,   0x40004c08  @ Port 1 Drive Strength
    .set    P2DS,   0x40004c09  @ Port 2 Drive Strength
    .set    P1SEL0, 0x40004c0a  @ Port 1 Select 0
    .set    P2SEL0, 0x40004c0b  @ Port 2 Select 0
    .set    P1SEL1, 0x40004c0c  @ Port 1 Select 1
    .set    P2SEL1, 0x40004c0d  @ Port 2 Select 1

    .set    RED,    0x01
    .set    GREEN,  0x02
    .set    BLUE,   0x04
    .set    SW1,    0x02        @ on the left side of the LaunchPad board
    .set    SW2,    0x10        @ on the right side of the LaunchPad board

    .thumb
    .syntax unified
    .section .text

_start:
    .global _start
    .global main

    b main

main:
    bl      Port1_Init          @ initialize P1.1 and P1.4 and make them inputs
                                @ (P1.1 and P1.4 built-in buttons)
    bl      Port2_Init          @ initialize P2.2-P2.0 and make them outputs
                                @ (P2.2-P2.0 built-in buttons)
loop:
    bl      Port1_Input         @ read both of the switches on Port 1
    cmp     r0, #0x10           @ r0 == 0x10
    beq     sw1pressed          @ if so, switch 1 is pressed
    cmp     r0, #0x02
    beq     sw2pressed          @ if so, switch 2 is pressed
    cmp     r0, #0x00
    beq     bothpressed         @ if so, both switches pressed
    cmp     r0, #0x12
    beq     nopressed           @ if so, neither switch is pressed
    @@ if none of the above, unexpected return value
    mov     r0, #(RED+GREEN+BLUE) @ r0 = (RED|GREEN|BLUE)
    bl      Port2_Output
    b       loop
sw1pressed:
    mov     r0, #BLUE
    bl      Port2_Output
    b       loop
sw2pressed:
    mov     r0, #RED
    bl      Port2_Output
    b       loop
bothpressed:
    mov     r0, #GREEN
    bl      Port2_Output
    b       loop

nopressed:
    mov     r0, #0
    bl      Port2_Output
    b       loop

@------------Port1_Init------------
@ Initialize GPIO Port 1 for negative logic switches on P1.1 and
@ P1.4 as the LaunchPad is wired.  Weak internal pull-up
@ resistors are enabled.
@ Input: none
@ Output: none
@ Modifies: R0, R1
Port1_Init:
    ldr     R1, =P1SEL0
    mov     R0, #0x00                   @ configure P1.4 and P1.1 as GPIO
    strb    R0, [R1]
    ldr     R1, =P1SEL1
    mov     R0, #0x00                   @ configure P1.4 and P1.1 as GPIO
    strb    R0, [R1]
    ldr     R1, =P1DIR
    mov     R0, #0x00                   @ make P1.4 and P1.1 inputs
    strb    R0, [R1]
    ldr     R1, =P1REN
    mov     R0, #0x12                   @ enable pull resistors on P1.4 and P1.1
    strb    R0, [R1]
    ldr     R1, =P1OUT
    mov     R0, #0x12                   @ P1.4 and P1.1 are pull-up
    strb    R0, [R1]
    bx      LR

@------------Port1_Input------------
@ Read and return the status of the switches.
@ Input: none
@ Output: R0  0x10 if only Switch 1 is pressed
@         R0  0x02 if only Switch 2 is pressed
@         R0  0x00 if both switches are pressed
@         R0  0x12 if no switches are pressed
@ Modifies: R1
Port1_Input:
    ldr     r1, =P1IN
    ldrb    r0, [r1]            @ read all 8 bits of Port 1
    and     r0, r0, #0x12       @ select input pins P1.1 and P1.4
    bx      lr

@------------Port2_Init------------
@ Initialize GPIO Port 2 red, green, and blue LEDs as
@ the LaunchPad is wired.
@ Input: none
@ Output: none
@ Modifies: R0, R1
Port2_Init:
    ldr     r1, =P2SEL0
    mov     r0, #0x00           @ configure P2.2-P2.0 as GPIO
    strb    r0, [r1]
    ldr     r0, =P2SEL1
    mov     r0, #0x00           @ configure P2.2-P2.0 as GPIO
    strb    r0, [r1]
    ldr     r1, =P2DS
    mov     r0, #0x07           @ make P2.2-P2.0 high drive strength
    strb    r0, [r1]
    ldr     r1, =P2OUT
    mov     r0, #0x00           @ all LEDs off
    strb    r0, [r1]
    bx      lr

@------------Port2_Output------------
@ Set the output state of P2.
@ Input: R0 new state of P2 (only 8 least significant bits)
@ Output: none
@ Modifies: R1
Port2_Output:
    ldr     r1, =P2OUT
    strb    r0, [r1]            @ write to P2.7-P2.0
    bx      lr

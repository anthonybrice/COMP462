    .thumb
    .syntax unified
    .section .text, "x"

_start:
    .global _start          @ "_start" is required by the linker
    .global main            @ "main" is our main program

    b       main            @ Start running the main program

main:
    lsl     r0, r0, #2
    sub     sp, r0

//
// cyclicHanoi.s
//
// Cyclic Tower of Hanoi game
//
// return the number of steps in x2

        eor     x2, x2, x2

// x19, x20, x21 are stack pointers for stacks A, B, C
// stacks A, B, C grow upwards

        addi    x19, xzr, #0        // x19 = 0x0000
        addi    x20, xzr, #0x80     // x20 = 0x0080
        addi    x21, xzr, #0x100    // x21 = 0x0100

// place a very large disk of size 255 at the bottom of each stack

        addi    x15, xzr, #0xff     // size of very large disk
        stur    x15, [x19, #0]
        stur    x15, [x20, #0]
        stur    x15, [x21, #0]

// place disks n..1 on stack A

        addi    x4, xzr, #10        // n = 10
        add     x15, xzr, x4
loop:   addi    x19, x19, #8
        stur    x15, [x19, #0]
        subi    x15, x15, #1
        cbnz    x15, loop

        bl      chanoi
        stop

chanoi:

////////////////////////////////////
//
// Your code
//
////////////////////////////////////

error:  subi    x2, xzr, #1         // return -1 if error
        br      lr

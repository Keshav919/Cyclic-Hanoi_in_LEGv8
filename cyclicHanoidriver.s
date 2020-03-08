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

        addi    x4, xzr, #6        // n = 3
        add     x15, xzr, x4
loop:   addi    x19, x19, #8
        stur    x15, [x19, #0]
        subi    x15, x15, #1
        cbnz    x15, loop

        bl      chanoi
        stop

chanoi:

////////////////////////////////////
//                                //
//           Your code            //
//                                //
////////////////////////////////////
	
	subi sp, sp, #32
	stur fp, [sp, #0]
	addi fp, sp, #24
	stur lr, [fp, #-16]
	stur x4, [fp, #0]

//if no disk present return 0
	subs xzr, x4, xzr
	b.eq lr

// if 1 disk present return 1
	addi x2, x2, #1
	subis xzr, x4, #1
	eor x0, x0, x0 //src
	addi x1, xzr, #1 //dst
	addi x3, xzr, #2 //temp
	//branch to move_cw
	b.eq move_cw
	
// else call ccw on n-1
	eor x2, x2, x2
	subi x4, x4, #1
	bl ccw
	ldur x7, [fp, #-40]
	add x2, x7, x7
	addi x2, x2, #1 
	ldur lr, [fp, #-16]

// storing source, destination, and temporary location of disks
	eor x0, x0, x0 //src
	addi x1, xzr, #1 //dst
	addi x3, xzr, #2 //temp

// stack for moving disks
	subi sp, sp, #56
	stur fp, [sp, #0]
	addi fp, sp, #48
	stur lr, [fp, #-40]
	stur x3, [fp, #-32]
	stur x1, [fp, #-24]
	stur x0, [fp, #-16]	
	stur x4, [fp, #0]

	bl move_cw
	ldur lr, [fp, #-40]

	br lr

move_ccw: //calls cw
	subi sp, sp, #56
        stur fp, [sp, #0]
        addi fp, sp, #48
        stur lr, [fp, #-40]
        stur x3, [fp, #-32]
        stur x1, [fp, #-24]
        stur x0, [fp, #-16]
        stur x4, [fp, #0]

	subi x4, x4, #1
	add x1, x1, x3
	sub x3, x1, x3
	sub x1, x1, x3
	cbnz x4, cont_ccw
	addi x4, x4, #1	
	
	bl move_cw
	add x11, xzr, x0
	add x0, xzr, x1
	add x1, xzr, x3
	add x3, xzr, x11
		
	bl move_cw

	ldur lr, [fp, #-40]
        ldur fp, [fp, #-48]
        addi sp, sp, #56
        ldur x4, [fp, #0]
        br lr

cont_ccw:
	ldur x0, [fp, #-16]
	ldur x1, [fp, #-24]
	ldur x3, [fp, #-32]
	addi x4, x4, #1	
	add x1, x1, x3
	sub x3, x1, x3
	sub x1, x1, x3
	bl move_cw

	//ldur x4, [fp, #0]	
	//subi x4, x4, #1
	add x11, xzr, x0
	add x0, xzr, x1
	add x1, xzr, x3
	add x3, xzr, x11
	bl move_cw

	ldur lr, [fp, #-40]
        ldur fp, [fp, #-48]
        addi sp, sp, #56
        ldur x4, [fp, #0]
        br lr
	


	

// moves disks in a clockwise direction
move_cw: 
	subi sp, sp, #56
	stur fp, [sp, #0]
	addi fp, sp, #48
	stur lr, [fp, #-40]
	stur x3, [fp, #-32]
	stur x1, [fp, #-24]
	stur x0, [fp, #-16]	
	stur x4, [fp, #0]

	//check if 1 disk present
	subis xzr, x4, #1
	b.eq move_cw_base

	subi x4, x4, #1 
	ldur x7, [fp, #-16] //src

	//check disks in src
	subis xzr, x0, #0
	b.ne check_1
	
	eor x0, x0, x0
	addi x1, xzr, #2
	addi x3, xzr, #1

check_1: 
	subis xzr, x0, #1
	b.ne check_2
	addi x0, xzr, #1
	addi x1, xzr, #0
	addi x3, xzr, #2

check_2:
	subis xzr, x0, #2
	b.ne cont
	addi x0, xzr, #2
	addi x1, xzr, #1
	addi x3, xzr, #0

cont:

	bl move_ccw

	ldur x0, [fp, #-16]
	ldur x1, [fp, #-24]
	ldur x3, [fp, #-32]


	addi x4, xzr, #1
	bl move_cw

	ldur x4, [fp, #0]
	subi x4, x4, #1

	//swapping x1 and x0
	add x5, x3, x0
	sub x3, x5, x3
	sub x0, x5, x0

	bl move_ccw
	ldur lr, [fp, #-40]
        ldur fp, [fp, #-48]
        addi sp, sp, #56
        ldur x4, [fp, #0]
	br lr

move_cw_base:

	subis xzr, x0, #0
	b.eq move_ab

	subis xzr, x0, #1
	b.eq move_bc

	subis xzr, x0, #2
	b.eq move_ca

	//moving disk from b to c stack
move_ab:
        ldur x10, [x19, #0]
	subis xzr, x10, #255
	ldur lr, [fp, #-40]
        ldur fp, [fp, #-48]
        addi sp, sp, #56
        ldur x4, [fp, #0]
	b.eq return	

        stur xzr, [x19, #0]
	subi x19, x19, #8
	addi x20, x20, #8
	stur x10, [x20, #0]

	//checking error
	ldur x24, [x20, #0]
	subs xzr, x10, x24
	b.gt error
	
        br lr

	//moving disk from b to c stack
move_bc:
        ldur x10, [x20, #0]
	subis xzr, x10, #255
	ldur lr, [fp, #-40]
        ldur fp, [fp, #-48]
        addi sp, sp, #56
        ldur x4, [fp, #0]
	b.eq return	

        stur xzr, [x20, #0]
	subi x20, x20, #8
	addi x21, x21, #8
	stur x10, [x21, #0]

	//checking error
	ldur x24, [x21, #0]
	subs xzr, x10, x24
	b.gt error

        br lr

	//moving disk from c to b
move_ca:
        ldur x10, [x21, #0]
	subis xzr, x10, #255
	ldur lr, [fp, #-40]
        ldur fp, [fp, #-48]
        addi sp, sp, #56
        ldur x4, [fp, #0]
	b.eq return	

        stur xzr, [x21, #0]
	subi x21, x21, #8
	addi x19, x19, #8
	stur x10, [x19, #0]
	
	//check error
	ldur x24, [x19, #0]
	subs xzr, x10, x24
	b.gt error


        br lr

//procedure for calculating ccw
ccw:
	//allocate stack frame
	subi sp, sp, #32
	stur fp, [sp, #0]
	addi fp, sp, #24
	stur xzr, [fp, #-8]
	stur lr, [fp, #-16]
	stur x4, [fp, #0]

	//if n==1, return 2
	subis xzr, x4, #1
	b.eq ccw_ret_base
	
	//else return 2*ccw(n-1) + cw(n-1) + 2
	
	//call cww on n-1
	subi x4, x4, #1
	bl ccw
	ldur x7, [fp, #-40]
	add x8, x7, x7
	
	//call cw on n-1
	subi x4, x4, #1
	stur x8, [fp, #-8]
	bl cw
	ldur x8, [fp, #-8]
	ldur x9, [fp, #-40]
	add x8, x8, x9
	addi x8, x8, #2
	stur x8, [fp, #-8]
	ldur lr, [fp, #-16]
	ldur fp, [fp, #-24]
	addi sp, sp, #32
	ldur x4, [fp, #0]
	br lr
	
ccw_ret_base:
	//returns 2
	addi x7, xzr, #2
	stur x7, [fp, #-8]
	ldur lr, [fp, #-16]
	ldur fp, [fp, #-24]
	addi sp, sp, #32
	ldur x4, [fp, #0]

	br lr
	
cw:
	subi sp, sp, #32
	stur fp, [sp, #0]
	addi fp, sp, #24
	stur lr, [fp, #-16]
	stur x4, [fp, #0]
 
	//if n==0, return 0
	subis xzr, x4, #0
	eor x9, x9, x9
	stur x9, [fp, #-8]
	b.eq return
	
	//if n==1, return 1
	subis xzr, x4, #1
	b.eq cw_ret_base 
	
	//else return 2*ccw(n-1) + 1
	subi x4, x4, #1
	bl ccw
	ldur x7, [fp, #-40]
	add x9, x7, x7
	addi x9, x9, #1
	stur x9, [fp, #-8]
	ldur lr, [fp, #-16]
	ldur fp, [fp, #-24]
	addi sp, sp, #32
	ldur x4, [fp, #0]
	br lr
	
return:
	br lr

cw_ret_base:
	//return 1
	addi x9, xzr, #1
	stur x9, [fp, #-8]
	ldur lr, [fp, #-16]
	ldur fp, [fp, #-24]
	addi sp, sp, #32
	ldur x4, [fp, #0]
	br lr 
	
error:  subi    x2, xzr, #1         // return -1 if error
        br      lr

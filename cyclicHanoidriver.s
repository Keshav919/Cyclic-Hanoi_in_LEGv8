//
// cyclicHanoi.s
//
// Cyclic Tower of Hanoi game
//
// return the number of steps in x2

        eor     x2, x2, x2 //zero in x2

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
	b.eq lr
	
//else call ccw on n-1
	eor x2, x2, x2 //zero in x2
	subi x4, x4, #1
	bl ccw
	add x2, x7, x7
	addi x2, x2, #1 
	ldur lr, [fp, #-16]
	br lr

//procedure for calculating ccw
ccw:
	//allocate stack frame
	subi sp, sp, #32
	stur fp, [sp, #0]
	addi fp, sp, #24
	stur lr, [fp, #-16]
	stur x4, [fp, #0]
	
	//if n==1, return 2
	subis xzr, x4, #1
	b.eq ccw_ret_base
	
	//else return 2*ccw(n-1) + cw(n-1) + 2
	
	//call cww on n-1
	subi x4, x4, #1
	bl ccw
	add x8, x7, x7
	
	//call cw on n-1
	
	subi x4, x4, #1
	bl cw
	add x8, x8, x9
	addi x8, x8, #2
	ldur lr, [fp, #-16]
	ldur fp, [fp, #-24]
	addi sp, sp, #32
	ldur x4, [fp, #0]
	add x7, xzr, x8
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
	b.eq return
	
	//if n==1, return 1
	subis xzr, x4, #1
	b.eq cw_ret_base 
	
	//else return 2*ccw(n-1) + 1
	subi x4, x4, #1
	bl ccw
	add x9, x7, x7
	addi x9, x9, #1
	ldur lr, [fp, #-16]
	ldur fp, [fp, #-24]
	addi sp, sp, #32
	ldur x4, [fp, #0]
	br lr
	
ccw_ret_base:
	addi x7, xzr, #2
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
	ldur lr, [fp, #-16]
	ldur fp, [fp, #-24]
	addi sp, sp, #32
	ldur x4, [fp, #0]
	br lr

	
error:  subi    x2, xzr, #1         // return -1 if error
        br      lr

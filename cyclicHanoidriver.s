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

        addi    x4, xzr, #3        // n = 10
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
	
// store value of top most disk in x8
	ldur x8,[x19, #0]

//if no disk present return 0
	subs xzr, x4, xzr
	b.eq lr

// if 1 disk present return 1
	addi x2, x2, #1
	subis xzr, x4, #1
	b.eq lr
	
	eor x2, x2, x2 //zero in x2

//else call ccw on n-1
	subi x4, x4, #1
	bl ccw
	muli x2, x2, #2
	addi x2, x2, #1 
	//br lr
	b done

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
	b ccw_ret_gt
	
cw: //question: should cw be stored in different register and then added on?
	//if n==0, return 0
	subis xzr, x4, #0
	b.eq lr 
	
	//if n==1, return 1
	subis xzr, x4, #1
	b.eq cw_ret_base 
	
	//else return 2*ccw(n-1) + 1
	subi x4, x4, #1
	bl ccw
	mul x2, x2, #2
	addi x2, x2, #1
	br lr
	
ccw_ret_base:
	addi x2, xzr, #2
	br lr
	
ccw_ret_gt:
	//call cww on n-1
	subis x4, x4, #1
	bl ccw
	//call cw on n-1
	bl cw
	muli x2, x2, #2
	addi x2, x2, #2
	br lr

cw_ret_base:
	//return 1
	
	br lr

done:
	
error:  subi    x2, xzr, #1         // return -1 if error
        br      lr

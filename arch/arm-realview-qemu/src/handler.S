.global _start

/* Interrupt vector table.
 * GNU assembler uses _start keyword to place this as first executable line,
 * jumping straight to reset handler */
_start:
	b reset
	b undef_handler
	b svc_handler
	b .
	b .
	b .
	b irq_handler

/* fiq_hander must immediately follow interrupt vector table. Saves one jump */
fiq_handler:
	b .

/* reset handler. On boot, these are the first kernel instructions executed.
 * May end up here if system borks real bad */
reset:
	/* Give IRQ mode 1KB stack */
	msr cpsr_c, #0xC2		/* IRQ MODE | IRQ OFF | FIQ ON | ASYNC OFF */
	ldr r0, = stack_top	
	mov sp, r0
	sub r0, r0, #0x400

	/* Give SYS mode 1KB stack */
	msr cpsr_c, #0xCF		/* SYS MODE | IRQ OFF | FIQ ON | ASYNC OFF */
	mov sp, r0
	sub r0, r0, #0x400

	/* Give SVC mode rest of stack space */
	msr cpsr_c, #0xC3		/* SVC MODE | IRQ OFF | FIQ ON | ASYNC OFF */
	mov sp, r0

	/* Set location of interrupt vector table in coprocessor 15 */
	ldr r0, =_start
	mcr p15, #0, r0, c12, c0, #0 	/* c12 = Vector Base Address Register (VBAR)*/ 

	/* Enable Async abort by clearing bit 0b10000000 */
	mrs r1, CPSR			/* Load CPSR register values */
	bic r1, #0x80			/* Clear 8th bit */
	msr cpsr_c, r1			/* Set CPSR */
	
	bl init

/* Improper use of instructions may trigger this */
undef_handler:
	b .

/* SuperVisor Call. Interrupt in manually triggered with 'svc #'
 * Mode is automatically changed to SVC when this happens */  
svc_handler:
	b .

irq_handler:
	b .

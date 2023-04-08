/* Interrupt vector table.
 * GNU assembler uses _start keyword to place this as first executable line,
 * jumping straight to reset handler */
.section .vector_table, "x"
.global _Reset
_Reset:
	b reset_handler
	b undef_handler
	b svc_handler
	b . /* Prefetch Abort */
	b . /* Data Abort */
	b . /* Reserved */
	b irq_handler

/* fiq_hander must immediately follow interrupt vector table. Saves one jump */
fiq_handler:
	b .

/* reset handler. On boot, these are the first kernel instructions executed.
 * May end up here if system borks real bad */
.section .text
reset_handler:
	/* Set FIQ stack */
	msr cpsr_c, #0xD1		/* FIQ MODE | IRQ OFF | FIQ OFF */
	ldr r0, =_fiq_stack_top	
	mov sp, r0
	
	/* Set IRQ stack */
	msr cpsr_c, #0xD2		/* IRQ MODE | IRQ OFF | FIQ OFF */
	ldr r0, =_irq_stack_top	
	mov sp, r0

	/* Set SVC stack */
	msr cpsr_c, #0xD3		/* SVC MODE | IRQ OFF | FIQ OFF */
	ldr r0, =_svc_stack_top
	mov sp, r0

	/* Set location of interrupt vector table in coprocessor 15 */
	ldr r0, =_Reset
	mcr p15, #0, r0, c12, c0, #0 	/* c12 = Vector Base Address Register (VBAR)*/ 

	/* Enable interrupts by clearing 8th bit */
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

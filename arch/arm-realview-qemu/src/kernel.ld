
MEMORY
{
	RAM (rwx): ORIGIN = 0x70000000, LENGTH = 0x20000000
}

ENTRY(_Reset)
SECTIONS
{
	. = 0x10000;     	    /* QEMU expects to start here when using -kernel */
	.text : { 
		obj/handler.o (.vector_table)     /* Interrupt vector must be first */
		*(.text) 
		*(.rodata)
	}
	_text_end = .;			/* For moving sections if need be */
	.data : {
		_data_start = .;
		*(.data)
		. = ALIGN(8);
		_data_end = .;
	}
	.bss : {
		_bss_start = .;
		*(.bss)
		. = ALIGN(8);
		_bss_end = .;
	}
	. = . + 0x1000;  	    /* Set FIQ stack location [4KB] */ 
	_fiq_stack_top  = .;
	_fiq_stack_size = 0x1000;
	. = . + 0x1000;			/* Set IRQ stack location [4KB] */
	_irq_stack_top  = .;	
	_irq_stack_size = 0x1000;
	. = . + 0x10000;		/* Set SVC stack location [64KB] */
	_svc_stack_top  = .;
	_svc_stack_size = 0x10000;
}

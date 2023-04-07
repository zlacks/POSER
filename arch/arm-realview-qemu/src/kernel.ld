ENTRY(_start)
SECTIONS
{
	. = 0x10000;     	    /* QEMU expects to start here when using -kernel */
	._start . : { obj/handler.o(.text) }	/* Make sure _start is at 0x10000 */
	.text   : { *(.text) }
	.rodata : { *(.rodata) }
	.data   : ALIGN(4) { *(.data) }
	.bss    : { *(.bss COMMON) }
	. = ALIGN(8);
	. = . + 0x10000;  	   /* Set up a 64KB stack for the kernel*/ 
	stack_top = .;
}

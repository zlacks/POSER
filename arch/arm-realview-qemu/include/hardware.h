#ifndef HARDWARE_H
#define HARDWARE_H

/* CLOCKS AND INTERRUPTS --------------------------------------------------- */  

/* 24MHz reference clock located on OSC0 */
#define REF_CLK 24000000u

/* UART interrupt values */
#define UART0_INT 44
#define UART1_INT 45
#define UART2_INT 46
#define UART3_INT 47

/* MEMORY MAP -------------------------------------------------------------- */

#define UART0_BASE 0x10009000
#define UART1_BASE 0x1000A000
#define UART2_BASE 0x1000B000
#define UART3_BASE 0x1000C000

#define GIC_DIST_BASE  ((cpu_get_periphbase() + GIC_DIST_OFFSET))
#define GIC_IFACE_BASE ((cpu_get_periphbase() + GIC_IFACE_OFFSET))

#endif /* HARDWARE_H */

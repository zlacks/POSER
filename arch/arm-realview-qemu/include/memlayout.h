#ifndef MEMLAYOUT_H
#define MEMLAYOUT_H

/* 24MHz reference clock located on OSC0 */
#define REF_CLK 24000000u

#define UART0_BASE 0x10009000

#define GIC_DIST_BASE  ((cpu_get_periphbase() + GIC_DIST_OFFSET))
#define GIC_IFACE_BASE ((cpu_get_periphbase() + GIC_IFACE_OFFSET))

#endif /* MEMLAYOUT_H */

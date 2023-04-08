#ifndef _MEMLAYOUT_H
#define _MEMLAYOUT_H

#define UART0_BASE 0x10009000

#define GIC_DIST_BASE  ((cpu_get_periphbase() + GIC_DIST_OFFSET))
#define GIC_IFACE_BASE ((cpu_get_periphbase() + GIC_IFACE_OFFSET))

#endif /* _MEMLAYOUT_H */

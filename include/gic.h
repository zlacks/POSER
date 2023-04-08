#ifndef _GIC_H
#define _GIC_H 

#include <types.h>

/* from umanovskis/baremetal-arm */
/* Generic Interrupt Controller (GIC) Distributor registers */
typedef volatile struct __attribute__((packed)) {
  u32_t DCTLR;                 /* 0x0 Distributor Control register */
  const u32_t DTYPER;          /* 0x4 Controller type register */
  const u32_t DIIDR;           /* 0x8 Implementer identification register */
  u32_t _reserved0[29];        /* 0xC - 0x80; reserved and implementation-defined */
  u32_t DIGROUPR[32];          /* 0x80 - 0xFC Interrupt group registers */
  u32_t DISENABLER[32];        /* 0x100 - 0x17C Interrupt set-enable registers */
  u32_t DICENABLER[32];        /* 0x180 - 0x1FC Interrupt clear-enable registers */
  u32_t DISPENDR[32];          /* 0x200 - 0x27C Interrupt set-pending registers */
  u32_t DICPENDR[32];          /* 0x280 - 0x2FC Interrupt clear-pending registers */
  u32_t DICDABR[32];           /* 0x300 - 0x3FC Active Bit Registers (GIC v1) */
  u32_t _reserved1[32];        /* 0x380 - 0x3FC reserved on GIC v1 */
  u32_t DIPRIORITY[255];       /* 0x400 - 0x7F8 Interrupt priority registers */
  u32_t _reserved2;            /* 0x7FC reserved */
  const u32_t DITARGETSRO[8];  /* 0x800 - 0x81C Interrupt CPU targets, RO */
  u32_t DITARGETSR[246];       /* 0x820 - 0xBF8 Interrupt CPU targets */
  u32_t _reserved3;            /* 0xBFC reserved */
  u32_t DICFGR[64];            /* 0xC00 - 0xCFC Interrupt config registers */
} gic_distributor_registers;

/* GIC-CPU Interface Registers */
typedef volatile struct __attribute__((packed)) {
  u32_t CCTLR;                 /* 0x0 CPU Interface control register */
  u32_t CCPMR;                 /* 0x4 Interrupt priority mask register */
  u32_t CBPR;                  /* 0x8 Binary point register */
  const u32_t CIAR;            /* 0xC Interrupt acknowledge register */
  u32_t CEOIR;                 /* 0x10 End of interrupt register */
  const u32_t CRPR;            /* 0x14 Running priority register */
  const u32_t CHPPIR;          /* 0x18 Higher priority pending interrupt register */
  u32_t CABPR;                 /* 0x1C Aliased binary point register */
  const u32_t CAIAR;           /* 0x20 Aliased interrupt acknowledge register */
  u32_t CAEOIR;                /* 0x24 Aliased end of interrupt register */
  const u32_t CAHPPIR;         /* 0x28 Aliased highest priority pending interrupt register */
} gic_cpu_interface_registers;

#endif /* _GIC_H */ 

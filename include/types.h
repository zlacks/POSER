#ifndef _TYPES_H
#define _TYPES_H

typedef unsigned char   u8_t;
typedef signed char     s8_t;
typedef unsigned short  u16_t;
typedef signed short    s16_t;
typedef unsigned int    u32_t;
typedef signed int      s32_t;

#define REG(addr) (*((volatile u32_t *)(addr)))

#endif /* _TYPES_H */


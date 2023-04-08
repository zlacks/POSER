#include <types.h>
#include <memlayout.h>

/* Optimize by telling compiler we will never return from this function */
void init() __attribute__((noreturn));

/* Print string to UART */
void printk(char *s){
  for(; *s != '\0'; s++){
    REG(UART0_BASE) = *s;  
  }
}

/* Kernel entry point after boot. Any initialization functions go here before
 * the kernel jumps to scheduling processes and dealing with interrupts */
void init(){
  printk("Hello World!\n");
  for (;;);
}


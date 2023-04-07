#include <types.h>
#include <uart.h>

/* Print string to UART */
void printk(char *s){
  for(; *s != '\0'; s++){
    REG(UART0) = *s;  
  }
}

/* Kernel entry point after boot. Any initialization functions go here before
 * the kernel jumps to scheduling processes and dealing with interrupts */
void init(){
  printk("Hello World!\n");
}


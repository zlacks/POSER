#include <memlayout.h>
#include <uart.h>

void uart_lower(char c){
  (void)c;
}

/* Optimize by telling compiler we will never return from this function */
void init() __attribute__((noreturn));

/* Kernel entry point after boot. Any initialization functions go here before
 * the kernel jumps to scheduling processes and dealing with interrupts */
void init(){
  uart_config uc = {
    .data_bits = 8,
    .stop_bits = 1,
    .parity    = 0,
    .baudrate  = 9600
  };
  uart_init(&uc, uart_lower);

  uart_putchar('D');  
  uart_putchar('T');  
  uart_putchar('S');  
  uart_putchar('\n');  
  uart_write("Hello World!\n");
  for (;;);
}


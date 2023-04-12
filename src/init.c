#include <hardware.h>
#include <uart.h>

/* Compare two strings
 * Return 0 if strings are the same, > 0 if they are different */
int16_t strcmp(const char* str1, const char* str2){  
  while (*str1 != '\0' && *str2 != '\0'){
    if (*str1++ != *str2++) 
      return 1;
  }
  return *str1 - *str2; /* Will be 0 if they are both null terminators */
}

void parse_cmd(const char* cmd){
  if (!strcmp("help\r", cmd))
    uart_write("Commands:\n\thelp\n");
  else
    uart_write("Unknown command!\n");
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
  uart_configure(&uc);

  uart_putchar('D');  
  uart_putchar('T');  
  uart_putchar('S');  
  uart_putchar('\n');  
  uart_write("Hello World!\n");

  /* Test input */
  char c;
  char buff[64];
  uint8_t buff_idx = 0;
  
  for (;;){
    if (uart_getchar(&c) == UART_OK){
      uart_putchar(c);
      buff[buff_idx] = c;
      
      if (++buff_idx == 62)
        buff_idx = 0;

      if (c != '\r')
        continue;

      uart_putchar('\n');
      buff[buff_idx] = '\0';
      buff_idx = 0;
      parse_cmd(buff);
    }
  }
}


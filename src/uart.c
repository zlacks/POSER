#include <hardware.h>
#include <uart.h>

static uart_registers* uart0 = (uart_registers*)UART0_BASE;
void (*uart_callback)(char);

uart_error uart_init(uart_config* config, void (*callback)(char)){
  if (config->data_bits < 5u || config->data_bits > 8u)
    return UART_INVALID_ARGUMENT_WORDSIZE;
  
  if (config->stop_bits > 2u)
    return UART_INVALID_ARGUMENT_WORDSIZE;
  
  if (config->baudrate < 110u || config->baudrate > 460800u)
    return UART_INVALID_ARGUMENT_WORDSIZE;

  /* Disable the UART */
  uart0->CR &= ~CR_UARTEN;

  /* Finish any current transmission, and flush the FIFO */
  while (uart0->FR & FR_BUSY);
  uart0->LCRH &= ~LCRH_FEN;

  /* Set the baudrate. This requires us to calculate a baudrate divisor
   * based on the requested baudrate and the reference clock. */ 
  float baudrate_divisor = (float)REF_CLK / (16u * config->baudrate);

  /* This divisor is split into two parts: integer part and fractional part */
  uint16_t int_part = baudrate_divisor; 
  float frac_part   = baudrate_divisor - (float)int_part;

  /* The fractional part is converted to a 6-bit representation before passing
   * both parts to the UART */
  uart0->IBRD = int_part;
  uart0->FBRD = (uint8_t)((frac_part * 64u) + 0.5);

  /* Set Line Control Register bits. Load in all bits before setting */
  /* Set data word size */
  uint32_t lcrh = config->data_bits - 5;            // only 2 bits. 00 = 5 ... 11 = 8

  /* Set parity. If enabled, use even pairty */
  if (config->parity) {
    lcrh |= LCRH_PEN;
    lcrh |= LCRH_EPS;
    lcrh |= LCRH_SPS;
  } 
  else {
    lcrh &= ~LCRH_PEN;
    lcrh &= ~LCRH_EPS;
    lcrh &= ~LCRH_SPS;  
  }

  /* Set stop bits */
  if (config->stop_bits == 1u)
    lcrh &= ~LCRH_STP2;
  else if (config->stop_bits == 2u)
    lcrh |= LCRH_STP2;

  /* Enable FIFOs */
  lcrh |= LCRH_FEN;

  /* Actually set LCRH in UART */
  uart0->LCRH = lcrh;

  /* Enable UART */
  uart0->CR |= CR_UARTEN;

  /* Set IRQ handler */
  uart_callback = callback;

  /* TODO: Set uart_isr */

  return UART_OK;
}

/* Transmit a single character over UART */
void uart_putchar(char c){
  /* Wait until TX is free */
  while (uart0->FR & FR_TXFF);

  /* Put the characting into the data register */
  uart0->DR = c;
}

void uart_write(const char* data) {
  while (*data) uart_putchar(*data++);
}

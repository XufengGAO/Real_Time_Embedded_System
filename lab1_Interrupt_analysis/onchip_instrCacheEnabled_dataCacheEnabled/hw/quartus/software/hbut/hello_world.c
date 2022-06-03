/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <stdio.h>
#include "io.h"
#include "system.h"
#include <inttypes.h>
#include <unistd.h>
#include "sys/alt_stdio.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

alt_u8 key_flag =0;
void Button_Interrupt(void* context );
void init_button_pio(alt_isr_func my_PIO_ISR);
int main()
{
  printf("Hello from Nios II!\n");
  init_button_pio(Button_Interrupt);
  while(1);
  return 0;
}


void Button_Interrupt(void* context){
	key_flag =~key_flag;
	printf("button interrupt!\n");
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_0_BASE,0x1);// clear the interrupt
}

void init_button_pio(alt_isr_func my_PIO_ISR)
{
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_0_BASE,0x1);
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_0_BASE,0x1);
	// register the ISR
	alt_ic_isr_register(PIO_0_IRQ_INTERRUPT_CONTROLLER_ID, PIO_0_IRQ, my_PIO_ISR, NULL, NULL);

	// set up PIO & enable interrupt
	//PIO_Setup(0,1);
}

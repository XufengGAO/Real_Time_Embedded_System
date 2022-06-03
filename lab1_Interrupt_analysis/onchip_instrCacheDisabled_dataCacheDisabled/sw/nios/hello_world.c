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

// register map
#define IREGDIR  0
#define IREGPIN	 1
#define IREGPORT 2
#define IREGSET_PORT  3
#define IREGCLR_PORT  4
#define IREGCLR_INT 5
#define IREGEN_INT  6

// register value
#define MODE_ALL_OUTPUT 0XFF
#define MODE_ALL_INPUT  0X00
#define ALL_IRQ_EN      0XFF
#define ALL_IRQ_CLR     0XFF

// functions
void PIO_Test();
void PIO_Setup(uint32_t initValue, uint32_t intEnFlag);
void PIO_Period_Measurement();
void PIO_Response_Recovery_Time_IRQ(void* context);
void PIO_Response_Recovery_Time_Measurement();
void PIO_Interrupt_Setup(alt_isr_func my_PIO_ISR);

int flag = 0;

int main()
{
  printf("Hello from Nios II!\n");
  //PIO_Setup(0,0);
  //PIO_Test();

  //PIO_Period_Measurement();
  PIO_Response_Recovery_Time_Measurement();

  return 0;
}
void PIO_Test()
{
	volatile unsigned int k;
	while (1)
	{
		// output ParPort
		IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGDIR*4, MODE_ALL_OUTPUT);
		alt_printf("iRegPort=%x\n", IORD_32DIRECT(CUSTOMPIO_0_BASE, IREGDIR));

		// write ParPort 0x9b
		IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGPORT*4, 0xba);
		alt_printf("iRegPort=%x\n", IORD_32DIRECT(CUSTOMPIO_0_BASE, IREGPORT));

		for(k=0;k<1000000;k++);

		// input ParPort
		//IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGDIR, MODE_ALL_INPUT);
		//alt_printf("iRegDir=%x\n", IORD_32DIRECT(CUSTOMPIO_0_BASE, IREGDIR));

		//for(k=0;k<1000000;k++);

		break;
	}
}
void PIO_Setup(uint32_t initValue, uint32_t intEnFlag)
{
	// disable interrupt
	IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGEN_INT*4, 0);

	// set output mode to all ports & initialize with all 0s
	IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGDIR*4, MODE_ALL_OUTPUT);
	IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGPORT*4, initValue);

	// clear interrupt & reconfigure interrupt enable register
	IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGCLR_INT*4, 0XFFFFFFFF);
	IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGEN_INT*4, intEnFlag);
}
void PIO_Period_Measurement()
{
	// set up PIO & disable interrupt
	PIO_Setup(0, 0);

	// measure PIO pulse
	while(1)
	{
		IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGPORT*4, 1);
		IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGPORT*4, 0);
		IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGPORT*4, 1);
		IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGPORT*4, 0);
	}
}
void PIO_Response_Recovery_Time_IRQ(void* context)
{
	// clear interrupt
	IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGCLR_INT*4, 1);
	// clear GPIO(0)
	IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGCLR_PORT*4, 1);

}
void PIO_Response_Recovery_Time_Measurement()
{
	PIO_Interrupt_Setup(PIO_Response_Recovery_Time_IRQ);
	while(1)
	{
		IOWR_32DIRECT(CUSTOMPIO_0_BASE, IREGSET_PORT*4, 1);
	}
}
void PIO_Interrupt_Setup(alt_isr_func my_PIO_ISR)
{
	// register the ISR
	alt_ic_isr_register(CUSTOMPIO_0_IRQ_INTERRUPT_CONTROLLER_ID, CUSTOMPIO_0_IRQ, my_PIO_ISR, NULL, NULL);

	// set up PIO & enable interrupt
	PIO_Setup(0,1);
}


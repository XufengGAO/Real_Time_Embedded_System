/*
 * C program for custom PIO with interrupt 
 */

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

int main()
{
  //PIO_Setup(0,0);
  //PIO_Test();
  //PIO_Period_Measurement();
  PIO_Response_Recovery_Time_Measurement();

  return 0;
}

// To evaluate the functionality of PIO
void PIO_Test()
{
	volatile unsigned int k;
	while (1)
	{
		// output ParPort
		IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGDIR*4, MODE_ALL_OUTPUT);
		alt_printf("iRegPort=%x\n", IORD_32DIRECT(CUSTOM_PIO_0_BASE, IREGDIR));

		// write ParPort 0xba
		IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGPORT*4, 0xba);
		alt_printf("iRegPort=%x\n", IORD_32DIRECT(CUSTOM_PIO_0_BASE, IREGPORT));

		for(k=0;k<1000000;k++);

		// input ParPort
		IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGDIR, MODE_ALL_INPUT);
		alt_printf("iRegDir=%x\n", IORD_32DIRECT(CUSTOM_PIO_0_BASE, IREGDIR));

		for(k=0;k<1000000;k++);

		break;
	}
}

// function to set up the PIO
void PIO_Setup(uint32_t initValue, uint32_t intEnFlag)
{
	// disable interrupt
	IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGEN_INT*4, 0);

	// set output mode to all ports & initialize with all 0s
	IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGDIR*4, MODE_ALL_OUTPUT);
	IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGPORT*4, initValue);

	// clear interrupt & reconfigure interrupt enable register
	IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGCLR_INT*4, 0XFFFFFFFF);
	IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGEN_INT*4, intEnFlag);
}

// function to produce pulse wave 
void PIO_Period_Measurement()
{
	// set up PIO & disable interrupt
	PIO_Setup(0, 0);

	// measure PIO pulse
	while(1)
	{
		IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGPORT*4, 1);
		IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGPORT*4, 0);
		IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGPORT*4, 1);
		IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGPORT*4, 0);
	}
}

// interrupt handler for PIO
void PIO_Response_Recovery_Time_IRQ(void* context)
{
	// clear GPIO(0)
	IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGCLR_PORT*4, 1);

	// clear interrupt
	IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGCLR_INT*4, 1);

}

// function to measure interrupt response and recovery time
void PIO_Response_Recovery_Time_Measurement()
{
	PIO_Interrupt_Setup(PIO_Response_Recovery_Time_IRQ);
	while(1)
	{
		IOWR_32DIRECT(CUSTOM_PIO_0_BASE, IREGSET_PORT*4, 1);
	}
}

// function to set up interrupt mode
void PIO_Interrupt_Setup(alt_isr_func my_PIO_ISR)
{
	// register the ISR
	alt_ic_isr_register(CUSTOM_PIO_0_IRQ_INTERRUPT_CONTROLLER_ID, CUSTOM_PIO_0_IRQ, my_PIO_ISR, NULL, NULL);

	// set up PIO & enable interrupt
	PIO_Setup(0,1);
}


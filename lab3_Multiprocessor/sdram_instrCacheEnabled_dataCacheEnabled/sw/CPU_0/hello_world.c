#include <stdio.h>
#include <stdlib.h>
#include "system.h"
#include <altera_avalon_mutex.h>
#include "altera_avalon_mailbox_simple.h"
#include "io.h"
#include <inttypes.h>
#include <stdint.h>
#include <string.h>
#include "sys/alt_cache.h"
#include <unistd.h>

// CPU_0 program

// PIO register map
#define IREGDIR  0      // set direction
#define IREGPIN	 1      // read iRegPort
#define IREGPORT 2      // write iRegPort
#define IREGSET  3      // set iRegPort
#define IREGCLR  4      // clear iRegPort
#define IREGPORT_INC  7 // simple increment counter with write signal

// counter register map
#define IRERESET 4*0  // reset counter
#define IRESTART 4*1  // start counter
#define IRESTOP 4*2   // stop counter
#define IRECOUNTER 4*3   // read counter


// Manipulation 1: Prints "Hello World from CPU 0"
void manip1(){
  while (1){
    printf("Hello from CPU %d.\n", ALT_CPU_CPU_ID_VALUE);
    usleep(3000000);
  }
}

// Set up IPs
void setUp(){
  // reset + start counter
  IOWR_32DIRECT(CUSTOM_COUNTER_0_BASE, IRERESET, 0xffffffff);
  IOWR_32DIRECT(CUSTOM_COUNTER_0_BASE, IRESTART, 0xffffffff);

  // set LED_0 and shared PIO as output
  IOWR_8DIRECT(LED_0_BASE, IREGDIR, 0xff);
  IOWR_8DIRECT(SHARED_PIO_BASE, IREGDIR, 0xff);
}

// Manipulation 2.1: Access PIO connected to LED

// read_modify_write PIO counter
void Read_Modify_Write(uint32_t base_addr, uint8_t increment){
  // read PIO
  uint8_t current = IORD_8DIRECT(base_addr, IREGPIN);
  // modify + write
  IOWR_8DIRECT(base_addr, IREGPORT, current+increment);
}

void manip2_1(){
  setUp();

  // each processor read_modify_write the LED every 50ms
  while(1){
    uint32_t start = IORD_32DIRECT(CUSTOM_COUNTER_0_BASE, IRECOUNTER);
    Read_Modify_Write(LED_0_BASE, 1);
    uint32_t end = IORD_32DIRECT(CUSTOM_COUNTER_0_BASE, IRECOUNTER);
    printf("Access time to LED: %ld cycles\n", end-start);
    usleep(50000);  // 50ms
  }
}

// Manipulation 2.2: Access shared PIO with Hardware Mutex

// exclusive read_modify_write PIO counter
void Ex_Read_Modify_Write(uint32_t base_addr, uint8_t increment, alt_mutex_dev* mutex){
  // acquire the mutex, setting the value to one
  altera_avalon_mutex_lock(mutex, 1);
  //IOWR_8DIRECT(SHARED_PIO_BASE, IREGSET, 0x1);
  // Access a shared resource here.
  Read_Modify_Write(base_addr, increment);
  //printf("CPU_0 in Mutex\n");
  //usleep(100000); // 20ms
  // release the lock
  //IOWR_8DIRECT(SHARED_PIO_BASE, IREGCLR, 0x1);
  altera_avalon_mutex_unlock(mutex);
}

void manip2_2(){
  setUp();
  // get the mutex device handle
  alt_mutex_dev* cpu_0_mutex = altera_avalon_mutex_open(SHARED_MUTEX_PIO_NAME);

  // processor 0 exclusive read_modify_write the LED every 20ms
  while(1){
    uint32_t start = IORD_32DIRECT(CUSTOM_COUNTER_0_BASE, IRECOUNTER);
    Ex_Read_Modify_Write(SHARED_PIO_BASE, 1, cpu_0_mutex);
    uint32_t end = IORD_32DIRECT(CUSTOM_COUNTER_0_BASE, IRECOUNTER);
    printf("Exclusive access time from CPU0 to shared PIO: %ld cycles\n", end-start);
    usleep(20000); // 20ms
  }
}

// Manipulation 3: Hardware Mailbox

// CPU_0 as sender
void tx_cb (void* report, int status){
  if (!status){
    printf("Transfer done\n");
  }else {
    printf("error in transfer\n");
  }
}

void manip3()
{
  //alt_u32 tx_msg[2] = {0x00001111, 0x0};
  alt_u32 tx_msg[2] = {0x00001111, SDRAM_CONTROLLER_BASE};
  char *msg_pt = SDRAM_CONTROLLER_BASE;
  altera_avalon_mailbox_dev* mailbox_sender;
  mailbox_sender = altera_avalon_mailbox_open(SHARED_MAILBOX_NAME, tx_cb, NULL);
  if(!mailbox_sender){
	  printf ("FAIL: Unable to open mailbox_simple");
  }

	// custom messages
  msg_pt = 0x20;
  alt_dcache_flush_all();
  tx_msg[1] = (alt_u32) msg_pt;
  alt_u32 status = altera_avalon_mailbox_send(mailbox_sender, tx_msg, 0, POLL);

  if(status){
    printf("error in transfer");
  }else {
    printf("Transfer done");
    printf("Message command 0x%x and Message 0x%x\n",tx_msg[0], tx_msg[1]);
    //printf("Value 0x%x and  0x%x\n",*(tx_msg[0]), *(tx_msg[1]));
  }
  altera_avalon_mailbox_close(mailbox_sender);
}

// simple write of increment/initialize value
void simple_modify(uint32_t base_addr, uint8_t increment){
  // simple modify + write
  IOWR_8DIRECT(base_addr, IREGPORT_INC, increment);
}

// Manipulation 4: Hardware Counter
void manip4()
{
  setUp();
  // processor 0 simple-increment the shared PIO counter
  while(1){
    uint32_t start = IORD_32DIRECT(CUSTOM_COUNTER_0_BASE, IRECOUNTER);
    simple_modify(SHARED_PIO_BASE, 1);
    uint32_t end = IORD_32DIRECT(CUSTOM_COUNTER_0_BASE, IRECOUNTER);
    printf("Access time to shared PIO: %ld cycles\n", end-start);
    usleep(20000); // 20ms
  }

}


void LED_official()
{
  while (1)
  {
    IOWR_8DIRECT(PIO_0_BASE, 0x0, 0x1);
    usleep(2000000); // 20ms
    IOWR_8DIRECT(PIO_0_BASE, 0x0, 0x0);
    usleep(2000000); // 20ms
  }
}

/* The main function creates two task and starts multi-tasking */
int main(void)
{
	//LED_official();
	//manip1();
	//manip2_1();
	//manip2_2();
	manip3();
	//manip4();
  return 0;
}

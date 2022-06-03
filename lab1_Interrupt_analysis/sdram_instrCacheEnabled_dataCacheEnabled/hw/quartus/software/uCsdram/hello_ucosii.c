#include <stdio.h>
#include "includes.h"
#include "io.h"
#include "system.h"
#include <inttypes.h>
#include <unistd.h>
#include "sys/alt_stdio.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];
OS_STK    task3_stk[TASK_STACKSIZE];
OS_STK    task4_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */
#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2
#define TASK3_PRIORITY      3
#define TASK4_PRIORITY      4

#define QUEUE_SIZE 10
OS_EVENT *sem_res;
OS_FLAG_GRP *flag_res;
OS_FLAGS flags;
OS_EVENT *mail_res;
OS_EVENT *queue_res;
//unsigned char c = 0x0f

typedef struct  {
  unsigned char button_number;
  unsigned char edge;
} msg;

msg* msg_queue[10];
msg some_msg;

unsigned int start, stop;


/* Prints "Hello World" and sleeps for three seconds */
void task1(void* pdata)
{
  while (1)
  { 
    printf("Hello from task1\n");

    // to tell uC that this task is done executing and to give
    // other tasks a change to run
    OSTimeDlyHMSM(0, 0, 3, 0);
  }
}
/* Prints "Hello World" and sleeps for three seconds */
void task2(void* pdata)
{
  while (1)
  { 
    printf("Hello from task2\n");
    OSTimeDlyHMSM(0, 0, 3, 0);
  }
}
/* The main function creates two task and starts multi-tasking */

void task_sem(void* pdata)
{
  INT8U err;
  while(1)
  {
    // WAIT operation
    // arg_1: to acquire semaphore to get access to the subsequent functions
    // arg_2: to specify a timeout, 0 means wait forever

    OSSemPend(sem_res, 0, &err);
    IOWR_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE, 9);
    stop = IORD_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE);
    if(err == OS_NO_ERR){
      // measure the time required to get semaphore
      printf("Getting semaphore in : %u cycles\n", start - stop);
    } else {
      // if semaphore is not available within a certain amount of time
      // an error code is issued
      printf("Not getting semaphore\n");
    }
  }
}

void task_flag(void* pdata)
{
  INT8U err;
  while(1)
  {
    OSFlagPend(flag_res, 0xf, OS_FLAG_WAIT_SET_ALL, 0, &err);
    IOWR_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE, 9);
    stop = IORD_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE);
    if (err == OS_NO_ERR)
    {
      printf("Getting flag in %u cycles\n", start - stop);
    } else {
      printf("Not getting flag\n");
    }
    OSFlagPost(flag_res, 0Xf, OS_FLAG_CLR, &err);
  }
}

void task_mail(void* pdata)
{
  INT8U err;
  msg* bla;

  while(1)
  {
    bla = (struct msg*)OSMboxPend(mail_res, 0, &err);
    IOWR_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE, 9);
    stop = IORD_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE);
    if (err == OS_NO_ERR)
    {
      printf("Getting message in : %u cycles with button number %u and edge %02X\n", start - stop, bla->button_number, bla->edge);
    } else {
      printf("Not getting message\n");
    }
  }
}

void task_queue(void* pdata)
{
  INT8U err;
  msg* bla;

  while(1)
  {
    bla = (struct msg*)OSQPend(queue_res, 0, &err);
    IOWR_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE, 9);
    stop = IORD_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE);
    if (err == OS_NO_ERR)
    {
      printf("Getting message from queue in : %u cycles with button number %u and edge %02X\n", start-stop, bla->button_number, bla->edge);
    } else {
      printf("Not getting message\n");
    }
  }
}

// ISR for semaphore
void my_isr_sem(void* context)
{
  // edge-capture register for PIO IP
  // if edge occurred, bit(n) = '1'
  unsigned char v = IORD(PIO_0_BASE, 3);

  // custom PIO IP
  // show interrupt states on external GPIO
  IOWR(CUSTOM_PIO_0_BASE, 0, v);

  switch(v){
    // if edge occurred
    case 0x1:
        // read the data value currently on PIO inputs
        if ((IORD(PIO_0_BASE,0) & 0x1) == 0)
        {
          // task release by performing a SIGNAL operation
          OSSemPost(sem_res);
          IOWR_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE, 9);
          start = IORD_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE);
        }
        break;
    default:
        break;
  }

  IOWR_ALTERA_AVALON_PIO_EDGE_CAP( PIO_0_BASE,0x0);// clear the interrupt
}

void my_isr_flag(void* context)
{
  INT8U err;
  unsigned char v = IORD(PIO_0_BASE, 3);
  OSFlagPost(flag_res, v, OS_FLAG_SET, &err);
  IOWR_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE, 9);
  // start the counter
  start = IORD_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE);
  // clear PIO interrupt
  IOWR(PIO_0_BASE, 3, 0x0f);
}

void my_isr_mail(void* context)
{
  unsigned char v = IORD(PIO_0_BASE, 3);
  some_msg.button_number = v;
  // rising edge = 0, falling edge = 1
  some_msg.edge = ((IORD(PIO_0_BASE,0)&0x1) == 0) ? 0x80 : 0;
  OSMboxPost(mail_res, &some_msg);
  IOWR_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE, 9);
  start = IORD_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE);

  IOWR(PIO_0_BASE, 3, 0x0f);
}

void my_isr_queue(void* context)
{
  unsigned char v = IORD(PIO_0_BASE, 3);
  some_msg.button_number = v;
  // rising edge = 0, falling edge = 1
  some_msg.edge = ((IORD(PIO_0_BASE,0)&0x1) == 0) ? 0x80 : 0;
  OSQPost(queue_res, &some_msg);
  IOWR_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE, 9);
  start = IORD_ALTERA_AVALON_TIMER_SNAPL(TIMER_1_BASE);

  IOWR(PIO_0_BASE, 3, 0x0f);
}

void Button_Interrupt(void* context){
	printf("button interrupt!\n");
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_0_BASE,0x1);// clear the interrupt
}

int main(void)
{

  printf("MicroC/OS-II Licensing Terms\n");
  OSInit();
  INT8U err;
  // create semaphore
  // initialize the semaphore to 1, telling uC to only allow one task to access the
  // function
  //sem_res = OSSemCreate(1);

  //flag_res = OSFlagCreate(0, &err);
  //mail_res = OSMboxCreate(NULL);
  queue_res = OSQCreate(msg_queue, QUEUE_SIZE);

  // timer configuration
  IOWR_ALTERA_AVALON_TIMER_PERIODL(TIMER_1_BASE, 0xffff);
  IOWR_ALTERA_AVALON_TIMER_PERIODH(TIMER_1_BASE, 0x0000);
  IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_1_BASE, 2);
  IOWR_ALTERA_AVALON_TIMER_CONTROL(TIMER_1_BASE, 6);


  // register the IRQ for PIO IP
  alt_ic_isr_register(PIO_0_IRQ_INTERRUPT_CONTROLLER_ID, PIO_0_IRQ, my_isr_queue, NULL, NULL);
  //alt_ic_isr_register(PIO_0_IRQ_INTERRUPT_CONTROLLER_ID, PIO_0_IRQ, Button_Interrupt, NULL, NULL);

  // clear edge-capture register on PIO IP
  IOWR(PIO_0_BASE,3,0x0f);
  //IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_0_BASE, 0x0f);
  // IRQ enable for all input ports
  IOWR(PIO_0_BASE,2,0x0f);

  // create the task
  /*
  OSTaskCreateExt(task_sem,
                  NULL,
                  (void *)&task1_stk[TASK_STACKSIZE-1],
                  TASK1_PRIORITY,
                  TASK1_PRIORITY,
                  task1_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);

  */
  OSTaskCreateExt(task_queue,
                  NULL,
                  (void *)&task2_stk[TASK_STACKSIZE-1],
                  TASK2_PRIORITY,
                  TASK2_PRIORITY,
                  task2_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);

  OSStart();
  return 0;
}

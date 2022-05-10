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
#include <assert.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

#include "io.h"
#include "system.h"


#define Start_flag                0x01

void LCD_Init();
void LCD_RESET();
void LCD_WR_REG(__uint32_t command_addr);
void LCD_WR_DATA(__uint32_t command_data);

// registers in slave
__uint32_t csr_Mode_select = 0x00;
__uint32_t csr_LCD_command = 0x04;
__uint32_t csr_Read_address = 0x08;
__uint32_t csr_Burst_count = 0x0C;
__uint32_t csr_Burst_total = 0x10;
__uint32_t csr_Status = 0x14;
__uint32_t csr_Start_flag = 0x18;

// RESET modes in LCD_Control
__uint32_t SET_RESET_N  = 0b000;
__uint32_t Clr_RESET_N  = 0b001;
__uint32_t Write_Command_addr = 0b010;
__uint32_t Write_Command_data = 0b011;
__uint32_t Write_image_data  = 0b100;

int main()
{

    // Initialize LCD
    LCD_Init();

    // Write DMA reading memory address
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Read_address, HPS_0_BRIDGES_BASE);

    // Write Burst count value

    // Write Burst total value

    // Start DMA reading and LCD_Control writing
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Start_flag, Start_flag);

    // Clear the status
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status, 0);

    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Mode_select, Write_image_data);
    // Waiting for display finished
    while(!IORD_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status)) {
        usleep(100);
    }
    printf("Image displayed");

    return 0;
}

void LCD_Init()
{
    LCD_RESET();        // reset LCD

    LCD_WR_REG(0x0011); // Exit Sleep with 120 ms delay
    usleep(120000);

    LCD_WR_REG(0x00CF); // Power Control B
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0081);
    LCD_WR_DATA(0x00c0);

    LCD_WR_REG(0x00ED); // Power on sequence control
    LCD_WR_DATA(0x0064);
    LCD_WR_DATA(0x0003);
    LCD_WR_DATA(0x0012);
    LCD_WR_DATA(0x0081);

    LCD_WR_REG(0x00E8); // Driver timing control A
    LCD_WR_DATA(0x0085);
    LCD_WR_DATA(0x0001);
    LCD_WR_DATA(0x0078);

    LCD_WR_REG(0x00CB); // Power Control A
    LCD_WR_DATA(0x0039);
    LCD_WR_DATA(0x002C);
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0034);
    LCD_WR_DATA(0x0002);

    LCD_WR_REG(0x00F7); // Pump ratio control
    LCD_WR_DATA(0x0020);

    LCD_WR_REG(0x00EA); // Driver timing control B
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0000);

    LCD_WR_REG(0x00B1); // Frame Rate Control��In Normal Mode /Full colors
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x001B);

    LCD_WR_REG(0x00B6); // Display Function Control
    LCD_WR_DATA(0x000A);
    LCD_WR_DATA(0x00A2);

    LCD_WR_REG(0x00C0); // Power control 1
    LCD_WR_DATA(0x0005);

    LCD_WR_REG(0x00C1); // Power control 2
    LCD_WR_DATA(0x0011);

    LCD_WR_REG(0x00C5); // VCM control 1
    LCD_WR_DATA(0x0045);
    LCD_WR_DATA(0x0045);

    LCD_WR_REG(0x00C7); // VCM control 2
    LCD_WR_DATA(0x00A2);

    LCD_WR_REG(0x0036); // Memory Access Control...
    LCD_WR_DATA(0x0008);

    LCD_WR_REG(0x00F2);     // Enable 3G
    LCD_WR_DATA(0x0000);    // 3Gamma Function Disable

    LCD_WR_REG(0x0026);     // Gamma Set
    LCD_WR_DATA(0x0001);    // Gamma curve selected

    LCD_WR_REG(0x00E0);     // Positive Gamma Correction, Set Gamma
    LCD_WR_DATA(0x000F);
    LCD_WR_DATA(0x0026);
    LCD_WR_DATA(0x0024);
    LCD_WR_DATA(0x000b);
    LCD_WR_DATA(0x000E);
    LCD_WR_DATA(0x0008);
    LCD_WR_DATA(0x004b);
    LCD_WR_DATA(0X00a8);
    LCD_WR_DATA(0x003b);
    LCD_WR_DATA(0x000a);
    LCD_WR_DATA(0x0014);
    LCD_WR_DATA(0x0006);
    LCD_WR_DATA(0x0010);
    LCD_WR_DATA(0x0009);
    LCD_WR_DATA(0x0000);

    LCD_WR_REG(0X00E1); //Negative Gamma Correction, Set Gamma
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x001c);
    LCD_WR_DATA(0x0020);
    LCD_WR_DATA(0x0004);
    LCD_WR_DATA(0x0010);
    LCD_WR_DATA(0x0008);
    LCD_WR_DATA(0x0034);
    LCD_WR_DATA(0x0047);
    LCD_WR_DATA(0x0044);
    LCD_WR_DATA(0x0005);
    LCD_WR_DATA(0x000b);
    LCD_WR_DATA(0x0009);
    LCD_WR_DATA(0x002f);
    LCD_WR_DATA(0x0036);
    LCD_WR_DATA(0x000f);

    LCD_WR_REG(0x002A); // Column Address Set
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x00ef);

    LCD_WR_REG(0x002B); // Page Address Set
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0001);
    LCD_WR_DATA(0x003f);

    LCD_WR_REG(0x003A); // COLMOD: Pixel Format Set
    LCD_WR_DATA(0x0055);


    LCD_WR_REG(0x00f6); // Interface Control
    LCD_WR_DATA(0x0001);
    LCD_WR_DATA(0x0030);
    LCD_WR_DATA(0x0000);

    LCD_WR_REG(0x0029); // Display on

    LCD_WR_REG(0x002c); // Memory Write Start
}

void LCD_WR_REG(__uint32_t command_addr)
{
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_LCD_command, command_addr);
    // Clear the status
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status, 0);
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Mode_select, Write_Command_addr);
    while(!IORD_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status)) {
        usleep(1);
    }
}

void LCD_WR_DATA(__uint32_t command_data)
{
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_LCD_command, command_data);
    // Clear the status
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status, 0);
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Mode_select, Write_Command_data);
    while(!IORD_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status)) {
        usleep(1);
    }
}

void LCD_RESET()
{
    // Clear the status
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status, 0);
    // set SET_RESET_N 1 ms
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Mode_select, SET_RESET_N);
    while(!IORD_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status)) {
        usleep(100);
    }
    usleep(1000);

    // Clear the status
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status, 0);
    // clear SET_RESET_N 10 ms
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Mode_select, Clr_RESET_N);
    while(!IORD_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status)) {
        usleep(200);
    }
    usleep(10000);

    // Clear the status
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status, 0);
    // set SET_RESET_N 120 ms
    IOWR_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Mode_select, SET_RESET_N);
    while(!IORD_32DIRECT(LCD_CONTROLLER_0_BASE, csr_Status)) {
        usleep(200);
    }
    usleep(120000);
}

int write_image(void) {

    const char* filename = "/mnt/host/TestImage.txt";
	int buffer[3];
	__uint32_t writedata;
	FILE* finput = fopen(filename, "r");

	if (!finput) {
		printf("cannot open the picture file");
		return -1;
	}
	printf("read start\n");


    // NOTE: offset starts from 0, conflicts with program? (check BSP)
    __uint32_t offset = 0;
    // first row - zero padding
    for (int i = 0; i < 242; i++) {
        offset = i * 4;
        IOWR_32DIRECT(HPS_0_BRIDGES_BASE, offset, 0);
    }

	for (int i = 0; i < 240 * 320; i++) {

        // first column and last column - zero padding
        if ((i % 240 == 0) || (i % 239 == 0)) {
            offset += 4;
            IOWR_32DIRECT(HPS_0_BRIDGES_BASE, offset, 0);
        } 

		for (int j = 0; j < 3; j++) {
			fscanf(finput, "%d", &buffer[j]);
		}
		__uint8_t pixel_r = buffer[0] & 248;
		__uint8_t pixel_g = buffer[1] & 252;
		__uint8_t pixel_b = buffer[2] & 248;
		writedata = 0;
		writedata = writedata | (pixel_r << 16) | (pixel_g << 8) | (pixel_b);

        offset += 4;

        IOWR_32DIRECT(HPS_0_BRIDGES_BASE, offset, writedata);
        printf("writedata = %" PRIu32 "\n", writedata);
        // Read through address span expander
        __uint32_t readdata = IORD_32DIRECT(HPS_0_BRIDGES_BASE, offset);
        printf("readdata = %" PRIu32 "\n", readdata);
        // Check if read data is equal to written data
        assert(writedata == readdata);

	}

    // last row - zero padding
    for (int i = 0; i < 242; i++) {
        offset += 4;
        IOWR_32DIRECT(HPS_0_BRIDGES_BASE, offset, writedata);
    }

	printf("read finished\n");
	return EXIT_SUCCESS;
}

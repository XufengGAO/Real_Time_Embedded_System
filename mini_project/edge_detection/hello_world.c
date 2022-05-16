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
#include <assert.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdint.h>
#include <string.h>
#include "sys/alt_cache.h"
#include <unistd.h>
#include "io.h"
#include "system.h"


#define Start_flag                0x01

// custom functions
void LCD_Init();                // function to initialize the LCD
void LCD_RESET();               // funciton to reset the LCD
void LCD_WR_REG(__uint32_t command_addr);       // function to write command address to LCD
void LCD_WR_DATA(__uint32_t command_data);      // function to write command value to LCD
int write_image(void);                          // write image from host to FPGA memory
void display_image(void);                       // display image on LCD

void LCD_Init();
void LCD_RESET();
void LCD_WR_REG(__uint32_t command_addr);
void LCD_WR_DATA(__uint32_t command_data);

// registers in slave
__uint32_t csr_Mode_select = 0x00;
__uint32_t csr_LCD_command = 0x04;
__uint32_t csr_Read_address = 0x08;
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
	// Write image
	int flag = 0;

    // un-commment it when you wanna write image to FPGA memory
    // here, we provide an iamge called "epfl_res.jpg"
    // we extract all pixels to an txt file called "epfl_res.txt"
    // in write_iamge() function, the host reads all pixels included in "epfl_res.txt" and writes them to FPGA
	//flag = write_image();

	printf("Final");

    // un-commment it when you wanna display the image stored in FPGA memory
	// display image
	display_image();

    return 0;
}
void display_image(void)
{
	// Initialize LCD
	LCD_Init();

    // Write DMA reading memory address
	IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Read_address, SDRAM_CONTROLLER_0_BASE);

    // Start DMA reading and LCD_Control writing
	IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Start_flag, Start_flag);

    // Clear the status
	IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status, 0);

	IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Mode_select, Write_image_data);
    // Waiting for display finished
	while(!IORD_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status)) {
		usleep(100);
	}
	printf("Image displayed");
}

void LCD_Init()
{
    LCD_RESET();        // reset LCD

    LCD_WR_REG(0x0011); // Exit Sleep with 120 ms delay
    usleep(130000);

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
    LCD_WR_DATA(0x0079);

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

    LCD_WR_REG(0x00B1); // Frame Rate Control In Normal Mode /Full colors
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

    // Note: you can configure the direction of displaying image by youself
    // Here we use LCD horizontal
    LCD_WR_REG(0x0036); // Memory Access Control...
    //LCD_WR_DATA(0x00A8); 	// horizontal
    LCD_WR_DATA(0x0008);	// vertical

    LCD_WR_REG(0x002A);	// vertical, Column Address Set
    //LCD_WR_REG(0x002B); 	// horizontal, Column Address Set
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x00ef);

    LCD_WR_REG(0x002B);	// vertical, Page Address Set
    //LCD_WR_REG(0x002A); 	// horizontal, Page Address Set
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0000);
    LCD_WR_DATA(0x0001);
    LCD_WR_DATA(0x003f);

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



    LCD_WR_REG(0x003A); // COLMOD: Pixel Format Set
    LCD_WR_DATA(0x0055);


    LCD_WR_REG(0x00f6); // Interface Control
    LCD_WR_DATA(0x0001);
    LCD_WR_DATA(0x0030);
    LCD_WR_DATA(0x0000);

    LCD_WR_REG(0x0029); // Display on

    LCD_WR_REG(0x002c); // Memory Write Start
}

// function to write LCD command address
void LCD_WR_REG(__uint32_t command_addr)
{
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_LCD_command, command_addr);
    // Clear the status
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status, 0);
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Mode_select, Write_Command_addr);
    while(!IORD_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status)) {
        usleep(1);
    }
}

// function to write LCD command data
void LCD_WR_DATA(__uint32_t command_data)
{
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_LCD_command, command_data);
    // Clear the status
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status, 0);
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Mode_select, Write_Command_data);
    while(!IORD_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status)) {
        usleep(1);
    }
}

// function to reset LCD
void LCD_RESET()
{
    // Clear the status
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status, 0);
    // set SET_RESET_N 1 ms
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Mode_select, SET_RESET_N);
    while(!IORD_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status)) {
        usleep(100);
    }
    usleep(1100);

    // Clear the status
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status, 0);
    // clear SET_RESET_N 10 ms
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Mode_select, Clr_RESET_N);
    while(!IORD_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status)) {
        usleep(200);
    }
    usleep(11000);

    // Clear the status
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status, 0);
    // set SET_RESET_N 120 ms
    IOWR_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Mode_select, SET_RESET_N);
    while(!IORD_32DIRECT(EDGE_DETECTOR_0_BASE, csr_Status)) {
        usleep(200);
    }
    usleep(130000);
}

int write_image(void) {

    const char* filename = "/mnt/host/image240_320.txt";
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
        IOWR_32DIRECT(SDRAM_CONTROLLER_0_BASE, offset, 0);
        alt_dcache_flush_all();
    }

	for (int i = 0; i < 240 * 320; i++) {

        // first column and last column - zero padding
        if (i % 240 == 0) {
            offset += 4;
            IOWR_32DIRECT(SDRAM_CONTROLLER_0_BASE, offset, 0);
            alt_dcache_flush_all();
        }

		for (int j = 0; j < 3; j++) {
			fscanf(finput, "%d", &buffer[j]);
		}
		__uint8_t pixel_r = buffer[0];
		__uint8_t pixel_g = buffer[1];
		__uint8_t pixel_b = buffer[2];
		writedata = 0;
		writedata = writedata | (pixel_r << 16) | (pixel_g << 8) | (pixel_b);

        offset += 4;

        IOWR_32DIRECT(SDRAM_CONTROLLER_0_BASE, offset, writedata);
        alt_dcache_flush_all();
        printf("i = %d\n", i);
        // Read through address span expander
        __uint32_t readdata = IORD_32DIRECT(SDRAM_CONTROLLER_0_BASE, offset);
        //printf("readdata = %d\n", readdata);
        // Check if read data is equal to written data
        assert(writedata == readdata);

        if (i % 240 == 239) {
            offset += 4;
            IOWR_32DIRECT(SDRAM_CONTROLLER_0_BASE, offset, 0);
            alt_dcache_flush_all();
        }

	}

    // last row - zero padding
    for (int i = 0; i < 242; i++) {
        offset += 4;
        IOWR_32DIRECT(SDRAM_CONTROLLER_0_BASE, offset, 0);
        alt_dcache_flush_all();
    }

	printf("read finished\n");
	return EXIT_SUCCESS;
}


void pure_software() {
    __uint32_t currentAddr = 0; // address to access pixel values

    int pixelValue[9] = {0,0,0,0,0,0,0,0,0};
    __uint32_t rawPixelVal = 0;
    int gx = 0; // gradient x
    int gy = 0; // gradient y
    int g_sum = 0; // abs(gx) + abs(gy)

    for (int i = 0; i < 320; i++) {
        // calculate for a row
        // first read 9 pixels
        for (int pixel_count = 0; pixel_count < 9; pixel_count++) {
            rawPixelVal = IORD_32DIRECT(HPS_0_BRIDGES_BASE, currentAddr);
            pixelValue[pixel_count] = ((rawPixelVal & 255) + ((rawPixelVal & 65280) >> 8) + ((rawPixelVal & 16711680) >> 16))/3;
            if (pixel_count % 3 == 2) {
                currentAddr -= 1932;
            } else {
                currentAddr += 968;
            }
        }

        // 1-239 pixel in one row
        for (int j = 0; j < 239; j++) {
            // calculate 2d convolution
            gx = -pixelValue[0] - 2 * pixelValue[1] - pixelValue[2] + pixelValue[6] + 2 * pixelValue[7] + pixelValue[8];
            gy = -pixelValue[0] - 2 * pixelValue[3] - pixelValue[6] + pixelValue[2] + 2 * pixelValue[5] + pixelValue[8];
            g_sum = abs(gx) + abs(gy);
            // TODO: write g_sum into a .txt file

            // shift and read new pixels
            for (int jj = 0; jj < 3; jj++) {
                pixelValue[jj] = pixelValue[3+jj];
                pixelValue[3+jj] = pixelValue[6+jj];
                rawPixelVal = IORD_32DIRECT(HPS_0_BRIDGES_BASE, currentAddr);
                pixelValue[6+jj] = ((rawPixelVal & 255) + ((rawPixelVal & 65280) >> 8) + ((rawPixelVal & 16711680) >> 16))/3;
                if (jj == 2) {
                    currentAddr -= 1932;
                } else {
                    currentAddr += 968;
                }
            }
        }

        // last pixel in one row
        gx = -pixelValue[0] - 2 * pixelValue[1] - pixelValue[2] + pixelValue[6] + 2 * pixelValue[7] + pixelValue[8];
        gy = -pixelValue[0] - 2 * pixelValue[3] - pixelValue[6] + pixelValue[2] + 2 * pixelValue[5] + pixelValue[8];
        g_sum = abs(gx) + abs(gy);
        // TODO: write g_sum into a .txt file

        
    }
}
#include <stdio.h>
#include "io.h"
#include "system.h"
#include <inttypes.h>
#include <unistd.h>
#include "sys/alt_stdio.h"
#include "sys/alt_irq.h"
#include <stdlib.h>
#include <altera_avalon_performance_counter.h>
#include <stdbool.h>
#include <sys/alt_cache.h>

// Lab 2: Profiling. Authors: Gao Xufeng and Sun Haoxin
// Profiling command used in NIOS2-eclipse shell
// Software: nios2-download -g --write-gmon gmon_0.out *.elf && nios2-elf-gprof *.elf gmon_0.out > report_0.txt;
// Hardware: nios2-download -g *.elf

// test data and expected bit-manipulation result used in our lab
uint32_t test_data = 0x11110000;
uint32_t expected_res = 0x00008811;

// array to mimic 1000 bit manipulations case
uint32_t input[1000];
uint32_t output[1000];

// write data into memory
void write_data(int data_len);

// check the bit manipulation results
bool check_res(int data_len, bool cache);

// Implementation 1: pure software in c
uint32_t software_Bit_Manipulator(uint32_t input);
void software_profile(int data_len, int amount);

// Lookup tabled used in Implementation 1
// To store the bit-flipping results corresponding to each index of the table
static uint32_t lookup_bitflip[256] = {
		0x00, 0x80, 0x40, 0xc0, 0x20, 0xa0, 0x60, 0xe0,
		0x10, 0x90, 0x50, 0xd0, 0x30, 0xb0, 0x70, 0xf0,
		0x08, 0x88, 0x48, 0xc8, 0x28, 0xa8, 0x68, 0xe8,
		0x18, 0x98, 0x58, 0xd8, 0x38, 0xb8, 0x78, 0xf8,
		0x04, 0x84, 0x44, 0xc4, 0x24, 0xa4, 0x64, 0xe4,
		0x14, 0x94, 0x54, 0xd4, 0x34, 0xb4, 0x74, 0xf4,
		0x0c, 0x8c, 0x4c, 0xcc, 0x2c, 0xac, 0x6c, 0xec,
		0x1c, 0x9c, 0x5c, 0xdc, 0x3c, 0xbc, 0x7c, 0xfc,
		0x02, 0x82, 0x42, 0xc2, 0x22, 0xa2, 0x62, 0xe2,
		0x12, 0x92, 0x52, 0xd2, 0x32, 0xb2, 0x72, 0xf2,
		0x0a, 0x8a, 0x4a, 0xca, 0x2a, 0xaa, 0x6a, 0xea,
		0x1a, 0x9a, 0x5a, 0xda, 0x3a, 0xba, 0x7a, 0xfa,
		0x06, 0x86, 0x46, 0xc6, 0x26, 0xa6, 0x66, 0xe6,
		0x16, 0x96, 0x56, 0xd6, 0x36, 0xb6, 0x76, 0xf6,
		0x0e, 0x8e, 0x4e, 0xce, 0x2e, 0xae, 0x6e, 0xee,
		0x1e, 0x9e, 0x5e, 0xde, 0x3e, 0xbe, 0x7e, 0xfe,
		0x01, 0x81, 0x41, 0xc1, 0x21, 0xa1, 0x61, 0xe1,
		0x11, 0x91, 0x51, 0xd1, 0x31, 0xb1, 0x71, 0xf1,
		0x09, 0x89, 0x49, 0xc9, 0x29, 0xa9, 0x69, 0xe9,
		0x19, 0x99, 0x59, 0xd9, 0x39, 0xb9, 0x79, 0xf9,
		0x05, 0x85, 0x45, 0xc5, 0x25, 0xa5, 0x65, 0xe5,
		0x15, 0x95, 0x55, 0xd5, 0x35, 0xb5, 0x75, 0xf5,
		0x0d, 0x8d, 0x4d, 0xcd, 0x2d, 0xad, 0x6d, 0xed,
		0x1d, 0x9d, 0x5d, 0xdd, 0x3d, 0xbd, 0x7d, 0xfd,
		0x03, 0x83, 0x43, 0xc3, 0x23, 0xa3, 0x63, 0xe3,
		0x13, 0x93, 0x53, 0xd3, 0x33, 0xb3, 0x73, 0xf3,
		0x0b, 0x8b, 0x4b, 0xcb, 0x2b, 0xab, 0x6b, 0xeb,
		0x1b, 0x9b, 0x5b, 0xdb, 0x3b, 0xbb, 0x7b, 0xfb,
		0x07, 0x87, 0x47, 0xc7, 0x27, 0xa7, 0x67, 0xe7,
		0x17, 0x97, 0x57, 0xd7, 0x37, 0xb7, 0x77, 0xf7,
		0x0f, 0x8f, 0x4f, 0xcf, 0x2f, 0xaf, 0x6f, 0xef,
		0x1f, 0x9f, 0x5f, 0xdf, 0x3f, 0xbf, 0x7f, 0xff
};

// Implementation 2: custom instruction
uint32_t Custom_Instruction_Bit_Manipulator(uint32_t input);
void custom_Ins_profile(int data_len, int amount);

// Implementation 3: hardware accelerator
void Accelerator_profile(int data_len, int amount);

// register map used in hardware accelerator
#define IREReadAddr  0
#define IREWriteAddr	 1
#define IREComputeCount 2
#define IREStart  3
#define IREDone  4


int main()
{
	// performance counter functions
	PERF_RESET(PERFORMANCE_COUNTER_0_BASE);
	PERF_START_MEASURING(PERFORMANCE_COUNTER_0_BASE);

	// we test 3 cases, 1 bit manipulation, 1000 bit manipulations, and 1000000 bit manipulations
	// corresponding to (data_len, amount) = (1, 1), (1000, 1), (1000, 1000)
	int data_len = 1000;
	int amount = 1000;

	// validation to check if the manipulation results are correct
	bool validation = false;

	alt_printf("Start\n");

	// software
	write_data(data_len);
	software_profile(data_len, amount);
	validation = check_res(data_len, true);
	validation ? alt_printf("software res=True\n") : alt_printf("software res=False\n");

	// custom instruction
	write_data(data_len);
	custom_Ins_profile(data_len, amount);
	validation = check_res(data_len, true);
	validation ? alt_printf("custom Ins res=True\n") : alt_printf("custom Ins res=False\n");

	// hardware accelerator
	write_data(data_len);
	Accelerator_profile(data_len, amount);
	validation = check_res(data_len, false);
	validation ? alt_printf("Accelerator res=True\n") : alt_printf("Accelerator res=False\n");

	PERF_STOP_MEASURING(PERFORMANCE_COUNTER_0_BASE);
	perf_print_formatted_report(PERFORMANCE_COUNTER_0_BASE, alt_get_cpu_freq(), 3, "software", "custom_iIs", "Accelerator");

	//exit(EXIT_SUCCESS);
	return 0;
}

// function to write data to memory
void write_data(int data_len)
{
	for(int i = 0; i < data_len; i++)
	{
		input[i] = test_data;
		output[i] = 0;
	}
	// write dirty data back to memory
	alt_dcache_flush_all();
}

// function to check manipulation results
bool check_res(int data_len, bool cache)
{
	for(int i = 0; i < data_len; i++)
	{
		uint32_t swapping_res = cache ? output[i] : IORD_32DIRECT(&output[i],0);
		if(swapping_res != expected_res)
		{
			alt_printf("Wrong res=%x\n", swapping_res);
			return false;
		}
	}
	return true;
}

uint32_t software_Bit_Manipulator(uint32_t input) {
    // most 8 bits
	uint32_t high = input & 0xFF000000;
    // least 8 bits
	uint32_t low = input & 0x000000FF;
    // middle 16 bits, right shift 8 bits
	uint32_t middle = (input & 0x00FFFF00) >> 8;
    // get the reverse order bits
	uint32_t flipped_middle = lookup_bitflip[middle & 0x00FF] << 8 | lookup_bitflip[middle >> 8];
    // concatenate all bits
	return low << 24 | flipped_middle << 8 | high >> 24;
}

void software_profile(int data_len, int amount)
{
	PERF_BEGIN(PERFORMANCE_COUNTER_0_BASE,1);
	for(int j=0; j<amount; j++){
		for(int i=0; i<data_len; i++){
			output[i] = software_Bit_Manipulator(input[i]);
		}
	}
	PERF_END(PERFORMANCE_COUNTER_0_BASE,1);
}

uint32_t Custom_Instruction_Bit_Manipulator(uint32_t input) {
	return ALT_CI_BIT_MANIPULATE_0(input, 0);
}

void custom_Ins_profile(int data_len, int amount)
{
	PERF_BEGIN(PERFORMANCE_COUNTER_0_BASE,2);
	for(int j=0; j<amount; j++){
		for(int i=0; i<data_len; i++){
			output[i] = Custom_Instruction_Bit_Manipulator(input[i]);
		}
	}
	PERF_END(PERFORMANCE_COUNTER_0_BASE,2);
}

void Accelerator_profile(int data_len, int amount)
{
	PERF_BEGIN(PERFORMANCE_COUNTER_0_BASE,3);
	for(int j=0; j<amount; j++){
		IOWR_32DIRECT(ACCELERATOR_0_BASE, IREReadAddr*4, (uint32_t)&input[0]);
		IOWR_32DIRECT(ACCELERATOR_0_BASE, IREWriteAddr*4, (uint32_t)&output[0]);
		IOWR_32DIRECT(ACCELERATOR_0_BASE, IREComputeCount*4, data_len);
		// start the DMA
		IOWR_32DIRECT(ACCELERATOR_0_BASE,IREStart*4, 1);
		while(IORD_32DIRECT(ACCELERATOR_0_BASE,IREDone*4)!= 1);
		IOWR_32DIRECT(ACCELERATOR_0_BASE, IREComputeCount*4, 0);
	}
	PERF_END(PERFORMANCE_COUNTER_0_BASE,3);
}






/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'CPU_1' in SOPC Builder design 'system'
 * SOPC Builder design path: C:/Users/24833/Desktop/FPGA/lab3_multiprocessor/sdram_instrCacheEnabled_dataCacheEnabled/hw/quartus/system.sopcinfo
 *
 * Generated: Wed Apr 27 20:39:08 CEST 2022
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x04040820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000001
#define ALT_CPU_CPU_IMPLEMENTATION "fast"
#define ALT_CPU_DATA_ADDR_WIDTH 0x1b
#define ALT_CPU_DCACHE_LINE_SIZE 32
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_DCACHE_SIZE 2048
#define ALT_CPU_EXCEPTION_ADDR 0x04020020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 1
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_EXTRA_EXCEPTION_INFO
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 32
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 5
#define ALT_CPU_ICACHE_SIZE 4096
#define ALT_CPU_INITDA_SUPPORTED
#define ALT_CPU_INST_ADDR_WIDTH 0x1b
#define ALT_CPU_NAME "CPU_1"
#define ALT_CPU_NUM_OF_SHADOW_REG_SETS 0
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x04020000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x04040820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000001
#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_DATA_ADDR_WIDTH 0x1b
#define NIOS2_DCACHE_LINE_SIZE 32
#define NIOS2_DCACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_SIZE 2048
#define NIOS2_EXCEPTION_ADDR 0x04020020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 1
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_EXTRA_EXCEPTION_INFO
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_INITDA_SUPPORTED
#define NIOS2_INST_ADDR_WIDTH 0x1b
#define NIOS2_NUM_OF_SHADOW_REG_SETS 0
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x04020000


/*
 * Custom_counter_1 configuration
 *
 */

#define ALT_MODULE_CLASS_Custom_counter_1 Custom_counter
#define CUSTOM_COUNTER_1_BASE 0x4041080
#define CUSTOM_COUNTER_1_IRQ -1
#define CUSTOM_COUNTER_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CUSTOM_COUNTER_1_NAME "/dev/Custom_counter_1"
#define CUSTOM_COUNTER_1_SPAN 16
#define CUSTOM_COUNTER_1_TYPE "Custom_counter"


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_MAILBOX_SIMPLE
#define __ALTERA_AVALON_MUTEX
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PERFORMANCE_COUNTER
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_NIOS2_GEN2
#define __CUSTOMPIO
#define __CUSTOM_COUNTER


/*
 * LED_1 configuration
 *
 */

#define ALT_MODULE_CLASS_LED_1 CustomPIO
#define LED_1_BASE 0x40410a8
#define LED_1_IRQ 1
#define LED_1_IRQ_INTERRUPT_CONTROLLER_ID 0
#define LED_1_NAME "/dev/LED_1"
#define LED_1_SPAN 8
#define LED_1_TYPE "CustomPIO"


/*
 * PERC_1 configuration
 *
 */

#define ALT_MODULE_CLASS_PERC_1 altera_avalon_performance_counter
#define PERC_1_BASE 0x4041000
#define PERC_1_HOW_MANY_SECTIONS 3
#define PERC_1_IRQ -1
#define PERC_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PERC_1_NAME "/dev/PERC_1"
#define PERC_1_SPAN 64
#define PERC_1_TYPE "altera_avalon_performance_counter"


/*
 * SRAM_1 configuration
 *
 */

#define ALT_MODULE_CLASS_SRAM_1 altera_avalon_onchip_memory2
#define SRAM_1_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define SRAM_1_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define SRAM_1_BASE 0x4020000
#define SRAM_1_CONTENTS_INFO ""
#define SRAM_1_DUAL_PORT 0
#define SRAM_1_GUI_RAM_BLOCK_TYPE "AUTO"
#define SRAM_1_INIT_CONTENTS_FILE "system_SRAM_1"
#define SRAM_1_INIT_MEM_CONTENT 1
#define SRAM_1_INSTANCE_ID "NONE"
#define SRAM_1_IRQ -1
#define SRAM_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SRAM_1_NAME "/dev/SRAM_1"
#define SRAM_1_NON_DEFAULT_INIT_FILE_ENABLED 0
#define SRAM_1_RAM_BLOCK_TYPE "AUTO"
#define SRAM_1_READ_DURING_WRITE_MODE "DONT_CARE"
#define SRAM_1_SINGLE_CLOCK_OP 0
#define SRAM_1_SIZE_MULTIPLE 1
#define SRAM_1_SIZE_VALUE 128000
#define SRAM_1_SPAN 128000
#define SRAM_1_TYPE "altera_avalon_onchip_memory2"
#define SRAM_1_WRITABLE 1


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone V"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart_1"
#define ALT_STDERR_BASE 0x40410b0
#define ALT_STDERR_DEV jtag_uart_1
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart_1"
#define ALT_STDIN_BASE 0x40410b0
#define ALT_STDIN_DEV jtag_uart_1
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart_1"
#define ALT_STDOUT_BASE 0x40410b0
#define ALT_STDOUT_DEV jtag_uart_1
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "system"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK TIMER_1
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart_1 configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart_1 altera_avalon_jtag_uart
#define JTAG_UART_1_BASE 0x40410b0
#define JTAG_UART_1_IRQ 3
#define JTAG_UART_1_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_1_NAME "/dev/jtag_uart_1"
#define JTAG_UART_1_READ_DEPTH 64
#define JTAG_UART_1_READ_THRESHOLD 8
#define JTAG_UART_1_SPAN 8
#define JTAG_UART_1_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_1_WRITE_DEPTH 64
#define JTAG_UART_1_WRITE_THRESHOLD 8


/*
 * pio_1 configuration
 *
 */

#define ALT_MODULE_CLASS_pio_1 altera_avalon_pio
#define PIO_1_BASE 0x4041070
#define PIO_1_BIT_CLEARING_EDGE_REGISTER 0
#define PIO_1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PIO_1_CAPTURE 0
#define PIO_1_DATA_WIDTH 8
#define PIO_1_DO_TEST_BENCH_WIRING 0
#define PIO_1_DRIVEN_SIM_VALUE 0
#define PIO_1_EDGE_TYPE "NONE"
#define PIO_1_FREQ 50000000
#define PIO_1_HAS_IN 0
#define PIO_1_HAS_OUT 1
#define PIO_1_HAS_TRI 0
#define PIO_1_IRQ -1
#define PIO_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PIO_1_IRQ_TYPE "NONE"
#define PIO_1_NAME "/dev/pio_1"
#define PIO_1_RESET_VALUE 0
#define PIO_1_SPAN 16
#define PIO_1_TYPE "altera_avalon_pio"


/*
 * sdram_controller configuration
 *
 */

#define ALT_MODULE_CLASS_sdram_controller altera_avalon_new_sdram_controller
#define SDRAM_CONTROLLER_BASE 0x0
#define SDRAM_CONTROLLER_CAS_LATENCY 3
#define SDRAM_CONTROLLER_CONTENTS_INFO
#define SDRAM_CONTROLLER_INIT_NOP_DELAY 0.0
#define SDRAM_CONTROLLER_INIT_REFRESH_COMMANDS 2
#define SDRAM_CONTROLLER_IRQ -1
#define SDRAM_CONTROLLER_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_CONTROLLER_IS_INITIALIZED 1
#define SDRAM_CONTROLLER_NAME "/dev/sdram_controller"
#define SDRAM_CONTROLLER_POWERUP_DELAY 100.0
#define SDRAM_CONTROLLER_REFRESH_PERIOD 7.8125
#define SDRAM_CONTROLLER_REGISTER_DATA_IN 1
#define SDRAM_CONTROLLER_SDRAM_ADDR_WIDTH 0x19
#define SDRAM_CONTROLLER_SDRAM_BANK_WIDTH 2
#define SDRAM_CONTROLLER_SDRAM_COL_WIDTH 10
#define SDRAM_CONTROLLER_SDRAM_DATA_WIDTH 16
#define SDRAM_CONTROLLER_SDRAM_NUM_BANKS 4
#define SDRAM_CONTROLLER_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_CONTROLLER_SDRAM_ROW_WIDTH 13
#define SDRAM_CONTROLLER_SHARED_DATA 0
#define SDRAM_CONTROLLER_SIM_MODEL_BASE 0
#define SDRAM_CONTROLLER_SPAN 67108864
#define SDRAM_CONTROLLER_STARVATION_INDICATOR 0
#define SDRAM_CONTROLLER_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_CONTROLLER_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_CONTROLLER_T_AC 5.4
#define SDRAM_CONTROLLER_T_MRD 3
#define SDRAM_CONTROLLER_T_RCD 15.0
#define SDRAM_CONTROLLER_T_RFC 70.0
#define SDRAM_CONTROLLER_T_RP 15.0
#define SDRAM_CONTROLLER_T_WR 14.0


/*
 * shared_PIO configuration
 *
 */

#define ALT_MODULE_CLASS_shared_PIO CustomPIO
#define SHARED_PIO_BASE 0x40410a0
#define SHARED_PIO_IRQ -1
#define SHARED_PIO_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SHARED_PIO_NAME "/dev/shared_PIO"
#define SHARED_PIO_SPAN 8
#define SHARED_PIO_TYPE "CustomPIO"


/*
 * shared_mailbox configuration
 *
 */

#define ALT_MODULE_CLASS_shared_mailbox altera_avalon_mailbox_simple
#define SHARED_MAILBOX_BASE 0x4041060
#define SHARED_MAILBOX_IRQ -1
#define SHARED_MAILBOX_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SHARED_MAILBOX_NAME "/dev/shared_mailbox"
#define SHARED_MAILBOX_SPAN 16
#define SHARED_MAILBOX_TYPE "altera_avalon_mailbox_simple"


/*
 * shared_mutex_PIO configuration
 *
 */

#define ALT_MODULE_CLASS_shared_mutex_PIO altera_avalon_mutex
#define SHARED_MUTEX_PIO_BASE 0x4041090
#define SHARED_MUTEX_PIO_IRQ -1
#define SHARED_MUTEX_PIO_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SHARED_MUTEX_PIO_NAME "/dev/shared_mutex_PIO"
#define SHARED_MUTEX_PIO_OWNER_INIT 0
#define SHARED_MUTEX_PIO_OWNER_WIDTH 16
#define SHARED_MUTEX_PIO_SPAN 8
#define SHARED_MUTEX_PIO_TYPE "altera_avalon_mutex"
#define SHARED_MUTEX_PIO_VALUE_INIT 0
#define SHARED_MUTEX_PIO_VALUE_WIDTH 16


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid_qsys
#define SYSID_BASE 0x4041098
#define SYSID_ID 0
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1651084195
#define SYSID_TYPE "altera_avalon_sysid_qsys"


/*
 * timer_1 configuration
 *
 */

#define ALT_MODULE_CLASS_timer_1 altera_avalon_timer
#define TIMER_1_ALWAYS_RUN 0
#define TIMER_1_BASE 0x4041040
#define TIMER_1_COUNTER_SIZE 32
#define TIMER_1_FIXED_PERIOD 0
#define TIMER_1_FREQ 50000000
#define TIMER_1_IRQ 2
#define TIMER_1_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TIMER_1_LOAD_VALUE 499999
#define TIMER_1_MULT 0.001
#define TIMER_1_NAME "/dev/timer_1"
#define TIMER_1_PERIOD 10
#define TIMER_1_PERIOD_UNITS "ms"
#define TIMER_1_RESET_OUTPUT 0
#define TIMER_1_SNAPSHOT 1
#define TIMER_1_SPAN 32
#define TIMER_1_TICKS_PER_SEC 100
#define TIMER_1_TIMEOUT_PULSE_OUTPUT 0
#define TIMER_1_TYPE "altera_avalon_timer"

#endif /* __SYSTEM_H_ */

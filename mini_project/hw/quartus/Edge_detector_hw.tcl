# TCL File Generated by Component Editor 18.1
# Tue May 17 11:17:08 CEST 2022
# DO NOT MODIFY


# 
# Edge_detector "Edge_detector" v1.0
#  2022.05.17.11:17:08
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Edge_detector
# 
set_module_property DESCRIPTION ""
set_module_property NAME Edge_detector
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME Edge_detector
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL Edge_Detector_top_level
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file Edge_Detector_top_level.vhd VHDL PATH ../IP/Edge_Detector_top_level.vhd TOP_LEVEL_FILE
add_fileset_file FIFO.vhd VHDL PATH ../IP/FIFO.vhd
add_fileset_file LCD_Control.vhd VHDL PATH ../IP/LCD_Control.vhd
add_fileset_file edge_detection.vhd VHDL PATH ../IP/edge_detection.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point top_avm
# 
add_interface top_avm avalon start
set_interface_property top_avm addressUnits SYMBOLS
set_interface_property top_avm associatedClock clock_sink
set_interface_property top_avm associatedReset reset_sink
set_interface_property top_avm bitsPerSymbol 8
set_interface_property top_avm burstOnBurstBoundariesOnly false
set_interface_property top_avm burstcountUnits WORDS
set_interface_property top_avm doStreamReads false
set_interface_property top_avm doStreamWrites false
set_interface_property top_avm holdTime 0
set_interface_property top_avm linewrapBursts false
set_interface_property top_avm maximumPendingReadTransactions 0
set_interface_property top_avm maximumPendingWriteTransactions 0
set_interface_property top_avm readLatency 0
set_interface_property top_avm readWaitTime 1
set_interface_property top_avm setupTime 0
set_interface_property top_avm timingUnits Cycles
set_interface_property top_avm writeWaitTime 0
set_interface_property top_avm ENABLED true
set_interface_property top_avm EXPORT_OF ""
set_interface_property top_avm PORT_NAME_MAP ""
set_interface_property top_avm CMSIS_SVD_VARIABLES ""
set_interface_property top_avm SVD_ADDRESS_GROUP ""

add_interface_port top_avm top_avm_read_master_waitrequest waitrequest Input 1
add_interface_port top_avm top_avm_read_master_address address Output 32
add_interface_port top_avm top_avm_read_master_byteenable byteenable Output 4
add_interface_port top_avm top_avm_read_master_read read Output 1
add_interface_port top_avm top_avm_read_master_readdata readdata Input 32


# 
# connection point top_avs_csr
# 
add_interface top_avs_csr avalon end
set_interface_property top_avs_csr addressUnits WORDS
set_interface_property top_avs_csr associatedClock clock_sink
set_interface_property top_avs_csr associatedReset reset_sink
set_interface_property top_avs_csr bitsPerSymbol 8
set_interface_property top_avs_csr burstOnBurstBoundariesOnly false
set_interface_property top_avs_csr burstcountUnits WORDS
set_interface_property top_avs_csr explicitAddressSpan 0
set_interface_property top_avs_csr holdTime 0
set_interface_property top_avs_csr linewrapBursts false
set_interface_property top_avs_csr maximumPendingReadTransactions 0
set_interface_property top_avs_csr maximumPendingWriteTransactions 0
set_interface_property top_avs_csr readLatency 0
set_interface_property top_avs_csr readWaitTime 1
set_interface_property top_avs_csr setupTime 0
set_interface_property top_avs_csr timingUnits Cycles
set_interface_property top_avs_csr writeWaitTime 0
set_interface_property top_avs_csr ENABLED true
set_interface_property top_avs_csr EXPORT_OF ""
set_interface_property top_avs_csr PORT_NAME_MAP ""
set_interface_property top_avs_csr CMSIS_SVD_VARIABLES ""
set_interface_property top_avs_csr SVD_ADDRESS_GROUP ""

add_interface_port top_avs_csr top_avs_csr_address address Input 3
add_interface_port top_avs_csr top_avs_csr_read read Input 1
add_interface_port top_avs_csr top_avs_csr_readdata readdata Output 32
add_interface_port top_avs_csr top_avs_csr_write write Input 1
add_interface_port top_avs_csr top_avs_csr_writedata writedata Input 32
set_interface_assignment top_avs_csr embeddedsw.configuration.isFlash 0
set_interface_assignment top_avs_csr embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment top_avs_csr embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment top_avs_csr embeddedsw.configuration.isPrintableDevice 0


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink top_clock_clk clk Input 1


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink top_clock_reset_n reset_n Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock_sink
set_interface_property conduit_end associatedReset reset_sink
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end top_conduit_CSX csx Output 1
add_interface_port conduit_end top_conduit_DCX dcx Output 1
add_interface_port conduit_end top_conduit_Data_out data_out Output 16
add_interface_port conduit_end top_conduit_RDX rdx Output 1
add_interface_port conduit_end top_conduit_RESET_n lcd_reset Output 1
add_interface_port conduit_end top_conduit_WRX wrx Output 1

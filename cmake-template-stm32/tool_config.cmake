
# The board.  Not used for anything yet.
set(EVM_BOARD "")

# Full STM part number. All uppercase.  
# Used by: 
#  - GDB to activate SWO via ST-Link GDB server (swo-go-stlink-gdb-server.gdb.cmake)
set(STM_DEVICE    "")  

# Part number used for Segger software.  Usually a truncated part number representing a family of devices.
# Used by: 
#  - J-Link Serial Wire Output Viewer
#  - J-Link RTT Viewer
# Potentially Used by:
#  - J-Link programmer  
set(SEGGER_DEVICE "")  

# Used by:
#  - J-Link programmer.  If set to zero or not set at all, then 4MHz will be used.
#  - CMake for variable: SERIAL_WIRE_DEBUG_SPEED_KHZ
set(SERIAL_WIRE_DEBUG_SPEED_HZ "4000000")

# Used by: 
#  - J-Link Serial Wire Otutput Viewer
#  - J-Link GDB Server SWO configuration.  Set to 0 and probe will measure CPU speed.
#  - ST-Link GDB Server SWO configuration. The value 0 is not valid for ST-Link.
#  - CMake for variables: SERIAL_WIRE_OUTPUT_SPEED_HZ, CPU_SPEED_KHZ, CPU_SPEED_MHZ
set(CPU_SPEED_HZ "0")

# Used by: 
#  - ST-Link GDB Server SWO configuration.  Must never be zero.
#  - CMake for variable: SERIAL_WIRE_OUTPUT_SPEED_HZ
set(SERIAL_WIRE_OUTPUT_PRESCALER "1")


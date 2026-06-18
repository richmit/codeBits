# Source this script inside GDB to start SWO output:
#   source swo_go_jlink.gdb

monitor SWO EnableTarget @CPU_SPEED_HZ@ @SERIAL_WIRE_OUTPUT_SPEED_HZ@ 1 0

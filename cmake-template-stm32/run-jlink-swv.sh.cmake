#!/bin/bash

# This script will fire up the SEGGER JLinkSWOViewer.  
#
# The following variables should be set in CMakeLists.txt:
#
#   - SEGGER_DEVICE
#   - SERIAL_WIRE_OUTPUT_SPEED_HZ
#   - CPU_SPEED_HZ
#
# These correspond to the elements in the JLinkSWOViewer GUI.
#
# Note you can set the frequency values to zero, and JLinkSWOViewer
# will magically measure the frequency and set an appropriate SWO speed.
#
# The working version of this script will be generated in the build
# directory where it can be called from GDB like this:
#
#   ! bash run-jlink-swv.sh

verGo.sh JLinkSWOViewer -device @SEGGER_DEVICE@ -swofreq @SERIAL_WIRE_OUTPUT_SPEED_HZ@ -cpufreq @CPU_SPEED_HZ@

#!/bin/bash

# This script will fire up the SEGGER JLinkSWOViewer.  
#
# The following variables should be set in CMakeLists.txt:
#
#   - SEGGER_DEVICE
#   - SERIAL_WIRE_DEBUG_SPEED_KHZ
#
# These correspond to the elements in the JLinkRTTViewer GUI.
#
# The working version of this script will be generated in the build
# directory where it can be called from GDB like this:
#
#   ! bash run-jlink-rttv.sh

verGo.sh JLinkRTTViewer --device @SEGGER_DEVICE@ --speed @SERIAL_WIRE_DEBUG_SPEED_KHZ@ --connection usb --interface swd --autoconnect

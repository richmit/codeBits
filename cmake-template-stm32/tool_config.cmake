# -*- Mode:cmake; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      proj_config.cmake
# @author    Mitch Richling http://www.mitchr.me/
# @brief     Project sepcific CMake variable settings.@EOL
# @keywords  stm32
# @std       cmake
# @see       https://github.com/richmit/codeBits/
# @copyright 
#  @parblock
#  Copyright (c) 2026, Mitchell Jay Richling <http://www.mitchr.me/> All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#  
#  1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.
#  
#  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#  
#  3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software
#     without specific prior written permission.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
#  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
#  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
#  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
#  DAMAGE.
#  @endparblock
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# The board.  Not used for anything yet.
set(EVM_BOARD "")

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Full STM part number. All uppercase.  
# Used by: 
#  - GDB to activate SWO via ST-Link GDB server (MCU_ADDR_DBGMCU_BASE)
#  - CMake for variable: MCU_ADDR_DBGMCU_BASE
# Potentially Used by:
#  - CMake for variable: SEGGER_DEVICE & OPENOCD_DEVICE
set(STM_DEVICE "")  

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Part number used for Segger software.  Usually represents a family of devices.
# If set to AUTO, this will the first 11 characters of STM_DEVICE transformed to uppercase.
# Used by: 
#  - J-Link Serial Wire Output Viewer
#  - J-Link RTT Viewer
# Potentially Used by:
#  - J-Link programmer  
set(SEGGER_DEVICE "AUTO")  

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Part number used for OpenOCD.  Usually represents a family of devices.
# If set to AUTO, this will the first 11 characters of STM_DEVICE transformed to uppercase.
# Used by: 
#  - OpenOCD connect configuration (target configuration file name)
#  - OpenOCD SWO configuration (device specific tpiu command)
set(OPENOCD_DEVICE "AUTO")

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Used by:
#  - J-Link programmer.  If set to zero or not set at all, then 4MHz will be used.
#  - CMake for variable: SERIAL_WIRE_DEBUG_SPEED_KHZ
#  - J-Link RTT Viewer (SERIAL_WIRE_DEBUG_SPEED_KHZ)
# Potentially Used by:
#  - J-Link GDB Server (SERIAL_WIRE_DEBUG_SPEED_KHZ)
set(SERIAL_WIRE_DEBUG_SPEED_HZ "4000000")

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Used by: 
#  - J-Link Serial Wire Output Viewer
#  - J-Link GDB Server SWO configuration.  Set to 0 and probe will measure CPU speed.
#  - ST-Link GDB Server SWO configuration. 
#  - OpenOCD SWO configuration.
#  - CMake for variables: SERIAL_WIRE_OUTPUT_SPEED_HZ, CPU_SPEED_KHZ, CPU_SPEED_MHZ
# Potentially Used by:
#  - J-Link GDB Server SWO configuration (SERIAL_WIRE_OUTPUT_SPEED_HZ)
#  - J-Link programmer (CPU_SPEED_KHZ)
#  - Ozone debugger configuration file for SWO & TIF (CPU_SPEED_MHZ)
#  - STM Cube Programmer for the freq= component of --connect option. (CPU_SPEED_KHZ)
set(CPU_SPEED_HZ "0")

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Used by: 
#  - ST-Link GDB Server SWO configuration.  Must never be zero.
#  - CMake for variable: SERIAL_WIRE_OUTPUT_SPEED_HZ
#  - OpenOCD SWO configuration (SERIAL_WIRE_OUTPUT_SPEED_HZ)
# Potentially Used by:
#  - J-Link GDB Server SWO configuration (SERIAL_WIRE_OUTPUT_SPEED_HZ)
set(SERIAL_WIRE_OUTPUT_PRESCALER "1")


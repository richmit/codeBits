#!/usr/bin/env -S sh
# -*- Mode:Shell-script; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      swo-go-stlink-gdb-server.gdb.cmake
# @author    Mitch Richling http://www.mitchr.me/
# @brief     CMake template: GDB script to start SWV with ST-Link GDB Server.@EOL
# @keywords  stm32
# @std       cmake GDB ST-Link STM32 Cortex-M
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
# Startup

# Set GDB language to C for this code
set language c

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Project Specific Parameters

# Baud rate (freq in Hz) 
set $cpuFreq     = @CPU_SPEED_HZ@

# SWO prescalar
set $swoDiv      = @SERIAL_WIRE_OUTPUT_PRESCALER@

# The ITM ports to enable
set $swoPortMask = 0x1

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Chip specific Parameters

# From CMSIS/Include/core_cm4.h.
# Identical in core_armv81mml,                core_armv8mml,            core_cm3, core_cm33, core_cm35p, core_cm7, & core_sc300
set $ITM_BASE       = 0xE0000000

# From CMSIS/Include/core_cm4.h.
# Identical in core_armv81mml, core_armv8mbl, core_armv8mml, core_cm23, core_cm3, core_cm33, core_cm35p, core_cm7, & core_sc300
set $DWT_BASE       = 0xE0001000

# From CMSIS/Include/core_cm4.h.
# Identical in core_armv81mml, core_armv8mbl, core_armv8mml, core_cm23, core_cm3, core_cm33, core_cm35p, core_cm7, & core_sc300
set $TPI_BASE       = 0xE0040000

# From CMSIS/Include/core_cm4.h.
# Identical in core_armv81mml, core_armv8mbl, core_armv8mml, core_cm23, core_cm3, core_cm33, core_cm35p, core_cm7, & core_sc300
set $CoreDebug_BASE = 0xE000EDF0

# From CMSIS/Device/ST/STM32G4xx/Include/stm32f407xx.h : 0xE0042000
# From CMSIS/Device/ST/STM32G4xx/Include/stm32f429xx.h : 0xE0042000
# From CMSIS/Device/ST/STM32G4xx/Include/stm32g431xx.h : 0xE0042000
# From CMSIS/Device/ST/STM32G4xx/Include/stm32g491xx.h : 0xE0042000
# From CMSIS/Device/ST/STM32G4xx/Include/stm32l432xx.h : 0xE0042000
# From CMSIS/Device/ST/STM32G4xx/Include/stm32h753xx.h : 0x5C001000  <- Not like the others. ;)
set $DBGMCU_BASE    = @MCU_ADDR_DBGMCU_BASE@

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Configure the core

# CoreDebug->DEMCR
set *(CoreDebug_BASE + 0x00C) = 0x01000000 

# DBGMCU->CR
set *($DBGMCU_BASE + 0x04)    = 0x00000027

# TPI->SPPR
set *($TPI_BASE + 0x000F0)    = 0x00000002

# TPI->ACPR
set *($TPI_BASE + 0x00010)    = $swoDiv

# ITM->LAR
set *($ITM_BASE + 0x00FB0)    = 0xC5ACCE55

# ITM->TCR
set *($ITM_BASE + 0x00E80)    = 0x1000D

# ITM->TPR
set *($ITM_BASE + 0x00E40)    = 0xF

# ITM->TER
set *($ITM_BASE + 0x00E00)    = $swoPortMask

# DWT_CTRL
set *($DWT_BASE)              = 0x400003FE

# TPI->FFCR
set *($TPI_BASE + 0x00304)    = 0x00000100

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Finished 

# Set GDB language back to auto
set language auto

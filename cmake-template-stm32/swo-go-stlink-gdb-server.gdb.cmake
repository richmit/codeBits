######################################################################################################################################################
# Startup

# Set GDB language to C for this code
set language c

######################################################################################################################################################
# Project Specific Parameters

# Baud rate (freq in Hz) 
set $cpuFreq     = @CPU_SPEED_HZ@

# SWO prescalar
set $swoDiv      = @SERIAL_WIRE_OUTPUT_PRESCALER@

# The ITM ports to enable
set $swoPortMask = 0x1

######################################################################################################################################################
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

######################################################################################################################################################
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

######################################################################################################################################################
# Finished 

# Set GDB language back to auto
set language auto

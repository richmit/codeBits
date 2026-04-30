# -*- Mode:cmake; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      stm32STprogram.cmake
# @author    Mitch Richling http://www.mitchr.me/
# @brief     Program a typical Nuculeo board with an ST-Link probe.@EOL
# @keywords  stm32 cortex-m microcontroller embedded STM32_Programmer_CLI
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
# @todo If we didn't set STM32_PROG_BIN above from the PATH, then try it with the cube bundle manager.@EOL@EOL
# @filedetails
#
#  We expect STM32_Programmer_CLI to be on the PATH.  This is known to be true in two important cases:
#   - Inside of /STM32CubeIDE/ and /STM32Cube for Visual Studio Code Extension/.
#   - When using the /STM32Cube Bundles Manager/ with a "Cube Bundle Project".
#
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Program board

# Search for programmer on the PATH for windows platforms
find_program(STM32_PROG_BIN 
  "STM32_Programmer_CLI.exe"
  PATHS "C:/Program Files/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/")
# Search for programmer on the PATH for MacOS & linux platforms
find_program(STM32_PROG_BIN 
  "STM32_Programmer_CLI"
  PATHS "/opt/ST/STM32Cube/STM32CubeProgrammer"
        "/opt/ST/STM32CubeProgrammer"
        "~/ST/STM32Cube/STM32CubeProgrammer"
        "~/ST/STM32CubeProgrammer"
        "/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin")

# Report Results & Create program targte if we can.
if(EXISTS "${STM32_PROG_BIN}")
  # Program Target Board
  message("-- Found STM32 Programmer binary is ${STM32_PROG_BIN}")
  add_custom_target(program
    COMMAND ${STM32_PROG_BIN} -c port=SWD -w ${PROJECT_NAME}.elf -v -rst
    DEPENDS ${PROJECT_NAME}.elf
    COMMENT "Programming device."
  )
  message("-- 'program' target created.")
else()
  message("-- Unable to find STM32 Programmer binary!")
  message("-- WARNING: No 'program' target will be created.")
  continue()
endif()

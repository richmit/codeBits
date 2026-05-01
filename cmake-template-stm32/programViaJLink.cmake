# -*- Mode:cmake; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      stm32programJLink.cmake
# @author    Mitch Richling http://www.mitchr.me/
# @date      2026-05-01
# @version   VERSION
# @brief     @EOL
# @keywords  
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
# @todo      @EOL@EOL
# @warning   @EOL@EOL
# @bug       @EOL@EOL
# @filedetails
#
#  File details go here.  Multiple paragraphs are fine....
#
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Create program target for J-Link
#
# Look for installed JLink versions on Windows in the default install path
file(GLOB JLINK_ALL_VER
  "C:/Program Files/SEGGER/JLink_V*"
)
#
# Find the newest version of JLink installed
if(JLINK_ALL_VER)
  list(SORT JLINK_ALL_VER)
  list(GET JLINK_ALL_VER -1 JLINK_NEW_VER)
  set(STM32_JLINK_PROG_BIN ${JLINK_NEW_VER}/JLink.exe)
else()
  message(STATUS "No SEGGER J-Link Install Found!")
endif()
#
# Report Results & Create program targte if we can.
if(EXISTS "${STM32_JLINK_PROG_BIN}")
  message(STATUS "Found J-Link binary: ${STM32_JLINK_PROG_BIN}")
  CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/program.jlink.cmake ${CMAKE_BINARY_DIR}/program.jlink)
  add_custom_target(program-jlink
    COMMAND ${STM32_JLINK_PROG_BIN} -NoGui 1 -CommandFile program.jlink 
    DEPENDS ${PROJECT_NAME}.elf
    COMMENT "Programming device with J-Link."
  )
  message(STATUS "'program-jlink' target created.")
else()
  message(STATUS "Unable to find J-Link binary!")
  message(WARNING "No 'program' target will be created.")
endif()

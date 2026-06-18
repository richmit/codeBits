# -*- Mode:cmake; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      cuveMXcflagFix.cmake
# @author    Mitch Richling http://www.mitchr.me/
# @brief     Override CMAKE_BUILD_TYPE specific CMAKE_C & CMAKE_CXX flags from the toolchain file.@EOL
# @keywords  stm32 cortex-m microcontroller embedded
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
# @filedetails
#
#  This makes assumptions about what is in the toolchain file provided by CubeMX.  In particular we assume only -O & -g flags were set in these variables.
#  This was true at the time this comment was written for both gcc & clang.
#
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#
# Override CMAKE_BUILD_TYPE specific CMAKE_C & CMAKE_CXX flags from the toolchain file.
set(CMAKE_C_FLAGS_DEBUG     "-Og    -g3")
set(CMAKE_C_FLAGS_RELEASE   "-Ofast -g0")
set(CMAKE_CXX_FLAGS_DEBUG   "-Og    -g3")
set(CMAKE_CXX_FLAGS_RELEASE "-Ofast -g0")

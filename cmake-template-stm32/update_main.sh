#!/usr/bin/env -S bash
# -*- Mode:Shell-script; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      update_main.sh
# @author    Mitch Richling http://www.mitchr.me/
# @date      2026-06-04
# @brief     Updates main.c to call mainly().@EOL
# @keywords  stm32 cubemx
# @std       bash
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
# @bug       This script depends upon the undocumented comment structure in CubeMX generated main.c files.@EOL@EOL
# @filedetails
#
#  Updates .../PROJECT_NAME/Core/Src/main.c to call mainly().  This involves two change:
#    - Adds the call to mainly(); in the main() just before the infinite while loop.
#    - Adds an include for mainly.h in the custom include section.
#
#  Each of the a above changes are accompanied by a timestamp comment on the same line.  The timestamp format is YYYYMMDDhhmmss.
#
#  Each time the script is run, a backup copy of main.c is made to a new file named main..cYYYYMMDDhhmmss.  This timestamp that will be used in the
#  modification comments added to the new version of main.c generated immediately after the backup.
#
#  This script also makes sure the include file and source file for mainly() exist.  Note that we support both C and C++ versions of mainly().
#
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

MAIN_DIR='Mainly'
MAIN_NAM='mainly'

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

DATE=$(date '+%Y%m%d%H%M%S')

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

if [ ! -e Core/Src/main.c ]; then
  echo "ERROR: Could not find Core/Src/main.c"
fi

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

if [ ! -d "$MAIN_DIR" ]; then
  echo "ERROR: Could not find main base directory: '$MAIN_DIR'"
  exit
fi

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

if [ ! -d "$MAIN_DIR/Inc/" ]; then
  echo "ERROR: Could not find main include directory: '$MAIN_DIR/Inc'"
  exit
fi
MAIN_INC_EXT=''
if [ ! -e "${MAIN_DIR}/Inc/${MAIN_NAM}.h" ]; then
  echo "ERROR: Could not find mainly include file."
  exit
fi

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

if [ ! -d "$MAIN_DIR/Src/" ]; then
  echo "ERROR: Could not find main source directory: '$MAIN_DIR/Src'"
  exit
fi
if [ -e "${MAIN_DIR}/Src/${MAIN_NAM}.cpp" -a -e "${MAIN_DIR}/Src/${MAIN_NAM}.c" ]; then
  echo "ERROR: Found both C & C++ versions of mainly source file."
fi
if [ ! \( -e "${MAIN_DIR}/Src/${MAIN_NAM}.cpp" -o -e "${MAIN_DIR}/Src/${MAIN_NAM}.c" \) ]; then
  echo "ERROR: Could not find mainly source file."
  exit
fi

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

INCP='s/(\/\* USER CODE BEGIN Includes \*\/\n)([^\n]*\n)*(\/\* USER CODE END Includes \*\/\n)/\1#include "'$MAIN_NAM'.h  \/* '$DATE' *\/\n\3/g'
CODP='s/(  \/\* USER CODE BEGIN 2 \*\/\n)([^\n]*\n)*(  \/\* USER CODE END 2 \*\/\n)/\1  return '$MAIN_NAM'();  \/* '$DATE' *\/\n\3/g'

cp Core/Src/main.c Core/Src/main.c.$DATE
sed -Ez "$INCP;$CODP;" < Core/Src/main.c.$DATE > Core/Src/main.c

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

echo ' '
echo ' '
echo "INFO: Updated Core/Src/main.c"

echo ' '
ls -l Core/Src/main.c Core/Src/main.c.$DATE

echo ' '
diff -Z Core/Src/main.c.$DATE Core/Src/main.c
echo ' '

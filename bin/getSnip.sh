#!/usr/bin/env -S sh
# -*- Mode:Shell-script; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      getSnip.sh
# @author    Mitch Richling http://www.mitchr.me/
# @brief     Extract part of a file bound by BEGIN/END tags.@EOL
# @std       POSIX sh
# @see       https://github.com/richmit/codeBits/
# @copyright 
#  @parblock
#  Copyright (c) 2025, Mitchell Jay Richling <http://www.mitchr.me/> All rights reserved.
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
#  Use: getSnip.sh <file> <tag_string>
#        
#  This script locates and prints a named "snip" in a given file.
#
#  A "snip" is a set of lines in a file bounded by matching pairs of tags.  It looks like this:
#                SS-BEGIN:tag_string:
#                  .. content in the snip ..
#                SS-END:tag_string:
#  These tags may be proceeded and followed by text on the same line.
#
#  The "tag_string" must match this regular expression: /^[a-zA-Z0-9_-]+$/.  In other words it must a non-empty string entirely composed of alphanumeric
#  characters, underscores, and dashes.  In order for a "snip" to be defined, the "tag_string" must match on the "BEGIN" & "END" lines.  
# 
#  This script will print to standard output everything between the tag lines.  The tag lines themselves are not included.
#
#  No error checking is performed.
#
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
sed -n "/SS-BEGIN:$2:/,/SS-END:$2:/p" $1 | head -n -1 | tail -n '+2'

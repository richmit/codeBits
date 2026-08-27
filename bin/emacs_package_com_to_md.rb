#!/usr/bin/env -S ruby
# -*- Mode:ruby; Coding:us-ascii; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      emacs_package_com_to_md.rb
# @author    Mitch Richling https://www.mitchr.me/
# @brief     Read an Emacs package elisp source code file, extract the "Commentary" section, and print it to STDOUT.@EOL
# @std       Ruby 3
# @see       https://github.com/richmit/codeBits
# @copyright 
#  @parblock
#  Copyright (c) 2026, Mitchell Jay Richling <https://www.mitchr.me/> All rights reserved.
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
commentary = ''
looking_for_start = true
open(ARGV[0], "r") do |file|
   file.each_line do |line|
     if (looking_for_start) then
       if (line.match(/^;;; Commentary:/)) then
         looking_for_start = false
       end
     else
       if (line.match(/^;;;/)) then
         break
       else
         commentary += line.sub(/^;+ ?/, '').gsub(/`([a-zA-Z0-9_-]+)'/, '`\1`')
       end
     end
   end
end
puts commentary.gsub(/\A(^ *[\n\r]+)+/m, '').gsub(/(^ *[\n\r]+)+\Z/m, '').gsub(/^\* /, "# ").gsub(/^\*\* /, "## ")

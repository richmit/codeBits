# -*- Mode:cmake; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      IncludePROJECT_NAMELib.cmake
# @author    Mitch Richling http://www.mitchr.me/
# @date      2025-01-27
# @brief     Include PROJECT_NAME config.@EOL
# @std       cmake
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
#  The PROJECT_NAME project's CMakeLists.txt file will export a CMake configuration file named PROJECT_NAMELib.cmake into the build directory.  If a project needs
#  to use PROJECT_NAME, then it may simply include this file into its CMakeLists.txt.
#
#  I keep dependent repositories I have authored in the same base directory, and I always use a build directory called 'build'.  While this makes it super
#  simple for me to pull in include files using a fixed relative path, it also complicates matters for people trying to use my code.  This include file
#  contains a bit of code that looks for project dependencies using my preferred conventions, but provides for a bit of simple configuration and produces a
#  far more meaningful error message.
#
#  An absolute path to the PROJECT_NAMELib.cmake file may be specified on the cmake command line with an option like this:
#
#         -DPROJECT_NAME_PATH=/full/path/to/the/file/PROJECT_NAMELib.cmake
#
#  Note the PATHS argument for find_file can be used to hard code the location of the PROJECT_NAMELib.cmake file into the CMakeLists.txt file.
#
#  This code sets some variables:
#   - PROJECT_NAME_PATH will be set to PROJECT_NAME_PATH-NOTFOUND if the file is not found.  This can be useful if you wish to replace the FATAL_ERROR message 
#     with some other action.
#   - PROJECT_NAME_INCLUDE will be set to the include path for PROJECT_NAME.  As PROJECT_NAME is a header only library, this is all the data you need to use it.
#
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
find_file(PROJECT_NAME_PATH "PROJECT_NAMELib.cmake" PATHS "PROJECT_NAME/build"  "../PROJECT_NAME/build")
if(NOT PROJECT_NAME_PATH STREQUAL "PROJECT_NAME_PATH-NOTFOUND")
  message(STATUS "Found PROJECT_NAME: ${PROJECT_NAME_PATH}")
  include("${PROJECT_NAME_PATH}")
  get_target_property(PROJECT_NAME_INCLUDE PROJECT_NAME INTERFACE_INCLUDE_DIRECTORIES)
else()
  message(FATAL_ERROR " PROJECT_NAME Search Failed!\n"
                      "     The PROJECT_NAME repository must be located in the same directory as this repository,\n"
                      "     and must be configured with a build directory named 'build' at the root of the \n"
                      "     PROJECT_NAME repository.  That is to say, do the following in the same directory \n"
                      "     where you cloned this repository: \n"
                      "        git clone 'https://github.com/richmit/PROJECT_NAME.git'\n"
                      "        cd PROJECT_NAME/build                                  \n"
                      "        cmake ..                                            \n"
                      "        cd ../..                                            \n"
                      "     Then return to this repository, and try to configure it again.\n")
endif()

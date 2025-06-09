# -*- Mode:cmake; Coding:us-ascii-unix; fill-column:158 -*-
#########################################################################################################################################################.H.S.##
##
# @file      include_doxygen-targets.cmake
# @author    Mitch Richling http://www.mitchr.me/
# @date      2025-02-03
# @brief     Create doxygen targets.@EOL
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
#########################################################################################################################################################.H.E.##

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
if(Doxygen_FOUND)
  foreach(DOXINPUT IN ITEMS SRCP)
    message(STATUS "Generateing doxygen generation target for ${DOXINPUT}")
    CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/Doxyfile.cmake ${CMAKE_BINARY_DIR}/doc-${DOXINPUT}/Doxyfile)
    set(DOXSRCF "doc-${DOXINPUT}")
    file(GLOB TMP LIST_DIRECTORIES false "${CMAKE_SOURCE_DIR}/${DOXINPUT}/[a-zA-Z0-9]*.?pp")
    list(APPEND DOXSRCF ${TMP})
    file(GLOB TMP LIST_DIRECTORIES false "${CMAKE_SOURCE_DIR}/${DOXINPUT}/[a-zA-Z0-9]*.f90")
    list(APPEND DOXSRCF ${TMP})
    list(APPEND TARGETS_DOX_GENERATE doc-${DOXINPUT})
    add_custom_target(doc-${DOXINPUT}
      DEPENDS ${DOXSRCF}
      COMMAND ${DOXYGEN_EXECUTABLE} > dox.out
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/doc-${DOXINPUT}
      COMMENT "Generating ${DOXINPUT} documentation with Doxygen"
      VERBATIM)
    if(EXISTS "c:/Users/richmit/MJR/WWW/site/SS/PROJECT_NAME/doc-${DOXINPUT}/")
      message(STATUS "Generateing doxygen publish target for ${DOXINPUT}")
      list(APPEND TARGETS_DOX_INSTALL "install-doc-${DOXINPUT}")
      add_custom_target("install-doc-${DOXINPUT}"
        DEPENDS ${DOXSRCF}
        COMMAND  rsync -rlt --log-format=%f --stats --delete --delete-excluded --modify-window=2 "doc-${DOXINPUT}/" "/c/Users/richmit/MJR/WWW/site/SS/PROJECT_NAME/doc-${DOXINPUT}"
        COMMENT "Put ${DOXINPUT} data in web site directory")
    endif()
  endforeach(DOXINPUT)
  if(TARGETS_DOX_GENERATE)
    add_custom_target(doc-all
      DEPENDS ${TARGETS_DOX_GENERATE}
      COMMENT "Generateing all doxygen documentation"
    )
  endif()
  if(TARGETS_DOX_INSTALL)
    add_custom_target(install-doc-all
      DEPENDS ${TARGETS_DOX_INSTALL}
      COMMENT "Running all doxygen web site targets"
    )
  endif()
else()
  message(STATUS "Warning: Doxygen not found.  No documentation targets!")
endif()

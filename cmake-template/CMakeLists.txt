######################################################################################################################################################
######################################################################################################################################################
cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

######################################################################################################################################################
# Proejct meta data

project(ProjName 
  VERSION 0.0.0.0
  DESCRIPTION "A nice description of the project"
  HOMEPAGE_URL "https://github.com/richmit/ProjName/"
  LANGUAGES CXX)

set(PROJNAME_VERSION_DATE  2024-08-20)
mark_as_advanced(PROJNAME_VERSION_DATE)

######################################################################################################################################################
# Include ctest -- we might not use it if boost is not found...
include(CTest) 

######################################################################################################################################################
# Here are the options we use to modify the build -- these options are passed to cmake like so: cmake -DO_BTEST=YES or -DO_BTEST=NO

OPTION(O_DOXYGEN     "Include support for doxygen"             ON  )
OPTION(O_GTEST       "Include support for Google Test"         ON  )
OPTION(OWNLOAD_GTEST "Download latest Google Test from Github" OFF )

######################################################################################################################################################
# Find tools & libraries used to build targets

if(O_DOXYGEN)
  set(PROJNAME_OPT_DOXYGEN "1")
  find_package(Doxygen)
  if(Doxygen_FOUND)
    set(PROJNAME_FOUND_DOXYGEN "1")
  else()
    set(PROJNAME_FOUND_DOXYGEN "0")
  endif()
else()
  set(PROJNAME_OPT_DOXYGEN "0")
endif()

# CODE GEN: ~/MJR/core/codeBits/bin/src2orgListing ~/core/codeBits/cmake-template/include_gtest.cmake

# CODE GEN: ~/MJR/core/codeBits/bin/src2orgListing ../MRMathCPP/IncludeMRMathCPPLib.cmake 

# CODE GEN: ~/MJR/core/codeBits/bin/src2orgListing ../MRMathCPP/IncludeMRPTreeLib.cmake 

# CODE GEN: ~/MJR/core/codeBits/bin/src2orgListing ../mraster/IncludeMRasterLib.cmake | sed 's/FATAL_ERROR/WARNING/'

######################################################################################################################################################
# Create interface target for the entire project

set(PROJNAME_INCLUDES "lib/MR_rect_tree.hpp")
add_library(ProjName INTERFACE ${PROJNAME_INCLUDES})
#target_include_directories(ProjName INTERFACE ${MRMathCPP_INCLUDE})
target_include_directories(ProjName INTERFACE "${PROJECT_SOURCE_DIR}/lib")

######################################################################################################################################################
# Export the library interface cmake file
export(TARGETS ProjName FILE "${CMAKE_BINARY_DIR}/ProjNameLib.cmake")

######################################################################################################################################################
# Create variable for project includes
get_target_property(ProjName_INCLUDE ProjName INTERFACE_INCLUDE_DIRECTORIES)
message(STATUS "Combined Project Includes: ${ProjName_INCLUDE}")

######################################################################################################################################################
# Create list of targets for examples, functional tests, & unit tests

# CODE GEN: echo 'set(TARGETS_REQ_MRMATHCPP '$(basename -s.cpp $(grep -El '#include "(MRMath[A-Z]+\.hpp)"' */*.cpp || echo '""'))')'
set(TARGETS_REQ_MRMATHCPP "")

# CODE GEN: echo 'set(TARGETS_REQ_CELL '$(basename -s.cpp $(grep -El '#include "(MR_cell_cplx.hpp|MR_rt_to_cc.hpp)"' */*.cpp || echo '""'))')'
set(TARGETS_REQ_CELL "")

# CODE GEN: echo 'set(TARGETS_REQ_BRIDGE '$(basename -s.cpp $(grep -El '#include "(ramCanvas.hpp|MRcolor.hpp)"' */*.cpp || echo '""'))')'
set(TARGETS_REQ_BRIDGE "")

# CODE GEN: echo 'set(TARGETS_REQ_TREE '$(basename -s.cpp $(grep -El '#include "(MR_rect_tree.hpp)"' */*.cpp || echo '""'))')'
set(TARGETS_REQ_TREE "")

# CODE GEN: echo 'set(TARGETS_REQ_MRASTER '$(basename -s.cpp $(grep -El '#include "(ramCanvas.hpp|MRcolor.hpp)"' */*.cpp || echo '""'))')'
set(TARGETS_REQ_MRASTER "")

# CODE GEN: echo 'set(TARGETS_REQ_MRASTER '$(basename -s.cpp $(grep -El '#include <gtest/gtest.h>' */*.cpp || echo '""'))')'
set(TARGETS_REQ_GTEST "")

# Construct list of targets we can build
set(COMBINED_TARGETS ${TARGETS_REQ_CELL} ${TARGETS_REQ_BRIDGE} ${TARGETS_REQ_TREE} ${TARGETS_REQ_MRASTER} ${TARGETS_REQ_GTEST})

# Remove targets needing MRaster if it was not found
if((MRaster_PATH STREQUAL "MRaster_PATH-NOTFOUND") AND TARGETS_REQ_MRASTER)
  list(REMOVE_ITEM COMBINED_TARGETS ${TARGETS_REQ_MRASTER})
  message(WARNING "Example programs and/or unit tests requiring MRaster will NOT be built: ${TARGETS_REQ_MRASTER}!")
endif()

# Remove targets needing GTest if it was not found
if((NOT GTest_FOUND) AND TARGETS_REQ_GTEST)
  list(REMOVE_ITEM COMBINED_TARGETS ${TARGETS_REQ_GTEST})
  message(WARNING "Unit tests requiring GTest will NOT be built: ${TARGETS_REQ_GTEST}!")
endif()

# Zap any duplicates
list(REMOVE_DUPLICATES COMBINED_TARGETS)

######################################################################################################################################################
# Create targets from our target list for each one we can build
# Add a target for each one we can build
foreach(CURTGT IN LISTS COMBINED_TARGETS)
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/examples/${CURTGT}.cpp")
    add_executable(${CURTGT} EXCLUDE_FROM_ALL "examples/${CURTGT}.cpp")
    list(APPEND TARGETS_EXAMPLES ${CURTGT})
  elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/ftests/${CURTGT}.cpp")
    add_executable(${CURTGT} EXCLUDE_FROM_ALL "ftests/${CURTGT}.cpp")
    list(APPEND TARGETS_FTEST ${CURTGT})
  elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/utests/${CURTGT}.cpp")
    add_executable(${CURTGT} EXCLUDE_FROM_ALL "utests/${CURTGT}.cpp")
    list(APPEND TARGETS_UTEST ${CURTGT})
  else()
    message("Warning: Unable to find source for target ${CURTGT}!")
    continue()
  endif()

  target_compile_features(${CURTGT} PUBLIC cxx_std_23)

  # Add build requirements for CELL & BRIDGE
  list (FIND TARGETS_REQ_CELL   ${CURTGT} TMPR1)
  list (FIND TARGETS_REQ_BRIDGE ${CURTGT} TMPR2)
  if((${TMPR1} GREATER -1) OR (${TMPR2} GREATER -1))
    target_include_directories(${CURTGT} PRIVATE "${PROJECT_SOURCE_DIR}/examples-lib3d")
    target_link_libraries(${CURTGT} PRIVATE MRMathCPP)
  endif()

  # Add build requirements for MRPTree
  list (FIND TARGETS_REQ_TREE ${CURTGT} TMPR1)
  if(${TMPR1} GREATER -1)
    target_link_libraries(${CURTGT} PRIVATE MRPTree)
  endif()

  # Add build requirements for MRaster
  list (FIND TARGETS_REQ_MRASTER ${CURTGT} TMPR1)
  if(${TMPR1} GREATER -1)
    target_link_libraries(${CURTGT} PRIVATE MRaster)
  endif()

  # Add build requirements for GTest
  list (FIND TARGETS_REQ_GTEST ${CURTGT} TMPR1)
  if(${TMPR1} GREATER -1)
    target_link_libraries(${CURTGT} PRIVATE GTest::gtest_main)
    add_test(NAME "${CURTGT}" COMMAND "${CURTGT}")
  endif()

  # Compiler specific stuff
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(${CURTGT} PUBLIC -Wall -Wconversion -Wno-unknown-pragmas -Wextra -Wno-deprecated-copy)
    target_compile_options(${CURTGT} PUBLIC -O4)
  elseif((CMAKE_CXX_COMPILER_ID STREQUAL "Clang") OR (CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang"))
    target_compile_options(${CURTGT} PUBLIC -Wall -Wconversion -Wno-unknown-pragmas -Wextra -Wno-sign-conversion)
    target_compile_options(${CURTGT} PUBLIC -O3)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    target_compile_options(${CURTGT} PUBLIC -Wall)
    target_compile_options(${CURTGT} PUBLIC -O3)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    #message("Warning: MSVC support is currently experimental")
  endif()

endforeach(CURTGT)

######################################################################################################################################################

add_custom_target(clean-data
  COMMAND  rm -f *.vtu *.vtp *.vtk *.ply
  COMMENT "Cleaning VTK & PLY files"
)

if(TARGETS_FTEST)
  add_custom_target(ftests
    DEPENDS ${TARGETS_FTEST}
    COMMENT "Building Functional Tests"
  )
  add_custom_target(run-ftests
    DEPENDS ${TARGETS_FTEST}
    COMMENT "Running Functional Tests"
    COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/ftests/run_tests.sh"
  )
endif()

if(TARGETS_UTEST)
  add_custom_target(utests
    DEPENDS ${TARGETS_UTEST}
    COMMENT "Building Unit Tests"
  )
  add_custom_target(run-utests
    DEPENDS ${TARGETS_UTEST}
    COMMENT "Running Unit Tests"
    COMMAND cmake --build . -t test
  )
endif()

if(TARGETS_EXAMPLES)
  add_custom_target(examples
    DEPENDS ${TARGETS_EXAMPLES}
    COMMENT "Building Examples"
  )
endif()

# If we have multiple TARGETS_EXAMPLES_FOO type lists, put them all here so we can build them all at tone time
if(TARGETS_EXAMPLES)
  add_custom_target(examples-all
    DEPENDS ${TARGETS_EXAMPLES}
    COMMENT "Building All Examples"
  )
endif()

######################################################################################################################################################

# CODE GEN: ~/MJR/core/codeBits/bin/src2orgListing ~/core/codeBits/cmake-template/include_doxygen-targets.cmake | sed 's/PROJECT_NAME/ProjName/g; s/SRCP/"lib" "examples"/'
if(Doxygen_FOUND)
  foreach(DOXINPUT IN ITEMS "lib" "examples")
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
    if(EXISTS "c:/Users/richmit/MJR/WWW/site/SS/ProjName/doc-${DOXINPUT}/")
      message(STATUS "Generateing doxygen publish target for ${DOXINPUT}")
      list(APPEND TARGETS_DOX_INSTALL "install-doc-${DOXINPUT}")
      add_custom_target("install-doc-${DOXINPUT}"
        DEPENDS ${DOXSRCF}
        COMMAND  rsync -rlt --log-format=%f --stats --delete --delete-excluded --modify-window=2 "doc-${DOXINPUT}/" "/c/Users/richmit/MJR/WWW/site/SS/ProjName/doc-${DOXINPUT}"
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

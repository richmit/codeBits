#!/bin/bash

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# File lists
 
# These are generated externally, and are something we want to wholesale replace.  To be safe, we want to keep a backup.
BO_FILES='CMakeLists.txt'

# These are files that are static -- they should match what is in the template precisely.
RO_FILES='Mainly/Inc/mainly.h update_main.sh update_from_template.sh CMakeLists.txt cmake_build_templates/run-jlink-swv.sh.cmake cmake_build_templates/program.jlink.cmake cmake_build_templates/swo-go-jlink.gdb.cmake cmake_build_templates/swo-go-stlink.gdb.cmake cmake_build_templates/run-jlink-rttv.sh.cmake cmake_build_templates/rtt-go-openocd.gdb.cmake cmake_build_templates/swo-go-openocd.gdb.cmake cmake_build_templates/openocd-init-stlink.cfg.cmake cmake_build_templates/openocd-init-jlink.cfg.cmake cmake_build_templates/openocd-program.cfg.cmake cmake_build_templates/gdbso-openocd-via-jlink.txt.cmake cmake_build_templates/gdbso-openocd-via-stlink.txt.cmake cmake_build_templates/gdbso-stlink-gdb-server-via-stlink.txt.cmake cmake_build_templates/semihosting-go-openocd.gdb.cmake cmake_build_templates/semihosting-stop-openocd.gdb.cmake cmake_build_templates/semihosting-go-jlink.gdb.cmake cmake_build_templates/swo-stop-jlink.gdb.cmake cmake_build_templates/semihosting-stop-jlink.gdb.cmake cmake_build_templates/semihosting-go-jlink.gdb.cmake cmake_build_templates/reset.jlink.cmake cmake_build_templates/connect.jlink.cmake'

# These are files that are copied to the project on the first run, but never again.  We expect these files will change on a project by project basis.
RW_FILES='tool_config.cmake  Mainly/Src/mainly.cpp'

# These are directories that must exist in the project.
DIRS='Mainly/ Mainly/Src/ Mainly/Inc/ cmake_build_templates/'

# These are git repos we might want synced into each project.
GIT_REPOS='https://github.com/SEGGERMicro/RTT.git'

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
DATE=$(date '+%Y%m%d%H%M%S')

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# If it's missing, create it.
echo 'Directories'
for f in $DIRS; do
  if [ ! -e $f ]; then
    echo '  MISS:' $f
    mkdir $f
  else
    echo '  GOOD:' $f
  fi
done

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# If it exists but is missing the @file tag, then *MOVE* it to a backup file assuming the file was created outside this script
echo 'Backup Externally Generated Files'
for f in $BO_FILES; do
  if [ -e $f ]; then
    if grep -q "@file  *$f *$" $f >/dev/null 2>&1; then
      echo '  GOOD:' $f
    else
      echo '  BACK:' $f
      mv CMakeLists.txt CMakeLists.txt.$DATE
    fi
  else
    echo '  MISS:' $f
  fi
done

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# If it's missing, the copy it into place.
echo 'Read/Write Files'
for f in $RW_FILES; do
  if [ ! -e $f ]; then
    echo '  MISS:' $f
    cp ~/core/codeBits/cmake-template-stm32/$f $f
  else
    echo '  GOOD:' $f
  fi
done

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Update if the file is missing or differs from the template version
echo 'Read Only Files'
for f in $RO_FILES; do
  if [ ! -e $f ]; then
    echo '  MISS:' $f
    cp ~/core/codeBits/cmake-template-stm32/$f $f
  else
    if ! diff -q ~/core/codeBits/cmake-template-stm32/$f $f >/dev/null 2>&1 ; then
      echo '  DIFF:' $f
      cp ~/core/codeBits/cmake-template-stm32/$f $f
    else
      echo '  GOOD:' $f
    fi
  fi
done

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# If it's missing, then clone it.
echo 'GIT Repos'
for repo in $GIT_REPOS; do
  f=$(echo "$repo" | sed 's/^.*\///; s/\.git$//;')
  if [ -e $f ]; then
    if [ -d $f ]; then
      echo '  GOOD:' $f  
    else 
      echo '  SKIP:' $f
    fi
  else
    echo '  MISS:' $f    
    git clone --depth=1 "$repo" >/dev/null 2>&1
  fi
done

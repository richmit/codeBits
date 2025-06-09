#!/bin/bash

# This is just a quick and dirty way to update the configure.sh script across several projects

dirs=(~/world/my_prog/mraster/ ~/world/my_prog/MRMathCPP/ ~/world/my_prog/MRPTree/ ~/world/my_prog/FuncViz/)

for d in ${dirs[*]}; do
  if [ -d $d ]; then
    if diff -q $d/configure.sh configure.sh; then
      echo update_configure_sh.sh: Configure script is up to date: $d
    else
      echo update_configure_sh.sh: Updating configure script: $d
      cp configure.sh $d/configure.sh
    fi
  else
    echo update_configure_sh.sh: Directory missing: $d
  fi
done

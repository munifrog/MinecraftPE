#!/bin/bash

# Retrieve GitHub submodules
if [ -a ".gitmodules" ]; then
  DIR_BASE="$( pwd )"
  DIR_MAIN_SUBMODULE="$( cat .gitmodules | grep "^\s\+path\s=" | sed "s|\\s\+path\\s=\\s||g" )"
  echo -e "Retrieving the latest Nukkit code (${DIR_MAIN_SUBMODULE})"
  git submodule update --init
  if [ -a "${DIR_MAIN_SUBMODULE}/.gitmodules" ]; then
    DIR_SUB_SUBMODULE="$( cat ${DIR_MAIN_SUBMODULE}/.gitmodules | grep "^\s\+path\s=" | sed "s|\\s\+path\\s=\\s||g" )"
    pushd "${DIR_MAIN_SUBMODULE}" > /dev/null
      echo -e "Retrieving the latest Nukkit language files (${DIR_MAIN_SUBMODULE}/${DIR_SUB_SUBMODULE})"
      git submodule update --init
      echo -e "Make \"mvnw\" executable"
      chmod u+x ./mvnw
      echo -e "Compiling Nukkit code into JAR"
      ./mvnw clean package
    popd > /dev/null
    if [ -L "minecraft/nukkit.jar" ]; then
      echo -e "Removing previous \"minecraft/nukkit.jar\" symbolic link"
      rm -rf "minecraft/nukkit.jar"
    fi
    echo "Symbolically linking Nukkit JAR as \"minecraft/nukkit.jar\""
    ln -s "${DIR_BASE}/${DIR_MAIN_SUBMODULE}/target/"nukkit-*.jar "minecraft/nukkit.jar"
  fi
fi

#!/bin/bash

# Load the defined variables
. ${0%/*}/vars.sh

ENABLE_DOWNLOAD=true
if [ $# -gt 0 ]; then
  case ${1} in
    '-c'|'-compile')
    ENABLE_DOWNLOAD=false
  ;;
    '-d'|'-download')
    ENABLE_DOWNLOAD=true
  ;;
  *)
    echo -e "Unvalid option \"${1}\" provided\n  Exiting"
    exit 1
  esac
fi

if [ -L "${DIR_MINECRAFT}/nukkit.jar" ]; then
  echo -e "Removing previous \"${DIR_MINECRAFT}/nukkit.jar\" JAR or symbolic link"
  rm -rf "${DIR_MINECRAFT}/nukkit.jar"
fi

if ${ENABLE_DOWNLOAD}; then
  echo -e "Retrieving last successfully built Nukkit JAR"
  sudo wget --output-document="${DIR_MINECRAFT}/nukkit.jar" "${URL_NUKKIT}"
else
  # Retrieve GitHub submodules
  if [ -e ".gitmodules" ]; then
    DIR_MAIN_SUBMODULE="$( cat .gitmodules | grep "^\s\+path\s=" | sed "s|\\s\+path\\s=\\s||g" )"
    echo -e "Retrieving the latest Nukkit code (${DIR_MAIN_SUBMODULE})"
    git submodule update --init
    if [ -e "${DIR_MAIN_SUBMODULE}/.gitmodules" ]; then
      DIR_SUB_SUBMODULE="$( cat ${DIR_MAIN_SUBMODULE}/.gitmodules | grep "^\s\+path\s=" | sed "s|\\s\+path\\s=\\s||g" )"
      pushd "${DIR_MAIN_SUBMODULE}" > /dev/null
        echo -e "Retrieving the latest Nukkit language files (${DIR_MAIN_SUBMODULE}/${DIR_SUB_SUBMODULE})"
        git submodule update --init
        echo -e "Make \"mvnw\" executable"
        chmod u+x ./mvnw
        echo -e "Compiling Nukkit code into JAR"
        ./mvnw clean package
        echo -e "Restoring \"mvnw\" state"
        git checkout -- mvnw
      popd > /dev/null
      echo "Symbolically linking Nukkit JAR as \"${DIR_MINECRAFT}/nukkit.jar\""
      ln -s "${DIR_BASE}/${DIR_MAIN_SUBMODULE}/target/"nukkit-*.jar "${DIR_MINECRAFT}/nukkit.jar"
    fi
  fi
fi

echo "Restarting service \"${NAME_SERVICE}\""
sudo systemctl restart ${NAME_SERVICE}
systemctl status ${NAME_SERVICE}

#!/bin/bash

# Load the defined variables
. vars.sh

# Don't allow non-root user
if [ "${USER}" == "root" ]; then
  echo -e "Run this script using a non-root user with \"sudo\" privileges!"
  exit 1
fi

# Set up Java
if [ -d "${DIR_JAVA}/bin" ]; then
  echo -e "\"${DIR_JAVA}\" already exists!\nUnnecessary to set up Java again!"
else
  echo -e "Installing Java at \"${DIR_JAVA}\""
  # If not present then download java.tar.gz
  if [ ! -e "${DIR_DOWNLOADS}/${FILE_JAVA}" ]; then
    echo -e "Retrieving \"${DIR_DOWNLOADS}/${FILE_JAVA}\" from \"${URL_JAVA}\""
    sudo wget --output-document="${DIR_DOWNLOADS}/${FILE_JAVA}" "${URL_JAVA}"
    sudo chown ${USER}.${USER} "${DIR_DOWNLOADS}/${FILE_JAVA}"
  fi
  # Install Java using the *.tar.gz file
  if [ -e "${DIR_DOWNLOADS}/${FILE_JAVA}" ]; then
    echo -e "Unpacking \"${FILE_JAVA}\" into \"${DIR_JAVA}\""
    sudo mkdir -p "${DIR_JAVA}"
    sudo chown ${USER}.${USER} "${DIR_JAVA}"
    tar -zxvf "${DIR_DOWNLOADS}/${FILE_JAVA}" -C "${DIR_JAVA}" --strip-components=1
    echo -e "Setting up alternative names for \"java\" and \"javac\""
    sudo update-alternatives --install /usr/bin/java java ${DIR_JAVA}/bin/java 1
    sudo update-alternatives --install /usr/bin/javac javac ${DIR_JAVA}/bin/javac 1
    sudo update-alternatives --config java
    sudo update-alternatives --config javac
    # Successful installation does not require java.tar.gz anymore
    echo -e "Removing \"${DIR_DOWNLOADS}/${FILE_JAVA}\""
    sudo rm -rf "${DIR_DOWNLOADS}/${FILE_JAVA}"
  else
    echo -e "Something went wrong and we do not have \"${DIR_DOWNLOADS}/${FILE_JAVA}\" to install Java with"
    exit 1
  fi
fi

# Retrieve GitHub submodules
if [ -a ".gitmodules" ]; then
  DIR_MAIN_SUBMODULE="$( cat .gitmodules | grep "^\s\+path\s=" | sed "s|\\s\+path\\s=\\s||g" )"
  if [ ! -f "${DIR_MAIN_SUBMODULE}/README.md" ]; then
    echo -e "Initializing the main GitHub submodule (${DIR_MAIN_SUBMODULE})"
    git submodule update --init
  else
    echo -e "Unnecessary to initialize main GitHub submodule (${DIR_MAIN_SUBMODULE}) again!"
  fi
  if [ -a "${DIR_MAIN_SUBMODULE}/.gitmodules" ]; then
    DIR_SUB_SUBMODULE="$( cat ${DIR_MAIN_SUBMODULE}/.gitmodules | grep "^\s\+path\s=" | sed "s|\\s\+path\\s=\\s||g" )"
    if [ ! -d "${DIR_MAIN_SUBMODULE}/${DIR_SUB_SUBMODULE}/eng" ]; then
      echo -e "Initializing the GitHub sub-sub-module (${DIR_MAIN_SUBMODULE}/${DIR_SUB_SUBMODULE})"
      pushd nukkit > /dev/null
      git submodule update --init
      popd > /dev/null
    else
      echo -e "Unnecessary to re-initialize sub-sub-module (${DIR_MAIN_SUBMODULE}/${DIR_SUB_SUBMODULE}) again!"
    fi
  fi
fi

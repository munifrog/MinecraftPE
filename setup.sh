#!/bin/bash

# Load the defined variables
. vars.sh

if [ "${USER}" == "root" ]; then
  echo -e "Run this script using a non-root user with \"sudo\" privileges!"
  exit 1
fi

if [ -d "${DIR_JAVA}/bin" ]; then
  echo -e "\"${DIR_JAVA}\" already exists!\nUnnecessary to set up again!"
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

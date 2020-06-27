#!/bin/bash

DIR_BASE="$( pwd )"
DIR_DOWNLOADS="/home/${USER}"
DIR_JAVA="/opt/jdk8u252"
DIR_MINECRAFT="${DIR_BASE}/minecraft"
DIR_SERVICES="/lib/systemd/system"

VERSION_JAVA="zulu8.46.0.225-ca-jdk8.0.252-linux_aarch64"
FILE_JAVA="${VERSION_JAVA}.tar.gz"
URL_JAVA="https://cdn.azul.com/zulu-embedded/bin/${FILE_JAVA}"
URL_NUKKIT="https://ci.nukkitx.com/job/NukkitX/job/Nukkit/job/master/lastSuccessfulBuild/artifact/target/nukkit-1.0-SNAPSHOT.jar"

NAME_SERVICE="minecraftpe.service"

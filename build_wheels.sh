#!/bin/bash

# Build and distribute python wheels for atomsciml

function build_on_manylinux_2_24_x86_64() {
local PARALLEL_NUM=$1
local WITH_TTY=$2
local MODIFY_APT_SOURCES=$3
DOCKER_IMAGE=quay.io/pypa/manylinux_2_24_x86_64
PLAT=manylinux_2_24_x86_64
docker pull "$DOCKER_IMAGE":latest
if [[ ${WITH_TTY} == *true* ]]; then
docker container run -it --rm \
      -e PLAT=$PLAT \
      -v "$(pwd)":/root/atomsciml \
      "$DOCKER_IMAGE":latest bash /root/atomsciml/build_wheels/build_wheels_manylinux_2_24_x86_64.sh -p ${PARALLEL_NUM} -m ${MODIFY_APT_SOURCES}
else
docker container run -i --rm \
      -e PLAT=$PLAT \
      -v "$(pwd)":/root/atomsciml \
      "$DOCKER_IMAGE":latest bash /root/atomsciml/build_wheels/build_wheels_manylinux_2_24_x86_64.sh -p ${PARALLEL_NUM} -m ${MODIFY_APT_SOURCES}
fi  
}

function build_on_manylinux2014_x86_64() {
local PARALLEL_NUM=$1
local WITH_TTY=$2
DOCKER_IMAGE=quay.io/pypa/manylinux2014_x86_64
PLAT=manylinux2014_x86_64
docker pull "$DOCKER_IMAGE":latest
if [[ ${WITH_TTY} == *true* ]]; then
docker container run -it --rm \
      -e PLAT=$PLAT \
      -v "$(pwd)":/root/atomsciml \
      "$DOCKER_IMAGE":latest bash /root/atomsciml/build_wheels/build_wheels_manylinux2014_x86_64.sh -p ${PARALLEL_NUM}
else
docker container run -i --rm \
      -e PLAT=$PLAT \
      -v "$(pwd)":/root/atomsciml \
      "$DOCKER_IMAGE":latest bash /root/atomsciml/build_wheels/build_wheels_manylinux2014_x86_64.sh -p ${PARALLEL_NUM}
fi
}

RUN_CHOICE="manylinux_2_24_x86_64 manylinux2014_x86_64"
PARALLEL_NUM=1
WITH_TTY="true"
MODIFY_APT_SOURCES="true"
while getopts ":r:p:m:t:" arg; do
case ${arg} in
r)
RUN_CHOICE="${OPTARG}"
;;
p)
PARALLEL_NUM="${OPTARG}"
;;
t)
WITH_TTY="${OPTARG}"
;;
m)
MODIFY_APT_SOURCES="${OPTARG}"
;;
esac
done

echo "Running choices ->" ${RUN_CHOICE}
echo "Parallel build number -> " ${PARALLEL_NUM}
echo "With tty -> " ${WITH_TTY}
echo "Whether to modify apt sources list(if applicable) -> " ${MODIFY_APT_SOURCES}

for build_opt in $RUN_CHOICE;do
if [[ ${build_opt} == *manylinux_2_24_x86_64* ]];then
build_on_manylinux_2_24_x86_64 ${PARALLEL_NUM} ${WITH_TTY} ${MODIFY_APT_SOURCES}
elif [[ ${build_opt} == *manylinux2014_x86_64* ]];then
build_on_manylinux2014_x86_64 ${PARALLEL_NUM} ${WITH_TTY}
fi
done

function modify_apt_sources_list() {
cp /etc/apt/sources.list /etc/apt/sources.list.bak
cat >/etc/apt/sources.list<<EOF
deb http://mirrors.aliyun.com/debian stretch main contrib non-free
deb http://mirrors.aliyun.com/debian stretch-proposed-updates main contrib non-free
deb http://mirrors.aliyun.com/debian stretch-updates main contrib non-free
deb http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib
deb-src http://mirrors.aliyun.com/debian stretch main contrib non-free
deb-src http://mirrors.aliyun.com/debian stretch-proposed-updates main contrib non-free
deb-src http://mirrors.aliyun.com/debian stretch-updates main contrib non-free
deb-src http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib
EOF
}

function install_dependencies() {
apt update
apt install -y python3-pip
apt install -y libarmadillo-dev 
apt install -y libboost-all-dev 
apt install -y --fix-missing
apt install -y libboost-program-options-dev libboost-filesystem-dev libboost-system-dev
apt install -y libtorch
}

function start_build() {
# so that pybind11 can be detected by scikit-build
export PATH=$PATH:${HOME}/.local/bin 
local PARALLEL_NUM=$1
for py in cp37-cp37m cp38-cp38 cp39-cp39 cp310-cp310
do
/opt/python/${py}/bin/pip3 install --user scikit-build cython pybind11[global]
done

cd /root/atomsciml/
for py in cp37-cp37m cp38-cp38 cp39-cp39 cp310-cp310
do
# previous build might deteriorate the current build
rm -rf _skbuild
/opt/python/${py}/bin/python3 setup.py bdist_wheel -j ${PARALLEL_NUM}
done

for whl in /root/atomsciml/dist/atomsciml*-linux_*.whl
do
auditwheel repair ${whl} -w /root/atomsciml/dist
done

}

while getopts ":p:m:" arg; do
case ${arg} in
p)
PARALLEL_NUM="${OPTARG}"
;;
m)
MODIFY_APT_SOURCES="${OPTARG}"
;;
esac
done

echo ${PARALLEL_NUM}
echo ${MODIFY_APT_SOURCES}

if [[ ${MODIFY_APT_SOURCES} == *true* ]];then
modify_apt_sources_list
fi

install_dependencies
start_build ${PARALLEL_NUM}

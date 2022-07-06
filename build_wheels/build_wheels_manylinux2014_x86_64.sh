function install_dependencies() {
local PARALLEL_NUM=$1
yum install -y python3-pip
yum install -y armadillo-devel 
yum install -y openssl-devel

yum install -y wget xz
wget -c https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.gz
tar -xf boost_1_78_0.tar.gz
cd boost_1_78_0
./bootstrap.sh
./b2 install -j ${PARALLEL_NUM} --with-program_options --with-filesystem --with-system

yum install -y libtorch
}

function start_build() {
# so that pybind11 can be detected by scikit-build
export PATH=$PATH:${HOME}/.local/bin 
local PARALLEL_NUM=$1
for py in cp37-cp37m cp38-cp38 cp39-cp39 cp310-cp310
do
/opt/python/${py}/bin/pip install --user scikit-build cython pybind11[global]
done

cd /root/atomsciml/
for py in cp37-cp37m cp38-cp38 cp39-cp39 cp310-cp310
do
# previous build might deteriorate the current build
rm -rf _skbuild
/opt/python/${py}/bin/python3 setup.py build bdist_wheel -j ${PARALLEL_NUM}
done

for whl in /root/atomsciml/dist/atomsciml-*-linux_*.whl
do
auditwheel repair ${whl} -w /root/atomsciml/dist
done
}

while getopts ":p:" arg; do
case ${arg} in
p)
PARALLEL_NUM="${OPTARG}"
;;
esac
done

echo ${PARALLEL_NUM}
install_dependencies ${PARALLEL_NUM}
start_build ${PARALLEL_NUM}

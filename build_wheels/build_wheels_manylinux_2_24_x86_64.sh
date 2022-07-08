apt update
apt install -y python3-pip
apt install -y libarmadillo-dev 
apt install -y libboost-all-dev 
apt install -y --fix-missing
apt install -y libboost-program-options-dev libboost-filesystem-dev libboost-system-dev
apt install -y libtorch

# so that pybind11 can be detected by scikit-build
export PATH=$PATH:${HOME}/.local/bin 
for py in cp37-cp37m cp38-cp38 cp39-cp39 cp310-cp310
do
/opt/python/${py}/bin/pip3 install --user scikit-build cython pybind11[global]
done

cd /root/atomsciml/
for py in cp37-cp37m cp38-cp38 cp39-cp39 cp310-cp310
do
rm -rf _skbuild
/opt/python/${py}/bin/python3 setup.py bdist_wheel -j 4}
done

for whl in /root/atomsciml/dist/atomsciml*-linux_*.whl
do
auditwheel repair ${whl} -w /root/atomsciml/dist
done

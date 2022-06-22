# Copyright (c) 2021 DeqiTang
# Distributed under the terms of the MIT license
# @author: DeqiTang
# email: deqi_tang@163.com 

import os
import sys
import re
import subprocess
from glob import glob

import setuptools
#from setuptools import setup
from skbuild import setup  # replace setuptools setup
from setuptools import find_packages, Extension
from setuptools import Command
from setuptools.command.build_ext import build_ext

class CleanCommand(Command):
    """Custom clean command to tidy up the project root."""
    user_options = []
    def initialize_options(self):
        pass
    def finalize_options(self):
        pass
    def run(self):
        os.system('rm -vrf ./build ./dist ./*.pyc ./*.tgz ./*.egg-info')
        os.system("rm -rf _skbuild")

# # -----------------------------
# # make sure pybind11 is working
# # -----------------------------
# try:
#     import pybind11
#     # if there is a pybind11 directory locally in this project, it can be imported.
#     # but that's not the pybind11 package we want
#     # so check pybind11 package validity further
#     if os.path.exists("pybind11"):
#         # see if the truly pybind11 package is installed
#         os.environ["PATH"] = os.environ["PATH"] + ":%s" % os.path.join(os.path.expanduser("~"), ".local/bin")
#         pybind11.get_include()
#     print("using pybind11 version: ", pybind11.version_info)
# except:
#     subprocess.check_call([sys.executable, "-m", "pip", "install", "pybind11[global]"])
#     print("using newly installed pybind11 version: ", pybind11.version_info)

setup(
    name = "atomsciml",
    version = '0.0.0',
    ## python3 setup.py build sdist bdist_wheel
    ## twine upload dist/*
    keywords = ("Atom Science, Machine Learning"),
    description = "machine learning environment for scientific research involving atom.",
    license = "MIT",
    url = "https://gitlab.com/deqitang/atomsciml",
    author_email = "deqi_tang@163.com",
    packages = find_packages(),
    include_package_data = True,
    platforms = "any",
    python_requires = ">=3.0",
    install_requires = ["pybind11", "numpy", "scipy", "matplotlib"],
    cmdclass = {
        'clean': CleanCommand,
        'build_ext': build_ext
    },    
    ext_modules=[
    ],
    # ------------------------------------------
    # cpp extension using scikit-build (working)
    # ------------------------------------------
    cmake_source_dir="./pybind11", # where CMakeLists.txt exists
    cmake_install_dir="atomsciml/cpp", # from atomsciml.cpp import xxx
    cmake_args=["-DCMAKE_BUILD_TYPE=Debug"],
    # ------------------------------------------
    scripts = [
    ],
    entry_points = {
        'console_scripts': [
            "atomsciml = atomsciml.cmd.atomsciml:main",
        ]
    },
)


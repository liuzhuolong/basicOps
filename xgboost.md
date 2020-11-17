## Install XGBoost
- install cmake, version >= 3
  ```shell
  # download cmake source file from https://cmake.org/download/
  # yum install could only install cmake-2.8+, or cmake3
  wget https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4.tar.gz
  tar -zxvf cmake-3.18.4.tar.gz
  cd cmake-3.18.4.tar.gz
  ./bootstrap && make && make install  # default install in `/usr/local/`, see README.rst for help
  ```
- install gcc, version >= 5.0
  ```shell
  
  ```

FROM ubuntu:18.04
# MAINTAINER Proud Heng <proud.heng@gmail.com>

# To build ORB_SLAM2 using this Docker image:
# docker run -v ~/docker/ORB_SLAM2/:/ORB_SLAM2/ -w=/ORB_SLAM2/ slam-test /bin/bash -c ./build.sh

ENV OPENCV_VERSION 3.4.2
ENV OPENCV_DOWNLOAD_URL https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip
ENV OpenCV_DIR opencv-$OPENCV_VERSION
ENV EIGEN_VERSION 3.3.4
# ENV EIGEN_DOWNLOAD_URL http://bitbucket.org/eigen/eigen/get/$EIGEN_VERSION.tar.gz
ENV EIGEN_DOWNLOAD_URL https://gitlab.com/libeigen/eigen/-/archive/3.3.4/eigen-3.3.4.tar.gz

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  cmake \
  curl \ 
  gcc \
  git \
  libglew-dev \
  libgtk2.0-dev \
  pkg-config \
  libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  python3-dev \
  python3-numpy \
  unzip 

# install OpenCV
RUN curl -fsSL "$OPENCV_DOWNLOAD_URL" -o opencv.zip \
  && unzip opencv.zip \
  && rm opencv.zip \
  && cd $OpenCV_DIR \
  && mkdir release \
  && cd release \
  && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. \
  && make \
  && make install

# install Eigen

# install Pangolin
# RUN git clone https://github.com/stevenlovegrove/Pangolin.git \
#   && cd Pangolin \
#   && mkdir build \
#   && cd build \
#   && cmake .. \
#   && make

RUN git clone https://github.com/stevenlovegrove/Pangolin.git --branch v0.5 \
  && cd Pangolin \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make

  
RUN curl -fsSL "$EIGEN_DOWNLOAD_URL" -o eigen.tar.gz \
  # && mkdir /usr/include/eigen \
  # rename first directory to be eigen instead of eigen-eigen-*
  && tar -xf eigen.tar.gz  \
  && rm eigen.tar.gz \
  && cd eigen-3.3.4 \
  && mkdir build_dir \
  && cd build_dir \
  && cmake ../ \
  && make install

# build ORB-SLAM2
RUN git clone https://github.com/fi5421/Multi-Edge-SLAM.git Edge-SLAM \
  && cd Edge-SLAM \
  && chmod +x build.sh

RUN apt-get install wget

RUN cd Edge-SLAM \
  && mkdir Vocabulary \
  && cd Vocabulary \
  && wget https://github.com/droneslab/edgeslam/blob/master/Vocabulary/ORBvoc.txt.tar.gz


# problematic boost

# RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.82.0/source/boost_1_82_0.tar.bz2 \
#   && tar --bzip2 -xf boost_1_82_0.tar.bz2 \
#   && cd boost_1_82_0 \
#   && ./bootstrap.sh \
#   && ./b2 install



# VOLUME ["/ORB_SLAM2/"]


# CMD ["/bin/bash -c ./build.sh"]


# 
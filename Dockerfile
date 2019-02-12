FROM ubuntu:16.04

# Update necessary packages
RUN apt-get update && apt-get install -qqy \
    automake \
    apt-utils \
    build-essential \
    git \
    libssl-dev \
    libtool \
    libtool-bin \
    make \
    pkg-config \
    software-properties-common \
    tk-dev \
    wget \
    libcurl4-gnutls-dev

RUN mkdir /dependencies
WORKDIR "/dependencies"

RUN wget -O gsl-2.5.tar.gz ftp://ftp.gnu.org/gnu/gsl/gsl-2.5.tar.gz && \
    tar -xzvf gsl-2.5.tar.gz && \
    cd gsl-2.5 && \
    ./configure && \
    make && make install
WORKDIR "/dependencies"

RUN wget -O nlopt-2.4.2.tar.gz http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz && \
    tar -xzvf nlopt-2.4.2.tar.gz && \
    cd nlopt-2.4.2 && \
    ./configure && \
    make && make install 
WORKDIR "/dependencies"

RUN wget -O htslib-1.8.tar.bz2 https://github.com/samtools/htslib/releases/download/1.8/htslib-1.8.tar.bz2 && \
    tar -xjvf htslib-1.8.tar.bz2 && \
    cd htslib-1.8/ && \
    ./configure --disable-lzma --disable-bz2 && \
    make && make install
WORKDIR "/"


# Install GangSTR - TODO grab specific version
RUN git clone https://github.com/gymreklab/GangSTR.git
WORKDIR "GangSTR"
RUN ./reconf
RUN ./configure CXXFLAGS='-std=c++11'
RUN make && make install
RUN ldconfig

# Install DumpSTR
WORKDIR "/"
RUN git clone https://github.com/gymreklab/STRTools.git

# Grab Mendelian pipeline
WORKDIR "/"
RUN git clone https://github.com/gymreklab/mendelian-repeats-pipeline
WORKDIR "mendelian-repeats-pipeline"
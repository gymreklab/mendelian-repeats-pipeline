FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -qqy git libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev build-essential wget libgmp-dev libmpfr-dev libmpc-dev apt-utils vim software-properties-common

RUN apt-get install -qqy pkg-config make libtool libtool-bin automake zlib1g-dev

RUN git clone https://github.com/gymreklab/GangSTR.git

WORKDIR "GangSTR"
RUN ./reconf
# Generate the configure script
#
# # Compile and install GangSTR
RUN mkdir dependencies

WORKDIR "dependencies"

RUN wget -O gsl-2.5.tar.gz ftp://ftp.gnu.org/gnu/gsl/gsl-2.5.tar.gz && tar -xzvf gsl-2.5.tar.gz && cd gsl-2.5 && ./configure && make && make install


WORKDIR ".."

RUN wget -O nlopt-2.4.2.tar.gz http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz && tar -xzvf nlopt-2.4.2.tar.gz && cd nlopt-2.4.2 && ./configure && make && make install


RUN wget -O htslib-1.8.tar.bz2 https://github.com/samtools/htslib/releases/download/1.8/htslib-1.8.tar.bz2 && tar -xjvf htslib-1.8.tar.bz2 && cd htslib-1.8/ && ./configure --disable-lzma --disable-bz2 && make && make install

WORKDIR "../../"
RUN ./configure
RUN make && make install
RUN ldconfig

WORKDIR "~"

# TODO GangSTR, dumpSTR install

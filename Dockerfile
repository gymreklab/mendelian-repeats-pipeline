FROM gymreklab/str-toolkit-2.4.2

# Install autotools
RUN apt-get install -y autoconf

# Install vcftools
RUN wget https://github.com/vcftools/vcftools/releases/download/v0.1.16/vcftools-0.1.16.tar.gz
RUN tar -xzvf vcftools-0.1.16.tar.gz
WORKDIR vcftools-0.1.16
RUN ./autogen.sh && ./configure && make && make install

# Grab Mendelian pipeline
RUN mkdir /pipeline
ADD run.sh /pipeline/run.sh
ADD utils.sh /pipeline/utils.sh
ADD check_config.sh /pipeline/check_config.sh

WORKDIR /pipeline

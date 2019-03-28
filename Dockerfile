FROM gymreklab/str-toolkit-2.4

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
ADD 1_gangstr.sh /pipeline/1_gangstr.sh
ADD 2_dumpstr.sh /pipeline/2_dumpstr.sh
ADD 3_postmastr.sh /pipeline/3_postmastr.sh

WORKDIR /pipeline

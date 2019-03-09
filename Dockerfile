FROM gymreklab/str-toolkit-2.4

# Grab Mendelian pipeline
RUN mkdir /pipeline
ADD run.sh /pipeline/run.sh
ADD 1_gangstr.sh /pipeline/1_gangstr.sh
ADD 2_dumpstr.sh /pipeline/2_dumpstr.sh
WORKDIR pipeline

FROM gymreklab/str-toolkit

# Grab Mendelian pipeline
RUN mkdir /pipeline
ADD run.sh /pipeline/run.sh
ADD 1_gangstr.sh /pipeline/run.sh
ADD 2_dumpstr.sh /pipeline/run.sh
WORKDIR pipeline

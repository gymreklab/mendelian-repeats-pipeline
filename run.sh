#!/bin/bash

# Usage: ./run.sh <configfile>

source utils.sh
export -f die
export -f log
export -f run_gangstr_chrom
export -f run_dumpstr_chrom
export -f run_postmastr_chrom

CONFIG="$1"
if [ -x ${CONFIG} ]; then
    die "No config file specified"
fi
./check_config.sh ${CONFIG} || die "Errors found in config file"
source ${CONFIG}

for chrom in ${CHROMS}; do echo $chrom; done > ${OUTPREFIX}.chroms

log "########## GangSTR started ##########"
cat ${OUTPREFIX}.chroms | xargs -n1 -I% -P${THREADS} sh -c "run_gangstr_chrom % ${CONFIG}" || die "GangSTR error"
log "########## GangSTR ended ##########"

log "########## dumpSTR started ##########"
cat ${OUTPREFIX}.chroms | xargs -n1 -I% -P${THREADS} sh -c "run_dumpstr_chrom % ${CONFIG}" || die "dumpSTR error"
log "########## dumpSTR ended ##########"

log "########## postmaSTR started ##########"
cat ${OUTPREFIX}.chroms | xargs -n1 -I% -P${THREADS} sh -c "run_postmastr_chrom % ${CONFIG}" || die "postmaSTR error"
log "########## postmaSTR ended ##########"

log "########## Merging postmaSTR output ##########"
vcf-concat $(ls ${OUTPREFIX}.*.candidates.sorted.vcf.gz) | vcf-sort 2>/dev/null | bgzip -c > ${OUTPREFIX}_merged_candidates.vcf.gz || die "Error merging postmastr"
tabix -p vcf ${OUTPREFIX}_merged_candidates.vcf.gz || die "Error indexing postmastr"
log "Merged postmaSTR output finished in ${OUTPREFIX}_merged_candidates.vcf.gz"

log "########## Prioritizing candidates ##########"
# TODO

log "Done!"

exit 0

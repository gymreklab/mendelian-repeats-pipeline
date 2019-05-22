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
./test_config.sh ${CONFIG} || die "Errors found in config file"
source ${CONFIG}

for chrom in ${CHROMS}; do echo $chrom; done > ${OUTPREFIX}.chroms

log "$(date '+%Y %b %d %H:%M') GangSTR started "
cat ${OUTPREFIX}.chroms | xargs -n1 -I% -P${THREADS} sh -c "run_gangstr_chrom % ${CONFIG}" || die "GangSTR error"
log "$(date '+%Y %b %d %H:%M') GangSTR ended"

log "$(date '+%Y %b %d %H:%M') dumpSTR started "
cat ${OUTPREFIX}.chroms | xargs -n1 -I% -P${THREADS} sh -c "run_dumpstr_chrom % ${CONFIG}" || die "dumpSTR error"
log "$(date '+%Y %b %d %H:%M') dumpSTR ended"

log "$(date '+%Y %b %d %H:%M') postmaSTR started "
cat ${OUTPREFIX}.chroms | xargs -n1 -I% -P${THREADS} sh -c "run_postmastr_chrom % ${CONFIG}" || die "postmaSTR error"
log "$(date '+%Y %b %d %H:%M') postmaSTR ended"

exit 0

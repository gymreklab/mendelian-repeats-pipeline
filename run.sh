#!/bin/bash

# Usage: ./run.sh <configfile>

CONFIG=$1
if [ -x ${CONFIG} ]; then
    die "No config file specified"
fi
source ${CONFIG}

############# Load functions ###############

export PROGNAME="GangSTRPipeline"

log()
{
    echo -e "[\e[32m${PROGNAME}-LOG\e[39m] $(date '+%Y %b %d %H:%M') $1" >&2
}
export -f log

die()
{
    echo -e "[\e[31m${PROGNAME}-ERROR\e[39m] $(date '+%Y %b %d %H:%M') $1" >&2
    exit 1
}
export -f die

run_gangstr_chrom() {
    chrom=$1
    config=$2
    source $config
    GangSTR \
	--bam $BAMS \
	--ref $REFFA \
	--regions $REGIONS \
	--out ${OUTPREFIX}.${chrom} \
	--str-info $STRINFO \
        --chrom ${chrom} --quiet $OPTGANGSTR || die "Error running GangSTR"    
    cat ${OUTPREFIX}.${chrom}.vcf | bgzip -c > ${OUTPREFIX}.${chrom}.vcf.gz || die "Error zipping GangSTR output"
    log "Output GangSTR results to ${OUTPREFIX}.${chrom}.vcf.gz"
}
export -f run_gangstr_chrom

run_dumpstr_chrom() {
    chrom=$1
    config=$2
    source ${config}
    dumpSTR \
	--vcf ${OUTPREFIX}.${chrom}.vcf.gz \
	--min-call-DP ${MINCOV} \
	--max-call-DP ${MAXCOV} \
	--expansion-prob-het ${EXPHET} \
	--out ${OUTPREFIX}.${chrom}.filtered \
        --drop-filtered $OPTDUMPSTR || die "Error running dumpSTR"
    cat ${OUTPREFIX}.${chrom}.filtered.vcf | vcf-sort 2>/dev/null | bgzip -c > ${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz || die "Error zipping dumpSTR output"
    tabix -p vcf ${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz || die "Error indexing dumpSTR output"
    log "Output DumpSTR results to ${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz"
}
export -f run_dumpstr_chrom

run_postmastr_chrom() {
    chrom=$1
    config=$2
    source ${config}
    postmaSTR \
	--vcf ${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz \
	--fam ${FAMFILE} \
	--out ${OUTPREFIX}.${chrom}.candidates \
	--affec-min-expansion-prob-het ${AFFECMINHET} \
	--unaff-max-expansion-prob-total ${UNAFFMAXTOT} &>/dev/null || die "Error running postmaSTR"
    cat ${OUTPREFIX}.${chrom}.candidates.vcf | vcf-sort 2>/dev/null | bgzip -c > ${OUTPREFIX}.${chrom}.candidates.sorted.vcf.gz || die "Error zipping postmastr output"
    tabix -p vcf ${OUTPREFIX}.${chrom}.candidates.sorted.vcf.gz || die "Error indexing postmastr output"
    log "Output PostmaSTR results to ${OUTPREFIX}.${chrom}.candidates.sorted.vcf.gz"
}
export -f run_postmastr_chrom

############# Check config file ############
if [ -z $BAMS ]; then
    die "no BAMS specified"
fi

if [ -z $REFFA ]; then
    die "no REFFA file specified"
fi
 
if [ -z $REGIONS ]; then
    die "no REGIONS file specified"
fi

if [ -z $STRINFO ]; then
    die "no STRINFO file specified"
fi

if [ -z $OUTPREFIX ]; then
    die "no OUTPREFIX specified"
fi

############# Call pipeline ################

for chrom in ${CHROMS}; do echo $chrom; done > ${OUTPREFIX}.chroms

log "########## GangSTR started ##########"
cat ${OUTPREFIX}.chroms | xargs -n1 -I% -P${THREADS} bash -c "run_gangstr_chrom % ${CONFIG}" || die "GangSTR error"
log "########## GangSTR ended ##########"

log "########## dumpSTR started ##########"
cat ${OUTPREFIX}.chroms | xargs -n1 -I% -P${THREADS} bash -c "run_dumpstr_chrom % ${CONFIG}" || die "dumpSTR error"
log "########## dumpSTR ended ##########"

log "########## postmaSTR started ##########"
cat ${OUTPREFIX}.chroms | xargs -n1 -I% -P${THREADS} bash -c "run_postmastr_chrom % ${CONFIG}" || die "postmaSTR error"
log "########## postmaSTR ended ##########"

log "########## Merging postmaSTR output ##########"
vcf-concat $(ls ${OUTPREFIX}.*.candidates.sorted.vcf.gz) | vcf-sort 2>/dev/null | bgzip -c > ${OUTPREFIX}_merged_candidates.vcf.gz || die "Error merging postmastr"
tabix -p vcf ${OUTPREFIX}_merged_candidates.vcf.gz || die "Error indexing postmastr"
log "Merged postmaSTR output finished in ${OUTPREFIX}_merged_candidates.vcf.gz"

log "########## Prioritizing candidates ##########"
# TODO

log "Done!"

exit 0

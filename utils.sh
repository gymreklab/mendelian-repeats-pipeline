
PROGNAME="GangSTRPipeline"

log()
{
    echo -e "[\e[32m${PROGNAME}-LOG\e[39m] $(date '+%Y %b %d %H:%M') $1" >&2
}

die()
{
    echo -e "[\e[31m${PROGNAME}-ERROR\e[39m] $(date '+%Y %b %d %H:%M') $1" >&2
    exit 1
}

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

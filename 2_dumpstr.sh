#!/bin/bash
# Usage: ./2_dumpstr.sh <configfile>
set -x
echo $(date '+%Y %b %d %H:%M') dumpSTR started 
THREADS=1
CONFIG="$1"
source $CONFIG

die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

for chrom in ${CHROMS}
do
    cmd="dumpSTR \
	--vcf ${OUTPREFIX}.${chrom}.vcf.gz \
	--min-call-DP ${MINCOV} \
	--max-call-DP ${MAXCOV} \
	--expansion-prob-het ${EXPHET} \
	--out ${OUTPREFIX}.${chrom}.filtered \
        --drop-filtered $OPTDUMPSTR"
    cmd="${cmd}; cat ${OUTPREFIX}.${chrom}.filtered.vcf | vcf-sort | bgzip -c > ${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz; tabix -p vcf ${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz"
    echo ${cmd}
done | xargs -n1 -P${THREADS} -I% sh -c "%"

echo $(date '+%Y %b %d %H:%M') dumpSTR ended


exit 0

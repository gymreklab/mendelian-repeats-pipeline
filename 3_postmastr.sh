#!/bin/bash
# Usage: ./3_postmastr.sh <configfile>

echo $(date '+%Y %b %d %H:%M') postmaSTR started 

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
    cmd="postmaSTR \
	--vcf ${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz \
	--fam ${FAMFILE} \
	--out ${OUTPREFIX}.${chrom}.candidates \
	--affec-min-expansion-prob-het ${AFFECMINHET} \
	--unaff-max-expansion-prob-total ${UNAFFMAXTOT}"
    
    cmd="${cmd}; cat ${OUTPREFIX}.${chrom}.candidates.vcf | vcf-sort | bgzip -c > ${OUTPREFIX}.${chrom}.candidates.sorted.vcf.gz; tabix -p vcf ${OUTPREFIX}.${chrom}.candidates.sorted.vcf.gz"
    echo ${cmd}
done | xargs -n1 -P${THREADS} -I% sh -c "%"

echo $(date '+%Y %b %d %H:%M') postmaSTR ended

exit 0

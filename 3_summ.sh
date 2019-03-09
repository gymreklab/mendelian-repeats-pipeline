#!/bin/bash
# Usage: ./3_summ.sh <configfile>
set -x
echo $(date '+%Y %b %d %H:%M') summarize started 

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
    echo ${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz
done > ${OUTPREFIX}.filtfiles.txt

vcf-concat -f ${OUTPREFIX}.filtfiles.txt | \
    bgzip -c > ${OUTPREFIX}.merged.filtered.vcf.gz
tabix -p vcf ${OUTPREFIX}.merged.filtered.vcf.gz

echo $(date '+%Y %b %d %H:%M') summarize ended


exit 0

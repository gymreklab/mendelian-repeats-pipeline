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

# Concatenate chromosome files
for chrom in ${CHROMS}
do
    echo ${OUTPREFIX}.${chrom}.filtered.sorted.vcf.gz
done > ${OUTPREFIX}.filtfiles.txt
vcf-concat -f ${OUTPREFIX}.filtfiles.txt | \
    bgzip -c > ${OUTPREFIX}.merged.filtered.vcf.gz
tabix -p vcf ${OUTPREFIX}.merged.filtered.vcf.gz

# All unaffected individuals should not PASS
cat ${FAMFILE} | awk '($6==1)' | cut -f 2 > ${OUTPREFIX}.unaffected.txt
cat ${FAMFILE} | awk '($6==2)' | cut -f 2 > ${OUTPREFIX}.affected.txt
bcftools query -S ${OUTPREFIX}.unaffected.txt \
    -f "%CHROM\t%POS\t%INFO/END\t[%FILTER]\n" \
    ${OUTPREFIX}.merged.filtered.vcf.gz | \
    grep -v PASS | grep -v NOCALL | \
    cut -f 1-3 > ${OUTPREFIX}.unaffected.tmp.bed
# Require at least some affecteds to PASS. No nocalls
bcftools query -S ${OUTPREFIX}.affected.txt \
    -f "%CHROM\t%POS\t%INFO/END\t[%FILTER\t%REPCN]\n" \
    ${OUTPREFIX}.merged.filtered.vcf.gz | \
    grep PASS | grep -v "\." | cut -f 1-3 > ${OUTPREFIX}.affected.tmp.bed
intersectBed -a ${OUTPREFIX}.unaffected.tmp.bed \
    -b ${OUTPREFIX}.affected.tmp.bed -f 1 > ${OUTPREFIX}.candidates.bed

# Output original info for each candidate

zcat ${OUTPREFIX}.merged.filtered.vcf.gz | grep "^#" > \
    ${OUTPREFIX}.candidates.vcf
for chrom in ${CHROMS}
do
    intersectBed -a ${OUTPREFIX}.${chrom}.vcf.gz \
	-b ${OUTPREFIX}.candidates.bed
done >> ${OUTPREFIX}.candidates.vcf
bgzip -f ${OUTPREFIX}.candidates.vcf
tabix -p vcf ${OUTPREFIX}.candidates.vcf.gz
bcftools query -f "%CHROM\t%POS\t%INFO/END[\t%REPCN]\n" \
    ${OUTPREFIX}.candidates.vcf.gz | tee ${OUTPREFIX}.candidates.tab

echo $(date '+%Y %b %d %H:%M') summarize ended


exit 0

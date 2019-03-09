#!/bin/bash
# Usage: ./1_gangstr.sh <configfile>
set -x
echo $(date '+%Y %b %d %H:%M') GangSTR started 

THREADS=1 # default 1, overwritten by config file
CONFIG="$1"
source $CONFIG

die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

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

for chrom in ${CHROMS}
do
    cmd="GangSTR \
	--bam $BAMS \
	--ref $REFFA \
	--regions $REGIONS \
	--out ${OUTPREFIX}.${chrom} \
	--str-info $STRINFO \
        --chrom ${chrom} $OPTGANGSTR"
    cmd="${cmd}; bgzip -f ${OUTPREFIX}.${chrom}.vcf"
    echo "${cmd}"
done | xargs -n1 -I% -P${THREADS} sh -c "%"

echo $(date '+%Y %b %d %H:%M') GangSTR ended

exit 0

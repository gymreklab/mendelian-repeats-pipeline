#!/bin/bash
set -x
# Usage: ./1_gangstr.sh <configfile>

echo $(date '+%Y %b %d %H:%M') GangSTR started 

CONFIG="$1"
params=""
source $CONFIG

die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

if [[ -z $bams ]]; then
die "no bam file specified"
fi

if [[ -z $ref ]]; then
die "no ref file specified"
fi
 
if [[ -z $regions ]]; then
die "no regions file specified"
fi


GangSTR --bam $bams \
    --ref $ref \
    --regions $regions \
    --out $out \
    --str-info $strinfo \
    $OPTGANGSTR || die "Error running GangSTR"

echo $(date '+%Y %b %d %H:%M') GangSTR ended

exit 0

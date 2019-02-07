#!/bin/bash

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

if [[ $bams ]]; then
params="--bam "$bams
else 
die "no bam file specified"
fi

if [[ $bamsamps ]]; then
params=$params" --bam-samps "$bamsamps
fi

if [[ $ref ]]; then
params=$params" --ref "$ref
else
die "no ref file specified"
fi
 
if [[ $regions ]]; then
params=$params" --regions "$regions
else
die "no regions file specified"
fi

if [[ $out ]]; then
params=$params" --out "$out
fi

if [[ $strinfo ]]; then
params=$params" --str-info "$strinfo
fi

if [[ $chrom ]]; then
params=$params" --chrom "$chrom
fi

if [[ $period ]]; then
params=$params" --period "$period
fi

echo Parameters used for GangSTR
echo $params

#/home/ryanicky/bin/GangSTR --bam $bams \
#        --bam-samps $bamsamps \
#        --ref $ref \
#        --regions $regions \
#        --out $out \
#        --str-info $strinfo \
#        --chrom $chrom \
#        --period $period \
/home/ryanicky/bin/GangSTR $params || die "Error running GangSTR"

echo $(date '+%Y %b %d %H:%M') GangSTR ended

exit 0 # Not implemented

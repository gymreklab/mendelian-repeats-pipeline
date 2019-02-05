#!/bin/bash

# Usage: ./1_gangstr.sh <configfile>

CONFIG="$1"

source $CONFIG

die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

/home/ryanicky/bin/GangSTR --bam $bams \
        --bam-samps $bamsamps \
        --ref $ref \
        --regions $regions \
        --out $out \
        --str-info $strinfo \
        --chrom $chrom \
        --period $period
|| die "Error running GangSTR"
exit 0 # Not implemented

#!/bin/bash

# Usage: ./2_dumpstr.sh <configfile>

echo $(date '+%Y %b %d %H:%M') dumpSTR started 

CONFIG="$1"
source $CONFIG

die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

if [[ -z $vcf ]]; then
die "no vcf file specified"
fi

if [[ -z $filterregions ]]; then
die "no regions file specified"
fi
 
if [[ -z $filterregionsnames ]]; then
die "no regions names file specified"
fi


/dumpSTR.py \
    --vcf $vcf   \
    --filter-regions $filterregions \
    --filter-regions-names $filterregionsnames \
    --out $outdstr $OPTDUMPSTR || die exit 1 

echo $(date '+%Y %b %d %H:%M') dumpSTR ended


exit 0 # Not implemented

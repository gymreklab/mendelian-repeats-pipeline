#!/bin/bash

# Usage: ./2_dumpstr.sh <configfile>

CONFIG="$1"
params=""
soruce $CONFIG

die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

if [[ $vcf ]]; then
params="--vcf "$vcf
else 
die "no vcf file specified"
fi

if [[ $filterregions ]]; then
params=$params" --filter-regions "$filterregions
else
die "no regions file specified"
fi
 
if [[ $filterregionsnames ]]; then
params=$params" --filter-regions-name "$filterregionsnames
else
die "no regions names file specified"
fi

if [[ $outdstr ]]; then
params=$params" --out "$outdstr
fi

echo $params

./home/ryanicky/workspace/STRTools/scripts/dumpSTR/dumpSTR.py $params || die exit 1

#./home/ryanicky/workspace/STRTools/scripts/dumpSTR/dumpSTR.py --vcf $vcf \
#             --out $outdstr \
#             --filter-regions $filterregions \
#             --filter-regions-names $filterregionsnames \
#             --min-total-reads $mintotalreads


exit 0 # Not implemented

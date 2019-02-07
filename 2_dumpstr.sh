#!/bin/bash

# Usage: ./2_dumpstr.sh <configfile>

echo $(date '+%Y %b %d %H:%M') dumpSTR started 

CONFIG="$1"
params=""
source $CONFIG

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

if [[ $mintotalreads ]]; then
params=$params" --min-total-reads "$mintotalreads
fi

if [[ $expansionprobhet ]]; then
params=$params" --expansion-prob-het "$expansionprobhet
fi

if [[ $expansionprobhom ]]; then
params=$params" --expansion-prob-hom "$expansionprobhom
fi

if [[ $expansionprobtotal ]]; then
params=$params" --expansion-prob-total "$expansionprobtotal
fi

if [[ $filterspanonly ]]; then
params=$params" --filter-span-only "$filterspanonly 
fi

echo Paramters used:
echo $params

/home/ryanicky/workspace/STRTools/scripts/dumpSTR/dumpSTR.py $params || die exit 1

echo $(date '+%Y %b %d %H:%M') dumpSTR ended


exit 0 # Not implemented

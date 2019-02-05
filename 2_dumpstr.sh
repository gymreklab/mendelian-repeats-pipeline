#!/bin/bash

# Usage: ./2_dumpstr.sh <configfile>

CONFIG="$1"

soruce $CONFIG
i
die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

./home/ryanicky/workspace/STRTools/scripts/dumpSTR/dumpSTR.py --vcf $vcf \
             --out $outdstr \
             --filter-regions $filterregions \
             --filter-regions-names $filterregionsnames \
             --min-total-reads $mintotalreads


exit 0 # Not implemented

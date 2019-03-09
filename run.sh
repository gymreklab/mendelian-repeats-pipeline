#!/bin/bash

# Usage: ./run.sh <configfile>

CONFIG="$1"

die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

if [ -x ${CONFIG} ]; then
    die "No config file specified"
fi

./1_gangstr.sh ${CONFIG} || die "Error running GangSTR"
./2_dumpstr.sh ${CONFIG} || die "Error running DumpSTR"
./3_summ.sh ${CONFIG} || die "Error running summarize"

exit 0

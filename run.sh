#!/bin/bash

# Usage: ./run.sh <configfile>

CONFIG="$1"

die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

./1_gangstr.sh $CONFIG || die "Error running GangSTR"
./2_dumpstr.sh $CONFIG || die "Error running DumpSTR"

exit 0

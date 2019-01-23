#!/bin/bash

# Usage: ./1_gangstr.sh <configfile>

CONFIG=$1

die()
{
    BASE=$(basename "$0")
    echo "$BASE error: $1" >&2
    exit 1
}

exit 1 # Not implemented

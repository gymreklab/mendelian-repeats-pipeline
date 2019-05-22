#!/bin/bash

CONFIG=$1
source $CONFIG
source utils.sh

if [ -z $BAMS ]; then
    die "no BAMS specified"
fi

if [ -z $REFFA ]; then
    die "no REFFA file specified"
fi
 
if [ -z $REGIONS ]; then
    die "no REGIONS file specified"
fi

if [ -z $STRINFO ]; then
    die "no STRINFO file specified"
fi

if [ -z $OUTPREFIX ]; then
    die "no OUTPREFIX specified"
fi


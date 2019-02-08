#!/bin/bash

# Usage: ./testrun.sh <configfile>

CONFIG="$1"

echo "reading from config file... " $CONFIG

cat $CONFIG

exit 0

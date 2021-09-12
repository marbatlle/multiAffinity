#!/usr/bin/env bash
set -euo pipefail
#pushd tool/ >& /dev/null

echo 'STEP1 - Finding metaDEGs'
bash bin/metaDEGs/obtain_metaDEGs.sh
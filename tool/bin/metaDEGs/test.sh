#!/usr/bin/env bash
set -euo pipefail

echo '  0/4 - Preparing environment'
## Check presence of required files
if find -- "input/data/counts" -prune -type d -empty | grep -q '^'; then echo 'Add all required input files' | exit 1;fi
if find -- "input/data/metadata" -prune -type d -empty | grep -q '^'; then echo 'Add all required input files' | exit 1;fi
if find -- "input/layers" -prune -type d -empty | grep -q '^'; then echo 'Add all required input files' | exit 1;fi
# prepare directories and files
mkdir -p bin/metaDEGs/src; mkdir -p bin/metaDEGs/src/grein; cp -r input/data/* bin/metaDEGs/src/grein/
pushd bin/metaDEGs/ >& /dev/null
rm -r -f src/tmp; mkdir src/tmp; mkdir src/tmp/counts; mkdir src/tmp/metadata; mkdir src/tmp/degs
rm -r -f output; mkdir output; mkdir output/metaDEGs; mkdir output/normalized_counts

echo '  1/4 - Processing input files'
(cd src/grein/counts && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)
(cd src/grein/metadata && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)

for sid in $(ls src/grein/counts/* | sed "s:src/grein/counts/::" | cut -d"." -f1); do
    cp src/grein/metadata/${sid}.txt src/tmp/grein_meta.txt; cp src/grein/counts/${sid}.txt src/tmp/grein_cts.txt
    Rscript scripts/process_input.R #>& /dev/null
    FILE=src/tmp/clean_cts.txt
    if [ -f "$FILE" ]; then
        :
    else 
        echo "Error, change the non-tumour samples' metadata labels to --> Normal"
        rm -f src/tmp/clean_* ; rm -f src/tmp/grein_*
        exit 1
    fi
    cp src/tmp/clean_cts.txt src/tmp/counts/${sid}_cts.txt; cp src/tmp/clean_meta.txt src/tmp/metadata/${sid}_meta.txt
    rm -f src/tmp/clean_* ; rm -f src/tmp/grein_*
done

popd
#!/usr/bin/env bash
set -euo pipefail

echo '  0/4 - Preparing environment'
mkdir -p bin/metaDEGs/src; mkdir -p bin/metaDEGs/src/grein; cp -r input/data/* bin/metaDEGs/src/grein/
pushd bin/metaDEGs/ >& /dev/null
rm -r -f src/tmp; mkdir src/tmp; mkdir src/tmp/counts; mkdir src/tmp/metadata; mkdir src/tmp/degs
rm -r -f output; mkdir output; mkdir output/metaDEGs; mkdir output/normalized_counts

echo '  1/4 - Processing input files'
## Step 1.1 - clean files

(cd src/grein/counts && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)
(cd src/grein/metadata && ls -v | cat -n | while read n f; do mv -n "$f" "$n.txt"; done)

for sid in $(ls src/grein/counts/* | sed "s:src/grein/counts/::" | cut -d"." -f1); do
    cp src/grein/metadata/${sid}.txt src/tmp/grein_meta.txt; cp src/grein/counts/${sid}.txt src/tmp/grein_cts.txt
    Rscript scripts/process_input.R #>& /dev/null
done


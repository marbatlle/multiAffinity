#!/bin/bash
pushd bin/ >& /dev/null

# remove temp files
rm -r -f Affinity/tmp
rm -f Affinity/src/multiplex/*.tsv

popd >& /dev/null
rm -r bin/Affinity/src/metaDEGs; rm -r bin/Affinity/src/layers; mkdir -p output/MultiAffinity; mv bin/Affinity/output/* output/MultiAffinity
find . -type d -empty -delete
for i in {1..100}
do
 bash 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/scripts/benchmark_communities.sh
 mv 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/optimal_rands_overview.doc 2-HB-DEGs-on-Liver-Communities/2_Communities/Benchmark/output/optimal_rands_overview_${i}.txt
done
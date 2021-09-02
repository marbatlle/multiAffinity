import multixrank
multixrank_obj = multixrank.Multixrank(config="MultiAffinity/src/config_minimal.yml", wdir="MultiAffinity/src")
ranking_df = multixrank_obj.random_walk_rank()
multixrank_obj.write_ranking(ranking_df, path="MultiAffinity/src/output")
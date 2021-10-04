import multixrank
multixrank_obj = multixrank.Multixrank(config="Affinity/src/config_full.yml", wdir="Affinity/src")
ranking_df = multixrank_obj.random_walk_rank()
multixrank_obj.write_ranking(ranking_df, path="Affinity/src/output")
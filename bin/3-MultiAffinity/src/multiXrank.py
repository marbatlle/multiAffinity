import multixrank
multixrank_obj = multixrank.Multixrank(config="3-MultiAffinity/src/config_minimal.yml", wdir="3-MultiAffinity/src")
ranking_df = multixrank_obj.random_walk_rank()
multixrank_obj.write_ranking(ranking_df, path="3-MultiAffinity/src/output")
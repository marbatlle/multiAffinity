## FROM STEP 3.1. Run multiXrank

import argparse
import multixrank

parser = argparse.ArgumentParser()
parser.add_argument('seed', type=str)
args = parser.parse_args()

path_output = ["Affinity/src/output_", args.seed]
path_output = "".join(path_output)

path_config = ["Affinity/src/config_full_", args.seed,".yml"]
path_config = "".join(path_config)



# Run multiXrank
multixrank_obj = multixrank.Multixrank(config=path_config, wdir="Affinity/src")
ranking_df = multixrank_obj.random_walk_rank()
multixrank_obj.write_ranking(ranking_df, path=path_output)
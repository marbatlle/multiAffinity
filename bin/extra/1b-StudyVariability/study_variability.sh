# First, study T vs NT
python 1b-StudyVariability/scripts/join_matrices.py
Rscript 1b-StudyVariability/scripts/umap_T_vs_NT.R

# Now, study both treatments together
python 1b-StudyVariability/scripts/join_matrices_all.py
Rscript 1b-StudyVariability/scripts/umap_T_and_NT.R
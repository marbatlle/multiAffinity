import pandas as pd
import numpy as np
from pandas.core.frame import DataFrame

# NT
StudyA_NT = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyA_NT.csv")
StudyA_NT.index = [x for x in range(1, len(StudyA_NT.values)+1)]
StudyA_NT = StudyA_NT.sample(500)

StudyB_NT = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyB_NT.csv")
StudyB_NT.index = [x for x in range(1, len(StudyB_NT.values)+1)]
StudyB_NT = StudyB_NT.sample(500)

StudyC_NT = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyC_NT.csv")
StudyC_NT.index = [x for x in range(1, len(StudyC_NT.values)+1)]
StudyC_NT = StudyC_NT.sample(500)

StudyD_NT = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyD_NT.csv")
StudyD_NT.index = [x for x in range(1, len(StudyD_NT.values)+1)]
StudyD_NT = StudyD_NT.sample(500)

StudyE_NT = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyE_NT.csv")
StudyE_NT.index = [x for x in range(1, len(StudyE_NT.values)+1)]
StudyE_NT = StudyE_NT.sample(500)

data_NT = pd.concat([StudyA_NT, StudyB_NT, StudyC_NT, StudyD_NT, StudyE_NT], axis=0)

data_NT = data_NT[data_NT.Expression != 0]

data_NT.to_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/NT_grein.csv", index=False)


# T
StudyA_T = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyA_T.csv")
StudyA_T.index = [x for x in range(1, len(StudyA_T.values)+1)]
StudyA_T = StudyA_T.sample(500)

StudyB_T = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyB_T.csv")
StudyB_T.index = [x for x in range(1, len(StudyB_T.values)+1)]
StudyB_T = StudyB_T.sample(500)

StudyC_T = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyC_T.csv")
StudyC_T.index = [x for x in range(1, len(StudyC_T.values)+1)]
StudyC_T = StudyC_T.sample(500)

StudyD_T = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyD_T.csv")
StudyD_T.index = [x for x in range(1, len(StudyD_T.values)+1)]
StudyD_T = StudyD_T.sample(500)

StudyE_T = pd.read_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/StudyE_T.csv")
StudyE_T.index = [x for x in range(1, len(StudyE_T.values)+1)]
StudyE_T = StudyE_T.sample(500)

data_T = pd.concat([StudyA_T, StudyB_T, StudyC_T, StudyD_T, StudyE_T], axis=0)

data_T = data_T[data_T.Expression != 0]

data_T.to_csv("1-Obtaining-DEGs-for-HB/Batch_Effect_Analysis/GREIN_Normalization_Comparison/T_grein.csv", index=False)


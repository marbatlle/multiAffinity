## part 1a. Study Annotation

**Goal:** Obtaining GO terms and KEGG pathways plots for the study.

### Prepare files
To prepare the environment and translate the genes to entrez, run:

    *bash 1a-StudyAnnotation/study_annotation_part1.sh*

### Obtain Annotation Files
Upload files to https://david.abcc.ncifcrf.gov/summary.jsp -> Functional Annotation Tool

* Select GOTerms (BP, CC, MF) - Functional Clustering Tool  -> Download to output/DAVID_output
* Select KEGG Pathways -> Functional Clustering Tool -> Download to output/DAVID_output

### Obtain Annotation Plots

To obtain the annotation plots for both, GO terms and KEGG pathways, run:

    *bash 1a-StudyAnnotation/study_annotation_part2.sh*

### Citations

Huang DW, Sherman BT, Tan Q, Collins JR, Alvord WG, Roayaei J, Stephens R, Baseler MW, Lane HC, Lempicki RA. The DAVID Gene Functional Classification Tool: a novel biological module-centric algorithm to functionally analyze large gene lists. Genome Biol. 2007;8(9):R183. doi: 10.1186/gb-2007-8-9-r183. PMID: 17784955; PMCID: PMC2375021.
# Characterizing aquatic biodiversity in the Peruvian Amazon river using environmental DNA metabarcoding
## This repository contains the files related to the data processing and data analysis for eDNA metabarcoding of fishes in the Peruvian Amazon

### Overview 
The Amazon Basin contains the highest freshwater fish diversity on Earth, with over 2,500 described fish species and an estimated 1,000 undescribed species residing within its rivers. In this project, we test the effectiveness of using environmental DNA (eDNA) approaches to
characterize fish diversity in the western Amazon Basin and examine the factors governing fish biodiversity in this ecosystem. We target a hypervariable region of the 12S rRNA gene to evaluate the biodiversity of fishes across 14 sites in the Peruvian Amazon river.

### Methodological approach
**eDNA sampling:** At each sampling site, we collected triplicate 250 mL surface water samples and one field blank. Environmental measurements characterizing the hydrology and water chemistry of the rivers were taken at each sample point. DNA was extracted and PCR-amplified using a fish-specific mitochondrial 12S rDNA primer pair (MiFish, [Miya et al.](https://royalsocietypublishing.org/doi/10.1098/rsos.150088)). 

**Sequencing:** 
  - Illumina NextSeq 300 bp Mid output kit
  - Sample metadata: (link here)

**Analysis:**
1. Quality control (MultiQC)
   - Script: 
   - Output files: 
   
2. Denoising and error removal (DADA2)
   - Scripts:
   - Output files: 

3. Assign taxonomic information to ASVs (BLASTn)
   - Used [tax_trace.pl](https://github.com/theo-allnutt-bioinformatics/scripts/blob/master/tax_trace.pl) to obtain higher taxonomic information from staxids
   - Scripts:
   - Output files: 

4. Data filtering
   - Removed ASVs with low read counts and non-target taxa
   - Scripts:
   - Output files:

5. Diversity metrics and site comparisons
   - Scripts:
   - Output files: 

6. Comparison to species list
   - Compare species matches to fisheries landings data from ()
   - Scripts:
   - Output files: 

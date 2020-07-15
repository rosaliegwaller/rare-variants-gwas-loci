## Script to select SNPs of interest from GWAS Catalog downloads
# Rosalie G. Waller
# 2020 July 02

## Packages
library("dplyr")

## Read in all studies v1.0.2
## File downloaded from: https://www.ebi.ac.uk/gwas/docs/file-downloads
# Set working directory
setwd("C:/Users/rosal/OneDrive - University of Utah/2020/analyze/data/gwas-candidate-genes")
# Read in file
stdy = read.csv("gwas_catalog_v1.0.2-studies_r2020-06-30.tsv",
                sep = "\t",stringsAsFactors = F)

# List of lymphoid neoplasms to include
TRAITS = c(
  "Nodular sclerosis Hodgkin lymphoma",
  "Large B-cell lymphoma",
  #"Lymphoma",
  "Follicular lymphoma",
  "B cell non-Hodgkin lymphoma",
  "Hodgkin's lymphoma",
  "Diffuse large B cell lymphoma",
  "Mixed cellularity Hodgkin lymphoma",
  "Marginal zone lymphoma",
  "Waldenström macroglobulinemia / lymphoplasmacytic lymphoma",
  "Multiple myeloma",
  "Chronic lymphocytic leukemia"
)
mapped = c(
  "chronic lymphocytic leukemia",
  "nodular sclerosis Hodgkin lymphoma",
  "multiple myeloma",
  "neoplasm of mature B-cells",
  "Hodgkins lymphoma",
  "diffuse large B-cell lymphoma",
  "Hodgkins lymphoma, mixed cellularity",
  "marginal zone B-cell lymphoma",
  "Waldenstrom macroglobulinemia"
  )
 
# select lymphoid neoplasm studies with replication design
tmp = stdy[stdy$DISEASE.TRAIT %in% TRAITS & !is.na(stdy$REPLICATION.SAMPLE.SIZE),]
# select sudies containing European samples
studies = tmp[tmp$INITIAL.SAMPLE.SIZE %>% contains(match = "European",ignore.case = T),]

# list of studies
PMIDS = studies$PUBMEDID

# clean-up
rm(stdy,tmp,TRAITS,mapped)

## Read in list of associations and select studies in PMIDS
## File downloaded from: https://www.ebi.ac.uk/gwas/docs/file-downloads
snps = read.csv("gwas_catalog_v1.0.2-associations_e100_r2020-06-30.tsv",
                sep = "\t",stringsAsFactors = F)

LN.SNPS = snps[snps$PUBMEDID %in% PMIDS,]

# Select SNPs with p < 5x10-8
tmp = LN.SNPS[LN.SNPS$P.VALUE<5e-8,]

# Clean up selection
#loci = tmp[tmp$DISEASE.TRAIT!="Multiple myeloma and monoclonal gammopathy",]
loci = tmp[tmp$DISEASE.TRAIT!="Multiple myeloma and monoclonal gammopathy" & #remove monoclonal gammopathy results
             tmp$SNP_ID_CURRENT!="" & #remove SNPs with no current rsID
             tmp$OR.or.BETA>1 #remove protective associations
           ,]

# clean-up variables
rm(snps,LN.SNPS,tmp)

# save loci table
write.csv(loci,file = "gwas_catalog_v1.0.2-associations_e100_r2020-06-30_SELECTED.tsv")



# Tally associations by disease
#loci %>% group_by(DISEASE.TRAIT) %>% tally()
loci %>% group_by(MAPPED_TRAIT) %>% tally()

# Tally studies by disease
#studies %>% group_by(DISEASE.TRAIT) %>% tally()
studies %>% group_by(MAPPED_TRAIT) %>% tally()

# save snpIDs
rsids = unique(loci$SNPS)
write(x = rsids,file = "gwas_catalog_v1.0.2-associations_e100_r2020-06-30_SELECTED_RSIDS.tsv")


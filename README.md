# Rare Risk Variants at GWAS Loci

An individual with a family history of multiple myeloma is four times as likely to develop the disease, yet the inherited susceptibility is only partially understood. Genome Wide Association Studies (GWAS) have identified common variants that mark genomic locations important for myeloma risk; however, the target genes and the particular functional changes underlying these signals remain largely unknown.  
 
In [Waller et al. (2021)](https://doi.org/10.1093/hmg/ddab066) we are the first to investigate potentially functional rare risk variants at known susceptibility loci proposed in blood cancer GWAS. Our findings implicate six genes in myeloma risk, provide support for a shared genetic etiology across lymphoid neoplasm subtypes, and demonstrate the utility of sequencing genetically enriched cases to identify functional variants at GWAS loci.

Here we provide the code and variants (VCF) that generated the Discovery, Replication, and Extension phase results reported in Waller et al. (2021). Variants within the VCF files are filtered to criteria described in the Methods section of Waller et al. (2021) using BASH scripts. Genomic tools including [bcftools](http://samtools.github.io/bcftools/bcftools.html), [vcftools](http://vcftools.sourceforge.net), and [VEP](https://useast.ensembl.org/info/docs/tools/vep/index.html) are used to annotate, sort, and select samples and variants.

### Description of folders
* setup: scripts that filtered the original myeloma and gnomad VCFs to GWAS 10kb regions
* bed_files: 10kb lymphoid neoplasm GWAS regions and exome sequencing regions
* discovery: variants in the discovery myeloma samples at GWAS loci and filtering scripts
* replication: variants in the replication myeloma samples and filtering scripts
* extensions: variants in the six genes of interest in extension meyloma and CoMMpass samples and filtering scripts

### Relevant Citation
Waller RG, Klein RJ, Vijai J, McKay JD, Clay-Gilmour A, Wei X, Madsen MJ, Sborov DW, Curtin K, Slager SL, Offit K, Vachon CM, Lipkin SM, Dumontet C, Camp NJ. Sequencing at lymphoid neoplasm susceptibility loci maps six myeloma risk genes. Hum Mol Genet. 2021 Mar 5:ddab066. doi: 10.1093/hmg/ddab066. Epub ahead of print. PMID: 33751038.

#!/bin/bash/env bash

filter_vcf_samples_regions (){

	## FILES ##
	VCF=$1
	SAMPLE_LIST=$2
	REGION_BED=$3
	OUT_DIR=$4
	SAMPLE_GROUP=$5
	REGION_TYPE=$6
	mkdir $OUT_DIR

	## FILTER VCF TO SAMPLES AND REGIONS ##
	bcftools view \
	--samples-file $SAMPLE_LIST \
	--regions-file $REGION_BED \
	--output-type v \
	--output-file $OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.vcf \
	$VCF
}

## FILTER UTAH MM VCF TO GWAS REGIONS ##
filter_vcf_samples_regions \
/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/samples-ids-discovery.txt \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-gwas-loci-10kb.bed \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/2020 \
discovery \
gwas-10kb 

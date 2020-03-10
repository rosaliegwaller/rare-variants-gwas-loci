#!/bin/bash/env bash

filter_vcf_samples_regions (){

	## FILES ##
	VCF=$1
	SAMPLE_LIST=$2
	REGION_BED=$3
	OUT_DIR=$4
	SAMPLE_GROUP=$5
	REGION_TYPE=$6
	MIN_AC=$7
	mkdir $OUT_DIR

	## FILTER VCF TO SAMPLES AND REGIONS ##
	bcftools view \
	--samples-file $SAMPLE_LIST \
	--regions-file $REGION_BED \
	--output-type v \
	--output-file $OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.vcf \
	$VCF

	## FILTER TO PASS VARS ##
	bcftools filter \
	--include 'FILTER="PASS"' \
	--output-type v \
	--output $OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.PASS.vcf \
	$OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.vcf 
	
	## FILTER TO MIN AC ##
	bcftools filter \
	--include 'AC>='$MIN_AC \
	--output-type v \
	--output $OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.$MIN_AC.PASS.vcf \
	$OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.PASS.vcf 
	
	## CHECK FILTERS ##
	echo "CHECK PASS FILTER"
	bcftools query -f '%FILTER\n' \
	$OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.$MIN_AC.PASS.vcf \
	| uniq

	echo "CHECK AC FILTER >= "$AC
	bcftools query -f '%AC\n' \
	$OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.$MIN_AC.PASS.vcf \
	| sort -n | head -1

	bcftools stats \
	$OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.$MIN_AC.PASS.vcf \
	| grep 'number of' -m2
}

## FILTER EXTENSION MM/MGUS TO GENES ##
filter_vcf_samples_regions \
/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/samples-ids-extension.txt \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-genes.bed \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/2020 \
extension \
genes \
1 

## FILTER UTAH MM VCF TO GWAS REGIONS ##
filter_vcf_samples_regions \
/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/samples-ids-discovery.txt \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-gwas-loci-10kb.bed \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/2020 \
discovery \
gwas-10kb \
2 

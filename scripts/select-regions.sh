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
	--output-file $OUT_DIR/tmp.vcf \
	$VCF
	
	## FILTER TO MIN AC ##
	bcftools filter \
	--include 'AC>='$MIN_AC \
	--output-type v \
	--output $OUT_DIR/variants-$SAMPLE_GROUP-$REGION_TYPE-AC$MIN_AC.vcf \
	$OUT_DIR/tmp.vcf 

	rm $OUT_DIR/tmp.vcf

	echo "CHECK AC FILTER >= "$AC
	bcftools query -f '%AC\n' \
	$OUT_DIR/variants-$SAMPLE_GROUP-$REGION_TYPE-AC$MIN_AC.vcf \
	| sort -n | head -1

	bcftools stats \
	$OUT_DIR/variants-$SAMPLE_GROUP-$REGION_TYPE-AC$MIN_AC.vcf \
	| grep 'number of' -m2
}

## FILTER DISCOVERY AND SIMULATION SAMPLES TO 10KB REGIONS ##
filter_vcf_samples_regions \
/uufs/chpc.utah.edu/common/home/camp-group2/VCF/2018CampJCFinal/17-12-23_Analysis-Camp-Multi_Cancer_JGT_Final_1525367750.vcf.gz \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/samples-10kb-utah.txt \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-10kb-exome.bed \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files \
discovery \
10kb \
1 

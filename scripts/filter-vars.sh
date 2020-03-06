#!/bin/bash/env bash

filter_vcf_samples_regions (){

	## FILES ##
	VCF=$1
	SAMPLE_LIST=$2
	REGION_BED=$3
	OUT_DIR=$4
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
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
utah.mm \
gwas.10kb.20190312 \
2




	## FILTER TO MIN AC ##
	bcftools filter \
	--include 'AC>='$MIN_AC \
	--output-type v \
	--output $OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.AC$MIN_AC.vcf \
	$OUT_DIR/$SAMPLE_GROUP.$REGION_TYPE.vcf \

	## FILTER TO PASS ONLY ##
	bcftools filter \
	--include 'FILTER="PASS"' \
	--output-type v \
	--output $OUT_DIR/$SAMPLES.$REGIONS.AC$AC.pass.vcf \
	$OUT_DIR/$SAMPLES.$REGIONS.AC$AC.vcf

	echo "CHECK PASS FILTER"
	bcftools query -f '%FILTER\n' \
	$OUT_DIR/$SAMPLES.$REGIONS.AC$AC.pass.vcf \
	| uniq

	echo "CHECK AC FILTER >= "$AC
	bcftools query -f '%AC\n' \
	$OUT_DIR/$SAMPLES.$REGIONS.AC$AC.pass.vcf \
	| sort -n | head -1

	bcftools stats \
	$OUT_DIR/$SAMPLES.$REGIONS.AC$AC.pass.vcf \
	| grep 'number of' -m2

}


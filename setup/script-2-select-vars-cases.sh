#!/bin/bash/env bash

filter_vcf_samples_regions (){

	## FILES ##
	VCF=$1
	DIR=$2
	SAMPLES=$3
	REGIONS=$4
	OUTVCF=$5
	MIN_AC=$6

	mkdir $DIR/tmp

	## FILTER VCF TO SAMPLES AND REGIONS ##
	bcftools view \
	--samples-file $SAMPLES \
	--regions-file $REGIONS \
	--output-type v \
	--output-file $DIR/tmp/tmp.vcf \
	$VCF
	
	## FILTER TO MIN AC ##
	bcftools filter \
	--include 'AC>='$MIN_AC \
	--output-type v \
	--output $OUTVCF \
	$DIR/tmp/tmp.vcf 

	rm -r $DIR/tmp

	echo "CHECK AC FILTER >= "$AC
	bcftools query -f '%AC\n' \
	$OUTVCF | sort -n | head -1

	bcftools stats \
	$OUTVCF | grep 'number of' -m2
}

## FILTER DISCOVERY AND SIMULATION SAMPLES TO 10KB REGIONS ##
filter_vcf_samples_regions \
/uufs/chpc.utah.edu/common/home/camp-group2/VCF/2018CampJCFinal/17-12-23_Analysis-Camp-Multi_Cancer_JGT_Final_1525367750.vcf.gz \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/ \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/setup/samples-discovery.txt \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/discovery/regions-discovery.bed \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/discovery/discovery.vcf \
2

## FILTER REPLICATION SAMPLES TO 6 TARGET GENES ##
filter_vcf_samples_regions \
/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/variants.both.combined.normalized.snpeff.vcf.gz \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/ \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/replication/samples-255-cases.txt \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/replication/regions-replication.bed \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/replication/replication.vcf \
2

## FILTER EXTENSION SAMPLES TO 6 TARGET GENES ##
filter_vcf_samples_regions \
/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/variants.both.combined.normalized.snpeff.vcf.gz \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/ \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/setup/samples-extension.txt \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/extensions/regions-genes.bed \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/extensions/extensions.vcf \
1

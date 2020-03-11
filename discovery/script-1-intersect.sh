#!/bin/bash

VEP=/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/ensembl-vep/vep

intersect_vcfs(){
	DIR=$1
	VCF1=$DIR/$2.vcf
	VCF2=$DIR/$3.vcf
	mkdir $DIR/tmp

	## SORT, ZIP, INDEX FILES ##
	vcf-sort $VCF1 > $DIR/tmp/vcf1-sort.vcf
	bgzip $DIR/tmp/vcf1-sort.vcf
	tabix -p vcf $DIR/tmp/vcf1-sort.vcf.gz

	vcf-sort $VCF2 > $DIR/tmp/vcf2-sort.vcf
	bgzip $DIR/tmp/vcf2-sort.vcf
	tabix -p vcf $DIR/tmp/vcf2-sort.vcf.gz

	## INTERSECT ##
	bcftools isec \
	-p $DIR/tmp \
	--output-type z \
	-n=2 \
	$DIR/tmp/vcf1-sort.vcf.gz \
	$DIR/tmp/vcf2-sort.vcf.gz

	mv $DIR/tmp/0000.vcf.gz $DIR/$2-$3.vcf.gz
	mv $DIR/tmp/0001.vcf.gz $DIR/$3-$2.vcf.gz

	rm -r $DIR/tmp
}

## DISCOVERY ##
intersect_vcfs \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/discovery \
discovery \
gnomad-filtered

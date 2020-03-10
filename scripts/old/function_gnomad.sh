#!/bin/bash/env bash

filter_gnomad_vcf(){
  DIR=$1
  VCF=$2
  SAMPLES=$3
  REGIONS=$4
  NALT=$5
  AF=$6
  POPMAX_AF=$7
  OUT_DIR=$DIR/gwas/vcfs/$SAMPLES
  mkdir $OUT_DIR

  bcftools filter \
  --regions-file $DIR/gwas/beds/$REGIONS.bed \
  --output-type v \
  --output $OUT_DIR/$SAMPLES.$REGIONS.vcf \
  $VCF

  bcftools filter \
  --include 'n_alt_alleles<='$NALT \
  --output-type v \
  --output $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.vcf \
  $OUT_DIR/$SAMPLES.$REGIONS.vcf

  bcftools filter \
  --include 'non_cancer_AF<='$AF \
  --output-type v \
  --output $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.vcf \
  $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.vcf

  bcftools filter \
  --include 'non_cancer_AF_popmax<='$POPMAX_AF \
  --output-type v \
  --output $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.vcf \
  $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.vcf

  bcftools filter \
  --include 'FILTER="PASS"' \
  --output-type v \
  --output $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.pass.vcf \
  $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.vcf

  bcftools filter \
  --exclude 'INFO/segdup=1' \
  --output-type v \
  --output $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.pass.no_segdup.vcf \
  $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.pass.vcf \

  bcftools filter \
  --exclude 'INFO/has_star=1' \
  --output-type v \
  --output $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.pass.no_segdup.no_star.vcf \
  $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.pass.no_segdup.vcf \

  echo "CHECK PASS FILTER"
  bcftools query -f '%FILTER\n' \
  $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.pass.no_segdup.no_star.vcf \
  | uniq

  echo "CHECK POPMAX_AF FILTER < " $POPMAX_AF
  bcftools query -f '%non_cancer_AF_popmax\n' \
  $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.pass.no_segdup.no_star.vcf \
  | awk '{if(max<$1){max=$1}}END{print max}' -

  echo "CHECK AF FILTER < " $AF
  bcftools query -f '%non_cancer_AF\n' \
  $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.pass.no_segdup.no_star.vcf \
  | awk '{if(max<$1){max=$1}}END{print max}' -

  echo "CHECK ALT ALLELES FILTER < " $NALT
  bcftools query -f '%n_alt_alleles\n' \
  $OUT_DIR/$SAMPLES.$REGIONS.n_alt_alleles_$NALT.non_cancer_AF_$AF.non_cancer_AF_popmax_$POPMAX_AF.pass.no_segdup.no_star.vcf \
  | awk '{if(max<$1){max=$1}}END{print max}' -

}

## FILTER GNOMAD TO GWAS 10KB REGIONS ##
#filter_gnomad_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group2/gnomad/r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
#gnomad.exome.r2.1.1 \
#gwas.10kb.20190312 \
#2 \
#0.01 \
#0.05 

## FILTER GNOMAD TO GWAS TOP GENES ##
#filter_gnomad_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group2/gnomad/r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
#gnomad.exome.r2.1.1 \
#gwas.topgenes.20190321 \
#2 \
#0.01 \
#0.05 

## FILTER GNOMAD TO GWAS 20KB REGIONS ##
#filter_gnomad_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group2/gnomad/r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
#gnomad.exome.r2.1.1 \
#gwas.20kb.20190424 \
#20 \
#0.01 \
#0.05 

## FILTER GNOMAD TO GWAS 20KB REGIONS ##
#filter_gnomad_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group2/gnomad/r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
#gnomad.exome.r2.1.1 \
#gwas.20kb.20190424 \
#2 \
#0.01 \
#0.05 

## FILTER GNOMAD TO GWAS 20KB REGIONS ##
#filter_gnomad_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group2/gnomad/r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
#gnomad.exome.r2.1.1 \
#gwas.topgenes.20190513 \
#2 \
#0.01 \
#0.05 

## FILTER GNOMAD TO GWAS TOP GENES ##
filter_gnomad_vcf \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
/uufs/chpc.utah.edu/common/home/camp-group2/gnomad/r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
gnomad.exome.r2.1.1 \
gwas.topgenes.20190520 \
2 \
0.01 \
0.05 

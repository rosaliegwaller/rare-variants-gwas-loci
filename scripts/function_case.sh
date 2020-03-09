#!/bin/bash/env bash

filter_vcf (){

  ## FILES ##
  DIR=$1
  VCF=$2
  SAMPLES=$3
  REGIONS=$4
  AC=$5
  OUT_DIR=$DIR/gwas/vcfs/$SAMPLES
  mkdir $OUT_DIR

  ## FILTER VCF TO SAMPLES AND REGIONS ##
  bcftools view \
  --samples-file $DIR/samples/$SAMPLES.list \
  --regions-file $DIR/gwas/beds/$REGIONS.bed \
  --output-type v \
  --output-file $OUT_DIR/$SAMPLES.$REGIONS.vcf \
  $VCF

  ## FILTER TO MIN AC ##
  bcftools filter \
  --include 'AC>='$AC \
  --output-type v \
  --output $OUT_DIR/$SAMPLES.$REGIONS.AC$AC.vcf \
  $OUT_DIR/$SAMPLES.$REGIONS.vcf

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

## FILTER UTAH MM VCF TO GWAS REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#utah.mm \
#gwas.10kb.20190312 \
#2 

## FILTER UTAH MM VCF TO TOP GENES REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#utah.mm \
#gwas.topgenes.20190321 \
#1

## FILTER CEPH PARENTLESS TO GWAS 10KB REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/VCF/2018CampJCFinal/17-12-23_Analysis-Camp-Multi_Cancer_JGT_Final_1525367750.vcf.gz \
#ceph.parentless \
#gwas.10kb.20190312 \
#1

## FILTER UTAH MM VCF to GWAS 20KB REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#utah.mm \
#gwas.20kb.20190424 \
#1

## FILTER COLLABORATION MM VCF to GWAS 20KB REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#collaboration.mm \
#gwas.20kb.20190424 \
#1

## FILTER COLLABORATION MM VCF to GWAS 20KB REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#collaboration.mm \
#gwas.20kb.20190505 \
#1

## FILTER COLLABORATION MGUS VCF to GWAS 20KB REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#collaboration.mgus \
#gwas.20kb.20190505 \
#1

## FILTER UTAH MM VCF to GWAS 20KB REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#utah.mm \
#gwas.20kb.20190424 \
#2

## FILTER UTAH MM VCF to GWAS 20KB REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group2/VCF/2018CampJCFinal/17-12-23_Analysis-Camp-Multi_Cancer_JGT_Final_1525367750.vcf.gz \
#utah.mm.ugp \
#gwas.20kb.20190424 \
#2

## FILTER UTAH MM TOP GENES ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#utah.mm \
#gwas.topgenes.20190513 \
#1

## FILTER COLLABORATION MM TOP GENES ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#collaboration.mm \
#gwas.topgenes.20190513 \
#1

## FILTER COLLABORATION MGUS TOP GENES ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#collaboration.mgus \
#gwas.topgenes.20190513 \
#1

## FILTER DBGAP MM TOP GENES ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#dbgap.mm \
#gwas.topgenes.20190513 \
#1

## FILTER DBGAP CONTROLS TOP GENES ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#dbgap.control \
#gwas.topgenes.20190513 \
#1

## FILTER DBGAP MM + CONTROLS TOP GENES ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#dbgap.mm.control \
#gwas.topgenes.20190520 \
#1

## FILTER DBGAP MM + CONTROLS TOP GENES ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
#dbgap.mm \
#gwas.topgenes.20190520 \
#1

## FILTER COLLABORATION CONTROLS TOP GENES ##
filter_vcf \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
/uufs/chpc.utah.edu/common/home/camp-group1/MM/rosalie/vcf/mm/variants.both.combined.normalized.snpeff.vcf.gz \
collaboration.controls \
gwas.topgenes.20190520 \
1

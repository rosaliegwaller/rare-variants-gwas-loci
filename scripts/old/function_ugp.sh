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
  --include 'FILTER="PASS" | FILTER="VQSRTrancheINDEL90.00to99.00" | FILTER="VQSRTrancheSNP90.00to99.00"' \
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

## FILTER UTAH MM VCF to GWAS 20KB REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group2/VCF/2018CampJCFinal/17-12-23_Analysis-Camp-Multi_Cancer_JGT_Final_1525367750.vcf.gz \
#utah.mm.ugp \
#gwas.20kb.20190424 \
#2

# FILTER CEPH TO GWAS 20KB REGIONS ##
#filter_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
#/uufs/chpc.utah.edu/common/home/camp-group2/VCF/2018CampJCFinal/17-12-23_Analysis-Camp-Multi_Cancer_JGT_Final_1525367750.vcf.gz \
#ceph.parentless \
#gwas.20kb.20190424 \
#2

# FILTER CEPH TO GWAS 20KB REGIONS ##
filter_vcf \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie \
/uufs/chpc.utah.edu/common/home/camp-group2/VCF/2018CampJCFinal/17-12-23_Analysis-Camp-Multi_Cancer_JGT_Final_1525367750.vcf.gz \
ceph.parentless \
gwas.10kb.20190312 \
2

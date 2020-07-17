#!/bin/bash/env bash
module load bcftools/1.9  
VEP=~/github/ensembl-vep

filter_gnomad_vcf(){
  VCF=$1
  DIR=$2
  REGIONS=$3
  OUTVCF=$4
  NALT=$5
  AF=$6
  POPMAX_AF=$7

  mkdir $DIR/tmp

bcftools filter --regions-file $REGIONS --output-type v $VCF | bcftools filter --include 'n_alt_alleles<='$NALT --output-type v | bcftools filter --include 'non_cancer_AF<='$AF --output-type v | bcftools filter --include 'non_cancer_AF_popmax<='$POPMAX_AF --output-type v | bcftools filter --include 'FILTER="PASS"' --output-type v | bcftools filter --exclude 'INFO/segdup=1' --output-type v | bcftools filter --exclude 'INFO/has_star=1' --output-type v --output $DIR/tmp/tmp.vcf
  
  ## ANNOTATE WITH VEP ##
  $VEP/vep \
  --force_overwrite \
  --input_file $DIR/tmp/tmp.vcf \
  --vcf \
  --cache \
  --dir $VEP \
  --offline \
  --output_file $DIR/tmp/vep.vcf

  ## SELECT HIGH / MODERATE VARS ##
  bcftools filter \
  --include 'INFO/vep[*]~"HIGH"' \
  --output $DIR/tmp/vep.high.vcf.gz \
  --output-type z \
  $DIR/tmp/vep.vcf

  tabix -p vcf $DIR/tmp/vep.high.vcf.gz

  bcftools filter \
  --include 'INFO/vep[*]~"MODERATE"' \
  --output $DIR/tmp/vep.moderate.vcf.gz \
  --output-type z \
  $DIR/tmp/vep.vcf

  tabix -p vcf $DIR/tmp/vep.moderate.vcf.gz

  bcftools concat \
  --allow-overlaps \
  --remove-duplicates \
  --output $OUTVCF \
  --output-type v \
  $DIR/tmp/vep.high.vcf.gz \
  $DIR/tmp/vep.moderate.vcf.gz

echo "CHECK PASS FILTER"
bcftools query -f '%FILTER\n' \
$OUTVCF | uniq

echo "CHECK POPMAX_AF FILTER < " $POPMAX_AF
bcftools query -f '%non_cancer_AF_popmax\n' \
$OUTVCF | awk '{if(max<$1){max=$1}}END{print max}' -

echo "CHECK AF FILTER < " $AF
bcftools query -f '%non_cancer_AF\n' \
$OUTVCF | awk '{if(max<$1){max=$1}}END{print max}' -

echo "CHECK ALT ALLELES FILTER < " $NALT
bcftools query -f '%n_alt_alleles\n' \
$OUTVCF | awk '{if(max<$1){max=$1}}END{print max}' -

rm -r $DIR/tmp
}

## UPDATE 2020-JUL-17 - FILTER GNOMAD TO LD GENES ##
filter_gnomad_vcf \
/uufs/chpc.utah.edu/common/HIPAA/proj_camp/shared/tools/gnomad.r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
~/github/rare-variants-gwas-loci \
~/github/rare-variants-gwas-loci/bed_files/regions-discovery-v2.bed \
~/github/rare-variants-gwas-loci/discovery/gnomad-filtered-v2.vcf \
2 \
0.01 \
0.05 

## FILTER GNOMAD TO GWAS 10KB REGIONS ##
#filter_gnomad_vcf \
##/uufs/chpc.utah.edu/common/home/camp-group2/gnomad/r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/discovery/regions-discovery.bed \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/discovery/gnomad-filtered.vcf \
#2 \
#0.01 \
#0.05 

## FILTER GNOMAD TO REPLICATION REGIONS ##
#filter_gnomad_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/gnomad/r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/replication/regions-replication.bed \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/replication/gnomad-filtered.vcf \
#2 \
#0.01 \
#0.05 

## FILTER GNOMAD TO GENES ##
#filter_gnomad_vcf \
#/uufs/chpc.utah.edu/common/home/camp-group2/gnomad/r2.1.1/gnomad.exomes.r2.1.1.sites.vcf.bgz \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/extensions/regions-genes.bed \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/extensions/gnomad-filtered.vcf \
#2 \
#0.01 \
#0.05 

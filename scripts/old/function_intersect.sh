#!/bin/bash

intersect_vcfs(){
  VCF1=$1
  NAME=${VCF1##*/}
  NAME1=${NAME%.*}
  ZIP1=$2
  
  VCF2=$3
  NAME=${VCF2##*/}
  NAME2=${NAME%.*}
  ZIP2=$4

  OUTDIR=/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/$NAME1.$NAME2
  mkdir $OUTDIR

  VEP=/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/ensembl-vep/vep

  ## SORT, ZIP, INDEX FILES ##
  if [[ $ZIP1 -eq 1 ]]; then
    vcf-sort $VCF1 > $VCF1-sort.vcf
    bgzip $VCF1-sort.vcf
    tabix -p vcf $VCF1-sort.vcf.gz
  fi
  VCF1=$VCF1-sort.vcf.gz
  
  if [[ $ZIP2 -eq 1 ]]; then
    vcf-sort $VCF2 > $VCF2-sort.vcf
    bgzip $VCF2-sort.vcf
    tabix -p vcf $VCF2-sort.vcf.gz
  fi  
  VCF2=$VCF2-sort.vcf.gz

  ## INTERSECT ##
  bcftools isec \
  -p $OUTDIR \
  --output-type z \
  -n=2 \
  $VCF1 \
  $VCF2
}

## UTAH + GNOMAD GWAS 10KB REGIONS ##
#intersect_vcfs \
#  utah.mm \
#  utah.mm.gwas.10kb.20190312.AC1.pass.vcf \
#  1 \
#  gnomad.exome.r2.1.1 \
#  gnomad.exome.r2.1.1.gwas.10kb.20190312.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.vcf \
#  1 \
#  gwas.10kb.20190312 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs

## UTAH + GNOMAD GWAS TOP GENES ##
#intersect_vcfs \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/utah.mm/utah.mm.gwas.topgenes.20190321.AC1.pass.vcf \
#  1 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.topgenes.20190321.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.vcf \
#  0 \

## CEPH + GNOMAD GWAS 10KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/ceph.parentless/ceph.parentless.gwas.10kb.20190312.AC1.pass.vcf \
#0 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.10kb.20190312.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.vcf \
#0

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/utah.mm/utah.mm.gwas.20kb.20190424.AC1.pass.vcf \
#  0 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.vcf \
#  0 \

## COLLABORATION MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/collaboration.mm/collaboration.mm.gwas.20kb.20190424.AC1.pass.vcf \
#  0 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.vcf \
#  0 \

## COLLABORATION MGUS + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/collaboration.mgus/collaboration.mgus.gwas.20kb.20190424.AC1.pass.vcf \
#  1 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_20.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.vcf \
#  0 \

## COLLABORATION MGUS + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/collaboration.mgus/collaboration.mgus.gwas.20kb.20190505.AC1.pass.vcf \
#  1 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.vcf \
#  0 \

## COLLABORATION MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/collaboration.mm/collaboration.mm.gwas.20kb.20190505.AC1.pass.vcf \
#  1 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.vcf \
#  0 \

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/utah.mm/utah.mm.gwas.20kb.20190424.AC2.pass.vcf \
#  1 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.vcf \
#  0 \

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/utah.mm.ugp/utah.mm.ugp.gwas.20kb.20190424.AC2.pass.vcf \
#  1 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#  1 \

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/utah.mm/utah.mm.gwas.20kb.20190424.AC2.pass.vcf \
#  0 \
#  /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#  0 \

## CEPH + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/ceph.parentless/ceph.parentless.gwas.20kb.20190424.AC2.pass.vcf \
#1 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#0 \

## COLLABORATION MGUS + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/collaboration.mgus/collaboration.mgus.gwas.20kb.20190505.AC1.pass.vcf \
#0 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#0 \

## COLLABORATION MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/collaboration.mm/collaboration.mm.gwas.20kb.20190505.AC1.pass.vcf \
#0 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#0 \

## CEPH + GNOMAD GWAS 10KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/ceph.parentless/ceph.parentless.gwas.10kb.20190312.AC2.pass.vcf \
#1 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#0 \

## UTAH MM + GNOMAD TOP GENES ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/utah.mm/utah.mm.gwas.topgenes.20190513.AC1.pass.vcf \
#1 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#1 \

## COLLABORATION MM + GNOMAD TOP GENES ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/collaboration.mm/collaboration.mm.gwas.topgenes.20190513.AC1.pass.vcf \
#1 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#0 \

## COLLABORATION MGUS + GNOMAD TOP GENES ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/collaboration.mgus/collaboration.mgus.gwas.topgenes.20190513.AC1.pass.vcf \
#1 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#0 \

## DBGAP MM + GNOMAD TOP GENES ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/dbgap.mm/dbgap.mm.gwas.topgenes.20190513.AC1.pass.vcf \
#1 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#0 \

## DBGAP CONTOL + GNOMAD TOP GENES ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/dbgap.control/dbgap.control.gwas.topgenes.20190513.AC1.pass.vcf \
#1 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#0 \

## DBGAP MM / CONTOL + GNOMAD TOP GENES ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/dbgap.mm.control/dbgap.mm.control.gwas.topgenes.20190520.AC1.pass.vcf \
#1 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#1 \

## DBGAP MM + GNOMAD TOP GENES ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/dbgap.mm/dbgap.mm.gwas.topgenes.20190520.AC1.pass.vcf \
#1 \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
#0 \

## COLLABORATION CONTROLS + GNOMAD TOP GENES ##
intersect_vcfs \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/collaboration.controls/collaboration.controls.gwas.topgenes.20190520.AC1.pass.vcf \
1 \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/gnomad.exome.r2.1.1/gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star.vcf \
0 \

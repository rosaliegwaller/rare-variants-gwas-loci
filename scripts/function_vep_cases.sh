#!/bin/bash

intersect_vcfs(){
  OUTDIR=$1
  VEP=/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/ensembl-vep/vep

  ## ANNOTATE WITH VEP ##
  $VEP \
  --force_overwrite \
  --input_file $OUTDIR/0000.vcf.gz \
  --vcf \
  --cache \
  --dir /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/ensembl-vep/ \
  --offline \
  --output_file $OUTDIR/0000.vep.vcf

  ## SELECT HIGH / MODERATE VARS ##
  bcftools filter \
  --include 'INFO/CSQ[*]~"HIGH"' \
  --output $OUTDIR/0000.vep.high.vcf.gz \
  --output-type z \
  $OUTDIR/0000.vep.vcf

  tabix -p vcf $OUTDIR/0000.vep.high.vcf.gz

  bcftools filter \
  --include 'INFO/CSQ[*]~"MODERATE"' \
  --output $OUTDIR/0000.vep.moderate.vcf.gz \
  --output-type z \
  $OUTDIR/0000.vep.vcf

  tabix -p vcf $OUTDIR/0000.vep.moderate.vcf.gz

  bcftools concat \
  --allow-overlaps \
  --remove-duplicates \
  --output $OUTDIR/0000.vep.high.moderate.vcf \
  --output-type v \
  $OUTDIR/0000.vep.high.vcf.gz \
  $OUTDIR/0000.vep.moderate.vcf.gz

  cat $OUTDIR/0000.vep.high.moderate.vcf | uniq > $OUTDIR/0000.vep.high.moderate.uniq.vcf

}

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/utah.mm.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/utah.mm.ugp.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## CEPH + GNOMAD GWAS 10KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.10kb.20190312.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star/

## DBGAP MM / CONTROLS / GNOMAD TOP GENES ##
intersect_vcfs \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/dbgap.mm.control.gwas.topgenes.20190520.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

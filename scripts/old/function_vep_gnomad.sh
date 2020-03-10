#!/bin/bash

annotate_vep(){
  OUTDIR=$1
  VEP=/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/ensembl-vep/vep

  ## ANNOTATE WITH VEP ##
  $VEP \
  --force_overwrite \
  --input_file $OUTDIR/0001.vcf.gz \
  --vcf \
  --cache \
  --dir /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/ensembl-vep/ \
  --offline \
  --output_file $OUTDIR/0001.vep.vcf

  ## SELECT HIGH / MODERATE VARS ##
  bcftools filter \
  --include 'INFO/vep[*]~"HIGH"' \
  --output $OUTDIR/0001.vep.high.vcf.gz \
  --output-type z \
  $OUTDIR/0001.vep.vcf

  tabix -p vcf $OUTDIR/0001.vep.high.vcf.gz

  bcftools filter \
  --include 'INFO/vep[*]~"MODERATE"' \
  --output $OUTDIR/0001.vep.moderate.vcf.gz \
  --output-type z \
  $OUTDIR/0001.vep.vcf

  tabix -p vcf $OUTDIR/0001.vep.moderate.vcf.gz

  bcftools concat \
  --allow-overlaps \
  --remove-duplicates \
  --output $OUTDIR/0001.vep.high.moderate.vcf \
  --output-type v \
  $OUTDIR/0001.vep.high.vcf.gz \
  $OUTDIR/0001.vep.moderate.vcf.gz

}

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/utah.mm.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/utah.mm.ugp.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## CEPH + GNOMAD GWAS 20KB REGIONS ##
#intersect_vcfs \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## COLLABORATION MGUS
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mgus.gwas.20kb.20190505.AC1.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## COLLABORATION MM
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mm.gwas.20kb.20190505.AC1.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## CEPH + GNOMAD GWAS 10KB REGIONS ##
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.10kb.20190312.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# UTAH / GNOMAD TOP GENES
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/utah.mm.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# COLLABORATION MM / GNOMAD TOP GENES
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mm.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# COLLABORATION MGUS / GNOMAD TOP GENES
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mgus.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# DBGAP MM / GNOMAD TOP GENES
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/dbgap.mm.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# DBGAP CONTROL / GNOMAD TOP GENES
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/dbgap.control.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# DBGAP MM / CONTROL / GNOMAD TOP GENES
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/dbgap.mm.control.gwas.topgenes.20190520.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# DBGAP MM + GNOMAD TOP GENES
#annotate_vep \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/dbgap.mm.gwas.topgenes.20190520.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# COLLABORATION CONTROLS + GNOMAD TOP GENES
annotate_vep \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.controls.gwas.topgenes.20190520.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

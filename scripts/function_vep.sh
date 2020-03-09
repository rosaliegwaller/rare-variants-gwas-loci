#!/bin/bash

annotate_vep(){
  DIR=$1
  VCF=$2
  VEP=/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/ensembl-vep/vep

  ## ANNOTATE WITH VEP ##
  $VEP \
  --force_overwrite \
  --input_file $DIR/$VCF.vcf \
  --vcf \
  --cache \
  --dir /uufs/chpc.utah.edu/common/home/camp-group2/rosalie/ensembl-vep/ \
  --offline \
  --output_file $DIR/$VCF.vep.vcf

  ## SELECT HIGH / MODERATE VARS ##
#  bcftools filter \
#  --include 'INFO/CSQ[*]~"HIGH"' \
#  --output $OUTDIR/0000.vep.high.vcf.gz \
#  --output-type z \
#  $OUTDIR/0000.vep.vcf

#  tabix -p vcf $OUTDIR/0000.vep.high.vcf.gz

#  bcftools filter \
#  --include 'INFO/CSQ[*]~"MODERATE"' \
#  --output $OUTDIR/0000.vep.moderate.vcf.gz \
#  --output-type z \
#  $OUTDIR/0000.vep.vcf

#  tabix -p vcf $OUTDIR/0000.vep.moderate.vcf.gz

#  bcftools concat \
#  --allow-overlaps \
#  --remove-duplicates \
#  --output $OUTDIR/0000.vep.high.moderate.vcf \
#  --output-type v \
#  $OUTDIR/0000.vep.high.vcf.gz \
#  $OUTDIR/0000.vep.moderate.vcf.gz

#  cat $OUTDIR/0000.vep.high.moderate.vcf | uniq > $OUTDIR/0000.vep.high.moderate.uniq.vcf

}

annotate_vep \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/dbgap.mm.control \
dbgap.mm.control.gwas.topgenes.20190520

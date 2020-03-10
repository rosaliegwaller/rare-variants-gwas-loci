#!/bin/bash


## SUMMARIZE FILES ##
bcftools query \
-f '%CHROM\t%POS\t%REF\t%ALT\t%AC\t%AN[\t%SAMPLE=%GT]\n' \
$DIR/tmp/0000.vcf.gz \
| uniq > $DIR/tmp/gts.txt

grep '^[0-9]\{1,2\}'$'\t''[0-9]\+'$'\t''[ACTG]\+'$'\t''[ACTG]\+'$'\t''[0-9]\+'$'\t''[0-9]\+\|[a-zA-Z0-9_-.]\+=[01]/1' \
-o -n $DIR/tmp/gts.txt > $DIR/tmp/gts.grep.txt

grep '[0-9]\{1,2\}'$'\t''[0-9]\+'$'\t''[ACTG]\+'$'\t''[ACTG]\+'$'\t''[0-9]\+'$'\t''[0-9]\+' $DIR/tmp/gts.grep.txt \
| awk '{print $1"-"$2"-"$3"-"$4" "$5" "$6}' \
> $DIR/tmp/cases.sites.txt
sed -i -e 's/:/ /g' $DIR/tmp/cases.sites.txt

grep '[01]/1' $DIR/tmp/gts.grep.txt > $DIR/tmp/cases.sites.gts.txt
sed -i -e 's/:/ /g' $DIR/tmp/cases.sites.gts.txt

awk '
{
   x[$1]=x[$1]","$2;   # Append 2nd field to contents of x[$1] (followed by a space)
}
# Now: The array "x" contains all the lines keyed by the first field.
END {
   for (k in x) print k,x[k];
}' $DIR/tmp/cases.sites.gts.txt > $DIR/tmp/cases.sites.gts.2.txt

bcftools query \
-f '%CHROM\t%POS\t%REF\t%ALT\t%ID\t%non_cancer_AC\t%non_cancer_AN\t%non_cancer_AF\n' \
$DIR/tmp/0001.vcf.gz \
| uniq > $DIR/tmp/0001.summary.txt

awk '{print $1"-"$2"-"$3"-"$4" "$5" "$6" "$7" "$8}' $DIR/tmp/0001.summary.txt > $DIR/tmp/gnomad.sites.txt

awk -F ' ' 'FNR==NR{a[$1]=$0;next}($2 in a){print a[$2]" "$3" "$4" "$1}' $DIR/tmp/gnomad.sites.txt $DIR/tmp/cases.sites.txt > $DIR/tmp/sites.txt

awk -F ' ' 'FNR==NR{a[$8]=$0;next}($1 in a){print a[$1]" "$2}' $DIR/tmp/sites.txt $DIR/tmp/cases.sites.gts.2.txt > $DIR/summary.txt`



summarize_intersect(){
  DIR=$1
  OUTDIR=$DIR/summary
  mkdir $OUTDIR

  cd $OUTDIR
  
## SUMMARIZE FILES ##

bcftools query \
-f '%CHROM\t%POS\t%REF\t%ALT\t%AC\t%AN[\t%SAMPLE=%GT]\n' \
$DIR/0000.vcf.gz \
| uniq \
> gts.txt

grep '^[0-9]\{1,2\}'$'\t''[0-9]\+'$'\t''[ACTG]\+'$'\t''[ACTG]\+'$'\t''[0-9]\+'$'\t''[0-9]\+\|[a-zA-Z0-9_-.]\+=[01]/1' \
-o -n gts.txt > gts.grep.txt

grep '[0-9]\{1,2\}'$'\t''[0-9]\+'$'\t''[ACTG]\+'$'\t''[ACTG]\+'$'\t''[0-9]\+'$'\t''[0-9]\+' gts.grep.txt \
| awk '{print $1"-"$2"-"$3"-"$4" "$5" "$6}' \
> cases.sites.txt
sed -i -e 's/:/ /g' cases.sites.txt

grep '[01]/1' gts.grep.txt > cases.sites.gts.txt
sed -i -e 's/:/ /g' cases.sites.gts.txt

awk '
{ 
   x[$1]=x[$1]","$2;   # Append 2nd field to contents of x[$1] (followed by a space)
} 
# Now: The array "x" contains all the lines keyed by the first field. 
END { 
   for (k in x) print k,x[k];  
}' cases.sites.gts.txt > cases.sites.gts.2.txt

bcftools query \
-f '%CHROM\t%POS\t%REF\t%ALT\t%ID\t%non_cancer_AC\t%non_cancer_AN\t%non_cancer_AF\n' \
$DIR/0001.vep.high.moderate.vcf \
| uniq \
> 0001.summary.txt

awk '{print $1"-"$2"-"$3"-"$4" "$5" "$6" "$7" "$8}' 0001.summary.txt > gnomad.sites.txt

awk -F ' ' 'FNR==NR{a[$1]=$0;next}($2 in a){print a[$2]" "$3" "$4" "$1}' gnomad.sites.txt cases.sites.txt > sites.txt 

awk -F ' ' 'FNR==NR{a[$8]=$0;next}($1 in a){print a[$1]" "$2}' sites.txt cases.sites.gts.2.txt > summary.txt

}

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/utah.mm.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup \
#utah.mm

## COLLABORATION MM + GNOMAD GWAS 20KB REGIONS ##
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mm.gwas.20kb.20190505.AC1.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup \
#collaboration.mm

## COLLABORATION MGUS + GNOMAD GWAS 20KB REGIONS ##
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mgus.gwas.20kb.20190505.AC1.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup \
#collaboration.mgus

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/utah.mm.ugp.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \
#utah.mm.ugp

## UTAH MM + GNOMAD GWAS 20KB REGIONS ##
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/utah.mm.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \
#utah.mm

## CEPH + GNOMAD GWAS 20KB REGIONS ##
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \

## COLLABORATION MGUS ##
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mgus.gwas.20kb.20190505.AC1.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## COLLABORATION MM
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mm.gwas.20kb.20190505.AC1.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## CEPH + GNOMAD GWAS 10KB REGIONS ##
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home//camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.10kb.20190312.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# UTAH / GNOMAD TOP GENES
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home//camp-group2/rosalie/gwas/vcfs/intersect/utah.mm.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

## COLLAB MM / GNOMAD TOP GENES
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home//camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mm.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# COLLAB MGUS / GNOMAD TOP GENES
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home//camp-group2/rosalie/gwas/vcfs/intersect/collaboration.mgus.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# DBGAP MM / GNOMAD TOP GENES
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home//camp-group2/rosalie/gwas/vcfs/intersect/dbgap.mm.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# DBGAP CONTROL / GNOMAD TOP GENES
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home//camp-group2/rosalie/gwas/vcfs/intersect/dbgap.control.gwas.topgenes.20190513.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190513.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# DBGAP MM / CONTROL / GNOMAD TOP GENES
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/dbgap.mm.control.gwas.topgenes.20190520.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# DBGAP MM + GNOMAD TOP GENES
#summarize_intersect \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/dbgap.mm.gwas.topgenes.20190520.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

# COLLABORATION CONTROLS + GNOMAD TOP GENES
summarize_intersect \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/collaboration.controls.gwas.topgenes.20190520.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star

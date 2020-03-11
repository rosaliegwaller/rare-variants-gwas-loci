sample_sims (){
DIR=$1
DATE=$2
SET=$3
SIMS=$4
mkdir $DIR/$DATE
cd $DIR/$DATE

bgzip $DIR/0000.vep.high.moderate.uniq.vcf
cp $DIR/0000.vep.high.moderate.uniq.vcf.gz $SET.vcf.gz
tabix -p vcf $SET.vcf.gz

# Generate random subsets of 75 cases in utah capture**
for i in `seq 0 $SIMS`; do
  vcftools \
  --gzvcf $SET.vcf.gz \
  --max-indv 75 \
  --non-ref-ac 2 \
  --counts \
  --out $SET.$i
done
}

annotate_sims (){
DIR=$1
DATE=$2
SET=$3
SIMS=$4
cd $DIR/$DATE
mkdir af

# ANNOTATE VARIANTS WITH AF:
for i in `seq 0 $SIMS`; do
  sed 's/:/\t/g' $SET.$i.frq.count \
  | awk -F '\t' 'NR>1{print $1"-"$2"-"$5"-"$7" "$8}' \
  > af/$SET.$i.txt

  awk -F ' ' 'FNR==NR{a[$1]=$0;next}($1 in a){print a[$1]" "$5}' \
  af/$SET.$i.txt $DIR/summary/summary.txt > af/$i.vars.af.txt
done
}

count_sims (){
DIR=$1
DATE=$2
SET=$3
SIMS=$4
cd $DIR/$DATE/af

# Count variants with AC &&:
mkdir counts
touch counts/AC2.txt
touch counts/AC3.txt
touch counts/AC4.txt

for i in `seq 0 $SIMS`; do
  echo "$i $(awk '$2 >= 2 && $3 <= 0.00856 {print $0}' $i.vars.af.txt | wc -l)" \
  >> counts/AC2.txt
  echo "$i $(awk '$2 >= 3 && $3 <= 0.00526 {print $0}' $i.vars.af.txt | wc -l)" \
  >> counts/AC3.txt
  echo "$i $(awk '$2 >= 4 && $3 <= 0.00526 {print $0}' $i.vars.af.txt | wc -l)" \
  >> counts/AC4.txt
done

# Combine counts:
awk -F ' ' 'FNR==NR{a[$1]=$2;next}($1 in a){print $0" "a[$1]}' \
counts/AC3.txt counts/AC2.txt \
> counts/AC2_AC3.txt

awk -F ' ' 'FNR==NR{a[$1]=$2;next}($1 in a){print $0" "a[$1]}' \
counts/AC4.txt counts/AC2_AC3.txt \
> counts/AC2_AC3_AC4.txt
}

#sample_sims \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \
#20190509 \
#ceph.filtered \
#999

#annotate_sims \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \
#20190509 \
#ceph.filtered \
#999

#count_sims \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.20kb.20190424.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \
#20190509 \
#ceph.filtered \
#999

sample_sims \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.10kb.20190312.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \
20190509 \
ceph.filtered \
999999

annotate_sims \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.10kb.20190312.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \
20190509 \
ceph.filtered \
999999

count_sims \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/ceph.parentless.gwas.10kb.20190312.AC2.pass.gnomad.exome.r2.1.1.gwas.20kb.20190424.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \
20190509 \
ceph.filtered \
999999

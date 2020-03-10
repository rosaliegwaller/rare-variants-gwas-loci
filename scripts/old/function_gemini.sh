
create_gemini_db(){
DIR=$1
VCF=$2
PED=$3

mkdir $DIR/gemini
OUT=$DIR/gemini

REF=/uufs/chpc.utah.edu/common/home/camp-group1/archive/r3/TITP/FASTA/human_g1k_v37.fasta

# decompose, normalize and annotate VCF with snpEff.
less $DIR/$VCF.vcf \
   | sed 's/ID=AD,Number=./ID=AD,Number=R/' \
   | vt decompose -s - \
   | vt normalize -r $REF - \
   | bgzip -c > $OUT/$VCF.decomp.norm.vcf.gz
tabix -p vcf $OUT/$VCF.decomp.norm.vcf.gz

# load the pre-processed VCF into GEMINI
gemini load --cores 3 -t VEP -v $OUT/$VCF.decomp.norm.vcf.gz -p $OUT/$PED $OUT/$VCF.db

# query variants and samples
gemini query -q "select count(*) from variants" $OUT/$VCF.db
gemini query -q "select count(*) from samples" $OUT/$VCF.db
gemini query -q "select count(*) from samples where phenotype==2" $OUT/$VCF.db
gemini query -q "select count(*) from samples where phenotype==1" $OUT/$VCF.db

# burden test
gemini burden --nonsynomynous --calpha --permutations 1000 $OUT/$VCF.db
}

#create_gemini_db \
#/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/intersect/dbgap.mm.control.gwas.topgenes.20190520.AC1.pass.gnomad.exome.r2.1.1.gwas.topgenes.20190520.n_alt_alleles_2.non_cancer_AF_0.01.non_cancer_AF_popmax_0.05.pass.no_segdup.no_star \
#0000.vep \
#dbgap.ped

create_gemini_db \
/uufs/chpc.utah.edu/common/home/camp-group2/rosalie/gwas/vcfs/dbgap.mm.control \
dbgap.mm.control.gwas.topgenes.20190520.vep \
dbgap.ped


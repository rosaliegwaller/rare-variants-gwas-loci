#!/bin/bash

summarize(){

	DIR=$1
	SAMPLES=$DIR/$2
	CASEVCF=$DIR/$3
	MIN_AC=$4
	GNOMADVCF=$DIR/$5
	OUT=$6
	mkdir $DIR/tmp

	## SELECT SAMPLES AND SUMMARY ##
	bcftools view \
		--samples-file $SAMPLES \
		--output-type v \
		$CASEVCF \
		| bcftools filter \
			--include 'AC>='$MIN_AC \
			--output-type v \
		| bcftools query \
			-f '%CHROM\t%POS\t%REF\t%ALT\t%AC\t%AN[\t%SAMPLE=%GT]\n' \
		| uniq \
		> $DIR/tmp/gts.txt

	## ORGANIZE FILE ##
	grep '[a-zA-Z0-9]\+=[01]/1' -o -n $DIR/tmp/gts.txt > $DIR/tmp/gts.grep.txt
	grep '[0-9]\{1,2\}'$'\t''[0-9]\+'$'\t''[ACTG]\+'$'\t''[ACTG]\+'$'\t''[0-9]\+'$'\t''[0-9]\+' -o -n $DIR/tmp/gts.txt \
	| awk '{print $1"-"$2"-"$3"-"$4" "$5" "$6}' > $DIR/tmp/cases.sites.txt
	sed -i -e 's/:/ /g' $DIR/tmp/cases.sites.txt
	
	grep '[01]/1' $DIR/tmp/gts.grep.txt > $DIR/tmp/cases.sites.gts.txt
	sed -i -e 's/:/ /g' $DIR/tmp/cases.sites.gts.txt

	awk '{x[$1]=x[$1]","$2;} END {for (k in x) print k,x[k];}' $DIR/tmp/cases.sites.gts.txt > $DIR/tmp/cases.sites.gts.2.txt

	## SELECT GNOMAD DATA ##
	bcftools query \
		-f '%CHROM\t%POS\t%REF\t%ALT\t%ID\t%non_cancer_AC\t%non_cancer_AN\t%non_cancer_AF\n' \
		$GNOMADVCF \
		| uniq \
		> $DIR/tmp/gnomad.summary.txt

	awk '{print $1"-"$2"-"$3"-"$4" "$5" "$6" "$7" "$8}' $DIR/tmp/gnomad.summary.txt > $DIR/tmp/gnomad.sites.txt
	awk -F ' ' 'FNR==NR{a[$1]=$0;next}($2 in a){print a[$2]" "$3" "$4" "$1}' $DIR/tmp/gnomad.sites.txt $DIR/tmp/cases.sites.txt > $DIR/tmp/sites.txt
	awk -F ' ' 'FNR==NR{a[$8]=$0;next}($1 in a){print a[$1]" "$2}' $DIR/tmp/sites.txt $DIR/tmp/cases.sites.gts.2.txt > $DIR/tmp/summary.txt

	sed -i -e 's/ [0-9] ,/ /g' $DIR/tmp/summary.txt

	echo -e "VARID RSID GNOMAD_nCA_AC GNOMAD_nCA_AN GNOMAD_nCA_AF CASE_AC CASE_AN CARRIERS" | cat - $DIR/tmp/summary.txt > $OUT	

	rm -r $DIR/tmp
}

## DISCOVERY - 75 UTAH MM CASES ##
summarize \
	/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files \
	samples/samples-10kb-utah-75-mm.txt \
	variants/10kb/discovery-gnomad-filtered.vcf.gz \
	2 \
	variants/10kb/gnomad-filtered-discovery.vcf.gz \
	/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/variants/10kb/summary-75-mm.txt 

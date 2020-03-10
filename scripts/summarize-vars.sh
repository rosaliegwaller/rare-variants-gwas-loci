#!/bin/bash

summarize(){

	DIR=$1
	SAMPLES=$2
	CASEVCF=$3
	GNOMADVCF=$4
	mkdir $DIR/tmp

	## SELECT SAMPLES AND SUMMARY ##
	bcftools view \
		--samples-file $SAMPLES \
		--output-type v \
		$CASEVCF \
		| bcftools query \
			-f '%CHROM\t%POS\t%REF\t%ALT\t%AC\t%AN[\t%SAMPLE=%GT]\n' \
		| uniq \
		> $DIR/tmp/gts.txt

	## ORGANIZE FILE ##
	grep '^[0-9]\{1,2\}'$'\t''[0-9]\+'$'\t''[ACTG]\+'$'\t''[ACTG]\+'$'\t''[0-9]\+'$'\t''[0-9]\+\|[a-zA-Z0-9_-.]\+=[01]/1' \
		-o -n \
		$DIR/tmp/gts.txt \
		> $DIR/tmp/gts.grep.txt

#grep '[0-9]\{1,2\}'$'\t''[0-9]\+'$'\t''[ACTG]\+'$'\t''[ACTG]\+'$'\t''[0-9]\+'$'\t''[0-9]\+' $DIR/tmp/gts.grep.txt \
#| awk '{print $1"-"$2"-"$3"-"$4" "$5" "$6}' \
#> $DIR/tmp/cases.sites.txt
#sed -i -e 's/:/ /g' $DIR/tmp/cases.sites.txt

#grep '[01]/1' $DIR/tmp/gts.grep.txt > $DIR/tmp/cases.sites.gts.txt
#sed -i -e 's/:/ /g' $DIR/tmp/cases.sites.gts.txt

#awk '
#{
#   x[$1]=x[$1]","$2;   # Append 2nd field to contents of x[$1] (followed by a space)
#}
## Now: The array "x" contains all the lines keyed by the first field.
#END {
#   for (k in x) print k,x[k];
#}' $DIR/tmp/cases.sites.gts.txt > $DIR/tmp/cases.sites.gts.2.txt

#bcftools query \
#-f '%CHROM\t%POS\t%REF\t%ALT\t%ID\t%non_cancer_AC\t%non_cancer_AN\t%non_cancer_AF\n' \
#$DIR/tmp/0001.vcf.gz \
#| uniq > $DIR/tmp/0001.summary.txt

#awk '{print $1"-"$2"-"$3"-"$4" "$5" "$6" "$7" "$8}' $DIR/tmp/0001.summary.txt > $DIR/tmp/gnomad.sites.txt

#awk -F ' ' 'FNR==NR{a[$1]=$0;next}($2 in a){print a[$2]" "$3" "$4" "$1}' $DIR/tmp/gnomad.sites.txt $DIR/tmp/cases.sites.txt > $DIR/tmp/sites.txt

#awk -F ' ' 'FNR==NR{a[$8]=$0;next}($1 in a){print a[$1]" "$2}' $DIR/tmp/sites.txt $DIR/tmp/cases.sites.gts.2.txt > $DIR/summary.txt`
}

## TEST ##
summarize \
	/home/rose/github/rare-variants-gwas-loci/files/variants/10kb \
	/home/rose/github/rare-variants-gwas-loci/files/samples/samples-10kb-utah-75-mm.txt \
	/home/rose/github/rare-variants-gwas-loci/files/variants/10kb/discovery-gnomad-filtered.vcf.gz \
	/home/rose/github/rare-variants-gwas-loci/files/variants/10kb/gnomad-filtered-discovery.vcf.gz

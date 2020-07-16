#!/bin/bash/env bash

module load bedtools/2.28.0 #load bedtools on CHPC PE
DIR=~/github/rare-variants-gwas-loci/bed_files
REGIONS=$DIR/regions-r8nfin-genes.bed

## DISCOVERY ##
bedtools intersect \
-a $REGIONS \
-b $DIR/regions-utah-exome.bed \
-b $DIR/regions-cornell-exome.bed \
| bedtools sort -i - | bedtools merge -i - \
> $DIR/regions-discovery-v2.bed

echo 'TOTAL BASES IN DISCOVERY REGIONS'
awk 'BEGIN { OFS = "\t" } { $4 = $3 - $2 } 1' \
$DIR/regions-discovery-v2.bed \
| awk '{s+=$4}END{print s}' -

## REPLICATION ##
#bedtools intersect \
#-a $DIR/regions-10kb-replication.bed \
#-b $DIR/regions-utah-exome.bed \
#-b $DIR/regions-cornell-exome.bed \
#| bedtools sort -i - | bedtools merge -i - \
#> /uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/replication/regions-replication.bed

#echo 'TOTAL BASES IN DISCOVERY REGIONS'
#awk 'BEGIN { OFS = "\t" } { $4 = $3 - $2 } 1' \
#/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/replication/regions-replication.bed \
#| awk '{s+=$4}END{print s}' -

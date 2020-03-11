#!/bin/bash/env bash

BEDTOOLS=/uufs/chpc.utah.edu/common/home/u0690571/bin/bedtools/bedtools2/bin/bedtools
DIR=/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/setup

## DISCOVERY ##
$BEDTOOLS intersect \
-a $DIR/regions-10kb-gwas.bed \
-b $DIR/regions-utah-exome.bed \
-b $DIR/regions-cornell-exome.bed \
| $BEDTOOLS sort -i - | $BEDTOOLS merge -i - \
> /uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/discovery/regions-discovery.bed

echo 'TOTAL BASES IN DISCOVERY REGIONS'
awk 'BEGIN { OFS = "\t" } { $4 = $3 - $2 } 1' \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/discovery/regions-discovery.bed \
| awk '{s+=$4}END{print s}' -

## REPLICATION ##
$BEDTOOLS intersect \
-a $DIR/regions-10kb-replication.bed \
-b $DIR/regions-utah-exome.bed \
-b $DIR/regions-cornell-exome.bed \
| $BEDTOOLS sort -i - | $BEDTOOLS merge -i - \
> /uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/replication/regions-replication.bed

echo 'TOTAL BASES IN DISCOVERY REGIONS'
awk 'BEGIN { OFS = "\t" } { $4 = $3 - $2 } 1' \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/replication/regions-replication.bed \
| awk '{s+=$4}END{print s}' -

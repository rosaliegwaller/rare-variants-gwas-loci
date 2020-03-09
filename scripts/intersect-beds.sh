#!/bin/bash/env bash

BEDTOOLS=/uufs/chpc.utah.edu/common/home/u0690571/bin/bedtools/bedtools2/bin/bedtools

$BEDTOOLS intersect \
-a /uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-10kb-gwas.bed \
-b /uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-utah-exome.bed \
-b /uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-cornell-exome.bed \
| $BEDTOOLS sort -i - | $BEDTOOLS merge -i - \
> /uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-10kb-exome.bed

awk 'BEGIN { OFS = "\t" } { $4 = $3 - $2 } 1' \
/uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-10kb-exome.bed \
> /uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-10kb-exome-len.bed

awk '{s+=$4}END{print s}' /uufs/chpc.utah.edu/common/home/u0690571/github/rare-variants-gwas-loci/files/regions-10kb-exome-len.bed

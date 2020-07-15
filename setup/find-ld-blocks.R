## Find LD blocks from list of SNPS

#install.packages("LDlinkR")
library(LDlinkR)
library(dplyr)

#get LDLink Token from https://ldlink.nci.nih.gov/?tab=apiaccess
#save to .Renviron with: usethis::edit_r_environ()
#add line to .Renviron: LDLINK_TOKEN=YourTokenHere123
#call token with: Sys.getenv("LDLINK_TOKEN")

## Query LDproxy using a list of query variants
setwd("C:/Users/rosal/OneDrive - University of Utah/2020/analyze/data/gwas-candidate-genes/")
rsids = read.csv("gwas_catalog_v1.0.2-associations_e100_r2020-06-30_SELECTED_RSIDS.tsv",header = F) #list of rsids

#CEU population
LDlinkR::LDproxy_batch(snp = rsids,
                       pop = "CEU",
                       r2d = "r2",
                       token = Sys.getenv("LDLINK_TOKEN"),
                       append = TRUE)

df.ceu = read.csv("combined_query_snp_list_ceu.txt",sep = '\t',row.names = NULL)

#All populations
LDlinkR::LDproxy_batch(snp = rsids,
                       pop = "ALL",
                       r2d = "r2",
                       token = Sys.getenv("LDLINK_TOKEN"),
                       append = TRUE)

df.all = read.csv("combined_query_snp_list_all.txt",sep = '\t',row.names = NULL)

#EUR populations
LDlinkR::LDproxy_batch(snp = rsids,
                       pop = "EUR",
                       r2d = "r2",
                       token = Sys.getenv("LDLINK_TOKEN"),
                       append = TRUE)

df.eur = read.csv("combined_query_snp_list_eur.txt",sep = '\t',row.names = NULL)

#Non-Finnish EUR populations ***USE THIS ONE***
LDlinkR::LDproxy_batch(snp = rsids,
                       pop = c("CEU","TSI","GBR","IBS"),
                       r2d = "r2",
                       token = Sys.getenv("LDLINK_TOKEN"),
                       append = TRUE)

df.nfin = read.csv("combined_query_snp_list_nfin.txt",sep = '\t',row.names = NULL)

#select snps with r2 >= 0.8 ***USE THIS ONE***
df = df.nfin
snp = as.character(rsids[rsids$V1!="rs4487645" & rsids$V1!="rs138747" & rsids$V1!="rs9270750",]) #remove 3 snps not found by LDlink
out = data.frame(chr=character(),pos=numeric(),min=numeric(),max=numeric(),stringsAsFactors=FALSE)
for (x in snp) {
  pos = strsplit(as.character(droplevels(unique(df[df$query_snp==x & df$RS_Number==x,"Coord"]))),":")[[1]]
  tmp_dis = df[df$query_snp==x & df$R2>0.8,"Distance"]
  out[x,] = c(pos,min(tmp_dis),max(tmp_dis))
}
out$pos = as.numeric(out$pos)
out$min = as.numeric(out$min)
out$max = as.numeric(out$max)
#regions
out$start <- out$pos + out$min
out$end <- out$pos + out$max
bed = out[,c("chr","start","end")]
head(bed)
nrow(bed)

#write output
write.table(x = bed,file = "regions_r8_nfin.txt",sep = "\t",quote = F,row.names = F,col.names = F)

#get list of genes from UCSC Genome Browser:
##https://genome.ucsc.edu/cgi-bin/hgTables
##clade: Mammal
##genome: Human
##assembly: Feb. 2009 (GRCh37/hg19)
##group: Genes and Gene Predictions
##track: UCSC Genes
##table: knownCanonical
##region: position, define regions
##Enter region definition page: upload file = "regions_r8_nfin.txt" and submit
##output format: selected fields from primary and related tables
##get output
##Select Fields page
##hg19.knownCanonical: chrom, chromStart, chromEnd
##hg19.kgXref fields: geneSymbol, description
##get output
##Saved output as "knownCanonical_overlap.txt"

#read in gene overlap file
genes = read.csv(file = "knownCanonical_overlap.txt",sep = "\t")
##select mRNA genes and remove duplicates
mRNA = unique(genes[genes$hg19.kgXref.description %>% contains(match = "mRNA",ignore.case = F),])
##count unique genes: 95 genes (5 have multiple canonical transcripts)
length(unique(mRNA$hg19.kgXref.geneSymbol))

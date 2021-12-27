setwd("~/projects/exam/")
tt <- read_tsv('data/02-data-with-DP-is-INDEL.tsv', col_names=T) 
colnames(tt)
colnames(tt)[1] <- "CHROM"
head(tt)

##Question 2
##Distribution of read depth (DP) over the whole genome and by chromosome
##Over the whole genome
ggplot(tt, aes(DP)) +
  geom_histogram(binwidth=1) +
  ggtitle("\t \t \t \t Overall Read Depth") +
  ylab("Count of variants") +
  xlab("Depth")

##by chromosome
tt %>% 
  filter(!is.na(DP)) %>% 
  ggplot(aes(factor(CHROM), DP)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5)) +
  ggtitle("Read depth for each chromosome") +
  ylab("Read depth") +
  xlab("Chromosome")

##Question 3
##Distribution of PHRED qualities INDELS vs. SNPs
##whole genome

tt %>% 
  filter(!is.na(QUAL)) %>% 
  ggplot(aes(factor(ISINDEL), QUAL)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(hjust = 0.5, vjust = 0.5)) +
  ggtitle("PHRED quality for INDELS and SNPs") +
  ylab("PHRED quality") +
  xlab("Variant type")

##by chromosome

tt %>% 
  filter(!is.na(QUAL)) %>% 
  ggplot(aes(factor(ISINDEL), QUAL)) + 
  facet_wrap(~CHROM, ncol = 8) +
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5)) +
  ggtitle("PHRED quality for INDELS and SNPs") +
  ylab("PHRED quality") +
  xlab("Variant type")

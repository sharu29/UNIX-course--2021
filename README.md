# UNIX course - Final exercise - Solution

This is my solution to the final exercise of the UNIX course. The aim of the exercise is to process vcf data in UNIX and prepare it for analysis in R Studio. The vcf file luscinia_vars.vcf.gz will be processed into an output file. This will be used for further analysis R and graphs and plots will be generated.

I have chosen to complete the below mentioned tasks:

**Task 2: Distribution of read depth (DP) over the whole genome and by chromosome**

**Task 3: Distribution of PHRED qualities INDELS vs. SNPs**

## Preparing the data in UNIX

An executable script will be created first. Then, a folder called 'data' will be created within the 'exam' folder. The data will be copied from the shared location to 'data'.

```
mkdir exam
cd exam
mkdir data
cp /data-shared/vcf_examples/luscinia_vars.vcf.gz data/ 
```

```
##Unzip the file and set up the input file

gunzip data/luscinia_vars.vcf.gz
INPUT=data/luscinia_vars.vcf 
```
Next, I selected the data needed for analysis in R. The first columns in the vcf file and the read depth (DP) and allele frequency (AF1) stored in the INFO column will be used. The data will be stored in a separate .tsv file and then merged using paste.

```
#Select the columns 1-6 from vcf file
<$INPUT grep -v '^##' | cut -f1-6 > data/01-data.tsv

#Create new columns- DP, INDEL, AF1
<$INPUT egrep -o 'DP=[^;]*' | sed 's/DP=//' > data/01-data-DP.tsv
<$INPUT awk '{if($0 ~ /INDEL/) print "INDEL"; else print "SNP"}' > data/01-data-is-INDEL.tsv
<$INPUT egrep -o 'AF1=[^;]*' | sed 's/AF1=//' > data/01-data-AF.tsv

# New column names
sed  -i '1i DP' data/01-data-DP.tsv
sed  -i '1i ISINDEL' data/01-data-is-INDEL.tsv
sed  -i '1i AF' data/01-data-AF.tsv

# Merge the columns using paste
paste data/01-data.tsv data/01-data-DP.tsv data/01-data-is-INDEL.tsv data/01-data-AF.tsv >data/02-data-with-DP-is-INDEL.tsv
```

## Data Analysis using R

We will use R to create plots (ggplot2) using the data we prepared in UNIX.
```
# Set directory and read data
setwd("~/projects/exam/")
tt <- read_tsv('data/02-data-with-DP-is-INDEL.tsv', col_names=T) 
colnames(tt)
colnames(tt)[1] <- "CHROM"
head(tt)
```

### Task 2: Distribution of read depth (DP) over the whole genome and by chromosome

Over the whole genome
```
## Over the whole genome
ggplot(tt, aes(DP)) +
  geom_histogram(binwidth=1) +
  ggtitle("\t \t \t \t Overall Read Depth") +
  ylab("Count of variants") +
  xlab("Depth")
```  
Seperated by chromosome
```
## by chromosome
tt %>% 
  filter(!is.na(DP)) %>% 
  ggplot(aes(factor(CHROM), DP)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5)) +
  ggtitle("Read depth for each chromosome") +
  ylab("Read depth") +
  xlab("Chromosome")
```
Plot of read depth across the whole genome

![rplot1](https://user-images.githubusercontent.com/58308612/147478614-a84d3f3b-b215-4aae-86f6-1ed81b21add0.png)

Seperated by chromosome

![rplot2](https://user-images.githubusercontent.com/58308612/147478766-5ae4575e-a026-45d3-acee-12576f00cb39.png)

### Task 3: Distribution of PHRED qualities INDELS vs. SNPs

Over the whole genome
```
##whole genome
tt %>% 
  filter(!is.na(QUAL)) %>% 
  ggplot(aes(factor(ISINDEL), QUAL)) + 
  geom_boxplot() + 
  theme(axis.text.x = element_text(hjust = 0.5, vjust = 0.5)) +
  ggtitle("PHRED quality for indels and SNPs") +
  ylab("PHRED quality") +
  xlab("Variant type")
```
Seperated by chromosome
```
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
```
Plot of read depth across the whole genome

![rplot3](https://user-images.githubusercontent.com/58308612/147479561-edb9fbc5-b8d3-4ffe-912f-2220ddba5a0a.png)

Seperated by chromosome

![rplot4](https://user-images.githubusercontent.com/58308612/147479579-9a792dea-a60f-4fab-886b-94e33b954c17.png)



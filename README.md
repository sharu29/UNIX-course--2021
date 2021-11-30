UNIX course - Final exercise - Solution

This is my solution to the final exercise of the UNIX course. The aim of the exercise is to process vcf data in UNIX and prepare it for analysis in R Studio. The vcf file luscinia_vars.vcf.gz will be processed into an output file. This will be used for further analysis R and graphs and plots will be generated.

I have chosen to complete the below mentioned tasks:

Task 2: Distribution of read depth (DP) over the whole genome and by chromosome

Task 3: Distribution of PHRED qualities INDELS vs. SNPs

Processing the data in UNIX

An executable script will be created first. Then, a folder called 'data' will be created within the 'exam' folder. The data will be copied from the shared location to 'data'.

mkdir exam
cd exam
mkdir data
cp /data-shared/vcf_examples/luscinia_vars.vcf.gz data/

##Unzip the file and set up the input file
gunzip data/luscinia_vars.vcf.gz
INPUT=data/luscinia_vars.vcf

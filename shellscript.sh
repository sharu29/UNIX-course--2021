#Create a folder exam and copy the files
mkdir exam
cd exam
mkdir data
cp /data-shared/vcf_examples/luscinia_vars.vcf.gz data/ 

#Unzip the file and set up the input file

gunzip data/luscinia_vars.vcf.gz
INPUT=data/luscinia_vars.vcf 

#Select the columns 1-6
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

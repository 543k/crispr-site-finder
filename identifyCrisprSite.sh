#!/bin/sh

#Assigns CRISPR site indicator to a variable
crisprSite="GG"

#Makes directory for FASTA files for genome editing
mkdir exomesCohort/preCrispr

#Loops through FASTA files in topMotifs directory
for exome in exomesCohort/topMotifs/*.fasta
do
  exomeCode=$(basename $exome .fasta)
  exomeCode=${exomeCode%_*}
  geneArray=($(awk 'BEGIN{RS=">";} NR>1{print ">" $0;}' "$exome"))
  for gene in "${geneArray[@]}"
  do
    #Loops through sequence to find potential CRISPR suitable sites
    for (( i=0; i <= ${#gene}-${#crisprSite}; i++ ))
    do
      if [[ ${gene:i:${#crisprSite}} == "$crisprSite" ]]
      then
        if (( i >= 20 ))
        then
          #preCrispr FASTA files generated
          echo $temp >> exomesCohort/preCrispr/"$exomeCode"_precrispr.fasta
          echo $gene >> exomesCohort/preCrispr/"$exomeCode"_precrispr.fasta
          break
        fi
      fi
    done
    temp=$gene
  done
done

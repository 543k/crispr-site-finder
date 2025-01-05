#!/bin/sh

#Assigns CRISPR site indicator to a variable
crisprSite="GG"

#Makes directory for FASTA files that have been edited
mkdir exomesCohort/postCrispr

#Loops through FASTA files in preCrispr directory
for exome in exomesCohort/preCrispr/*.fasta
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
          #Sequence edited to indicate CRISPR site
          gene="${gene:0:i}A${gene:i}"
          
          #postCrispr FASTA files generated
          echo $temp >> exomesCohort/postCrispr/"$exomeCode"_postcrispr.fasta
          echo $gene >> exomesCohort/postCrispr/"$exomeCode"_postcrispr.fasta
          break
        fi
      fi
    done
    temp=$gene
  done
done

#!/bin/sh

#Makes a list of unique motifs, and empty array for the FASTA files
motifs=$(sort motif_list.txt | uniq)

#Makes a directory to hold topMotif FASTA files
mkdir exomesCohort/topMotifs

#Loops through FASTA files in exomesCohort directory looking for frequent motifs
for exome in exomesCohort/*.fasta
do
  #Variables declared for frequent motifs
  firstMost=0
  firstMotif=""
  
  secondMost=0
  secondMotif=""
  
  thirdMost=0
  thirdMotif=""

  #Finds three most frequent motifs, updating every loop
  for motif in $motifs
  do
    current=$(grep -o -c '$motif' $exome)
    if (( $current >= $firstMost ))
    then
      thirdMost=$secondMost
      thirdMotif=$secondMotif

      secondMost=$firstMost
      secondMotif=$firstMotif

      firstMost=$current
      firstMotif=$motif
    elif (( $current >= $secondMost ))
    then
      thirdMost=$secondMost
      thirdMotif=$secondMotif

      secondMost=$current
      secondMotif=$motif
    elif (( $current >= $thirdMost ))
    then
      thirdMost=$current
      thirdMotif=$motif
    fi
  done
  #Extracts exome code name from file path
  exomeCode=$(basename $exome .fasta)
  #Array of genes looped through looking for ones with the frequent motifs
  geneArray=($(awk 'BEGIN{RS=">";} NR>1{print ">" $0;}' "$exome"))
  for gene in "${geneArray[@]}"
  do
    if [[ $gene == *$firstMotif* || $gene == *$secondMotif* || $gene == *$thirdMotif* ]]
    then
      #topMotif FASTA files generated
      echo $temp >> exomesCohort/topMotifs/"$exomeCode"_topmotifs.fasta
      echo $gene >> exomesCohort/topMotifs/"$exomeCode"_topmotifs.fasta
    fi
    temp=$gene
  done
done
  

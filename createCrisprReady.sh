#!/bin/sh

#Create blank array for motifs to be stored in
motifArray=()

#Create empty dictionary for motif counts to be stored
declare -A countDict

#Makes a list of unique motifs, and empty array for the FASTA files
while read motif
do
  motifArray+=($motif)
done < motif_list.txt

#Makes a directory to hold topMotif FASTA files
mkdir exomesCohort/topMotifs

#Loops through FASTA files in exomesCohort directory looking for frequent motifs
for exome in exomesCohort/*.fasta
do
  #Extracts exome code name from file path
  exomeCode=$(basename $exome .fasta)
  #Finds motif frequency
  for motif in ${motifArray[@]}
  do
    count=$(grep -Fo $motif $exome| wc -l)
    countDict[$motif]=$count
  done
  #Finds the three most frequent motifs
  firstMost=0
  firstMotif=""
  
  secondMost=0
  secondMotif=""
  
  thirdMost=0
  thirdMotif=""
  for key in ${!countDict[@]}
  do
  current=${countDict[$key]}
  if (( $current >= $firstMost ))
  then
    thirdMost=$secondMost
    thirdMotif=$secondMotif

    secondMost=$firstMost
    secondMotif=$firstMotif

    firstMost=$current
    firstMotif=$key
  elif (( $current >= $secondMost ))
  then
    thirdMost=$secondMost
    thirdMotif=$secondMotif

    secondMost=$current
    secondMotif=$key
  elif (( $current >= $thirdMost ))
  then
    thirdMost=$current
    thirdMotif=$key
  fi
  done
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
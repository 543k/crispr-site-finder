#!/bin/sh

#Create blank array for exome code names to be stored in
exomeArray=()

#Loops through clinical data (skipping first line), storing column values as variables, and storing code names of desired exomes
while IFS=$'\t\n' read discoverer location diameter environment status code
do
  if (( $diameter >= 20 && $diameter <= 30 ))
  then
    if [[ "$status" == Sequenced ]]
    then
      exomeArray+=("$code")
    fi
  fi
done < <(tail -n +2 ./clinical_data.txt)

#Makes directory for desired exome fasta files, and copies the correct exomes
mkdir ./exomesCohort
for exome in ${exomeArray[@]}
do
  cp ./exomes/"$exome.fasta" ./exomesCohort/
done

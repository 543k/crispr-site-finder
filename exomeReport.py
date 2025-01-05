import os
import csv

#Declaring variables for directory of FASTA files, list of FASTA files, list of genes, and list of code names
fastaPath = "./exomesCohort/preCrispr"
exomesList = os.listdir(fastaPath)
geneList = []
codeList = []

#Reads through the FASTA files adding unique genes to geneList
for exomes in exomesList:
    codeList.append(exomes.partition("_")[0])
    with open(fastaPath+"/"+exomes,'r') as file:
        for line in file:
            if ">" in line:
                if line not in geneList:
                    geneList.append(line.strip())

#Reads the clinical data, writing info of the organisms found in codeList to report.txt
report = open('report.txt', 'a')
with open('clinical_data.txt', 'r') as file:
    reader = csv.reader(file, delimiter='\t')
    for row in reader:
        if row[5] in codeList:
            report.write("Organism "+row[5]+", discovered by "+row[0]+", has a diameter of "+row[2]+", and from the environment "+row[3]+".\n")

#Writing the union of genes to report.txt
report.write("The number of the union of genes across the cohort is " + str(len(geneList)) + ". Those genes are: ")
for gene in geneList:
    report.write(gene[1:]+" ")
report.close()

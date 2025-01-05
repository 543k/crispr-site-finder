# Goal: To identify a list of suitable CRISPR gene candidates, and generate a report.
# Author: Vivek Mathew
# Email: vivekmathew@brandeis.edu
# Date: 11/05/2024


## Motif Finder Scripts ###

### Description ###
Four bash scripts, and a python script are used to identify/report the CRISPR gene candidates. The scripts read clinical data from a text file (clinical_data.txt) in order to generate a list of code names of exomes (that were sequenced and have the proper diameter). This list is used to copy the respective FASTA files from the direcory exomes into a new directory exomesCohort. These FASTA files are then made CRISPR ready by outputting new FASTA files to the directory topMotifs (in exomesCohort) that contain gene sequences that include the highest frequent motifs (from the motif_list.txt). These FASTA files are then searched for suitable CRISPR sites and new corresponding FASTA files are outputted to the preCrispr directory (in exomesCohort). Lastly these FASTA files are edited to indicate the CRISPR suitable sites, the resulting new FASTA files are outputted to the postCrispr directory (in exomesCohort). Finally a python script is used to generate a report of the findings.

Input:

A txt file containing clinical data (named clinical_data.txt).
A file called motif_list.txt containing a list of motifs (one motif per line) that the script will search for.
A directory containing FASTA files of animal exomes (named exomes).

Output:

Multiple sets of FASTA file sets: exomesCohort, topMotifs, preCrispr, postCrispr. These FASTA file sets are in respectively named directories.
A text file (report.txt) summarizing the findings.

How to Run:

To execute the script, navigate to the directory containing the script files (ensuring the above input files are in the same directory) and run:

chmod +X copyExomes.sh
bash copyExomes.sh
chmod +X createCrisprReady.sh
bash createCrisprReady.sh
chmod +X identifyCrisprSite.sh
bash identifyCrisprSite.sh
chmod +X editGenome.sh
bash editGenome.sh
chmod +X exomeReport.py
python3 exomeReport.py

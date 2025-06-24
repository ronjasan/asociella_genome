#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --job-name=canu
#SBATCH --mem=3G

conda activate mymicromamba
eval "$(micromamba shell hook --shell=bash)"

canu -d canu_0.02 \
	-p WGA_Asoc genomeSize=400M correctedErrorRate=0.02 \
	-nanopore-raw WGS_Asoc.4000.q7.50h.fastq.gz
 
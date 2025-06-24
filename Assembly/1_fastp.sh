#!/bin/bash
#SBATCH --ntasks=5
#SBATCH --nodes=1
#SBATCH --mem=10G

INFILE=WGS_Asoc.fastq.gz
OUTFILE=WGS_Asoc.4000.q7.50h.fastq.gz
STATS=${OUTFILE%.fastq.gz} 

L=50
Q=7
F=400

fastp -w $SLURM_NTASKS -i ${INFILE} --stdin -z 4 -o ${OUTFILE} -V  --disable_trim_poly_g --disable_adapter_trimming \
-q ${Q} -l ${L} -f ${F} -R ${STATS} -h ${STATS}.html -j ${STATS}.json
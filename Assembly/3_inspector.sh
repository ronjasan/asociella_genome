#!/bin/bash
#SBATCH --ntasks=10             
#SBATCH --nodes=1   
#SBATCH --mem=30G
#SBATCH --partition=smallmem

module load Miniconda3
eval "$(conda shell.bash hook)"
conda activate ins

export PATH=/softwares/Inspector:${PATH}
export PYTHONPATH=/softwares/Inspector:${PYTHONPATH}

genome=canu_0.02/WGA_Asoc.contigs.fasta
read=WGS_Asoc.4000.q7.50h.fastq.gz
out_inspector=canu_0.02/inspector

inspector.py -t 10 -c $genome -r $read -o $out_inspector --datatype nanopore
inspector-correct.py -t 10 -i $out_inspector --datatype nano-hq -o ${out_inspector}_correct
inspector.py -t 10 -c ${out_inspector}_correct/contig_corrected.fa -r $read -o ${out_inspector}_correct/inspector --datatype nanopore
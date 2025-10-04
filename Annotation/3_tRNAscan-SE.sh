#!/bin/bash
#SBATCH --ntasks=20
#SBATCH --nodes=2
#SBATCH --mem=50G

mamba activate tRNAscan-SE

out=canu_0.02/egapx/trnascan
genome=canu_0.02/GCA_052324605.1.fna

tRNAscan-SE -E $genome -o $out/trnascan.txt -m $out/stats.txt -j $out/trnas.gff -a $out/trnas.faa -l $out/trnas.log --detail
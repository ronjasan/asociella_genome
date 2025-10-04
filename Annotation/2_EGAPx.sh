#!/bin/bash
#SBATCH --ntasks=20
#SBATCH --nodes=2
#SBATCH --mem=50G

source ~/tools/egapx/venv/bin/activate

out=canu_0.02/egapx
genome=canu_0.02/GCA_052324605.1.fna

python3 ~/tools/egapx/ui/egapx.py $out/annotate.yaml -dl -lc $out/database

python3 ~/tools/egapx/ui/egapx.py $out/annotate.yaml -w $out/tmp -o $out/refseq -lc $out/database -e singularity
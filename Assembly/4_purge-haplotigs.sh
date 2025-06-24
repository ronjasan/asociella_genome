#!/bin/bash
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --mem=15G
##SBATCH --partition=hugemem --constraint=avx2

conda activate mymicromamba
eval "$(micromamba shell hook --shell=bash)"

micromamba activate purge_haplotigs

genome=canu_0.02/inspector_correct/contig_corrected.fa
bam=canu_0.02/inspector_correct/inspector/read_to_contig.bam
bam1=${bam%.bam}_nosecondary.bam
outdir=canu_0.02/purge_haplotigs
out_base=WGA_Asoc_correct_ph

cd $outdir

samtools view -bh -F 256 $bam > $bam1     

purge_haplotigs hist -b $bam1 -g $genome -t 4    

purge_haplotigs cov -i read_to_contig_nosecondary.bam.gencov -l 5 -m 100 -h 200 -o read_to_contig_nosecondary.coverage_stats.csv 

purge_haplotigs purge -g $genome -c read_to_contig_nosecondary.coverage_stats.csv \
	-t 4 -d -b $bam1 -o $out_base

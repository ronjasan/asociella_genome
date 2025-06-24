#!/bin/bash
#SBATCH --ntasks=10
#SBATCH --nodes=1
#SBATCH --mem=30G

export SHM_LOC=/mnt/databases

taxid=688607
genome=canu_0.02/purge_haplotigs/WGA_Asoc_correct_ph.fasta
out=canu_0.02/fcsgx

mkdir -p ${out}

python3 $HOME/gitlab/orivo/fcsgx/run_fcsgx.py --fasta ${genome} \
	--out-dir $out \
	--gx-db "${SHM_LOC}/gxdb/all" --gx-db-disk "${SHM_LOC}/gxdb/all.gxi" \
	--split-fasta --tax-id $taxid --container-engine=singularity \
	--image=$HOME/gitlab/orivo/fcsgx/fcsgx.sif

cat $genome | python3 $HOME/gitlab/orivo/fcsgx/fcs.py clean $genome --action-report ${out}/WGA_Asoc_correct.688607.fcs_gx_report.txt \
--output ${out}/WGA_Asoc_correct_clean.fasta --contam-fasta-out ${out}/WGA_Asoc_correct_contam.fasta
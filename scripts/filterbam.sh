#!/bin/bash

WD=/scratch/externe/ifremer/pauffret/remap_assembly_trinity_PE_norm_10samples_BWA_longest_orfs.cds_corresponding_transcripts_matrix.TPM.not_cross_norm_per_sample_filter_low_expr_0.5_highest_iso_only_filter_low_expression_transcripts

cd $WD

for file in $(ls *.bam)
do
	cp ${WD}/header.txt ${WD}/filter_${file}.qsub ;
	echo "samtools view -b -F 4 -F 256 -q 5 ${WD}/${file} > ${WD}/filtered_bam/${file%.*}_F4_F256_q5.bam " >> ${WD}/filtered_bam/filter_${file}.qsub ;
	echo "samtools flagstat ${WD}/filtered_bam/${file%.*}_F4_F256_q5.bam > ${WD}/filtered_bam/${file%.*}_F4_F256_q5.bam.flagstat " >> ${WD}/filtered_bam/filter_${file}.qsub ;
	qsub -q long.q ${WD}/filter_${file}.qsub ;
done


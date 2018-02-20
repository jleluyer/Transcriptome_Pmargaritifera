#!/bin/bash

DATA_DIRECTORY=/projet/externe/ifremer/pauffret/pinctada_transcriptome_assembly/archives/rawdata
TRIMMING_SCRIPT=/projet/externe/ifremer/pauffret/pinctada_transcriptome_assembly/script/trimming_trimmomatic_PE.qsub


cd $DATA_DIRECTORY
for dir in $(ls) ;
do
	if [[ ${dir##*.} != "txt" ]] ;
	#if [[ $dir == "HI.4254.008.Index_15.TB2" || $dir == "HI.4254.008.Index_7.TB9" ]]
	#if [[ $dir != "HI.4254.008.Index_15.TB2" && $dir != "HI.4254.008.Index_7.TB9" && $dir != "HI.4254.008.Index_15.TB2_incomplet" && $dir != "fastqc_raw_reads" && $dir != "wget_files_nanuq" && $dir != "md5sum_check_samples_tr_after_copy.txt" && $dir != "md5sum_check_samples_tr_before_copy.txt" ]] ;
	then
		cd $dir ;
		qsub $TRIMMING_SCRIPT ;
		cd .. ;
	fi ;
done


#!/bin/bash

DATA_DIRECTORY=/projet/externe/ifremer/pauffret/pinctada_transcriptome_assembly/archives/rawdata
TRIMMING_SCRIPT=/projet/externe/ifremer/pauffret/pinctada_transcriptome_assembly/script/fastqc_raw_reads.qsub


cd $DATA_DIRECTORY
for dir in $(ls) ;
do
	if [[ ${dir##*.} != "txt" ]] ;
	then
		cd $dir ;
		qsub $TRIMMING_SCRIPT ;
		cd .. ;
	fi ;
done


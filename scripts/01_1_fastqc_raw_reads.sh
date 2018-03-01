#!/bin/bash

DATA_DIRECTORY=		#path to raw data directory
TRIMMING_SCRIPT=	#path to fastqc_raw_reads.qsub script

#Running trimming script on every fastq files
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


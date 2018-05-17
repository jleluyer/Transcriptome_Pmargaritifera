#!/bin/bash

DATA_DIRECTORY=		#path to raw data directory
QC_SCRIPT=		#path to 01_2_fastqc_raw_reads.qsub script

#Running trimming script on every fastq files
cd $DATA_DIRECTORY
for dir in $(ls) ;
do
	if [[ ${dir##*.} != "txt" ]] ;
	then
		cd $dir ;
		qsub $QC_SCRIPT ;
		cd .. ;
	fi ;
done


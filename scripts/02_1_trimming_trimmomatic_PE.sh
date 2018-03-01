#!/bin/bash

DATA_DIRECTORY=		#path to raw fastq files directory
TRIMMING_SCRIPT=	#path to trimming_trimmomatic_PE.qsub script


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


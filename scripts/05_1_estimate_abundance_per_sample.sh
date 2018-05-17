#!/bin/bash

#PBS parameters...

#Global variables
ASSEMBLY=		#path to transcriptome assembly fasta file resulting from step 04_2
TAG="${ASSEMBLY##*/}_estimate_abundance_per_sample"
WORKING_DIRECTORY=	#path to working/output directory
DATA_DIR=		#path to trimmed fastq files directory
SCRIPT=			#path to script directory
HEADER=			#path to header.txt file

#Trinity variables
TRINITY_EXEC=		#path to Trinity exec (.../trinityrnaseq-2.4.0/Trinity)
TRINITY_UTIL_DIR=	#path to Trinity util (../trinityrnaseq-2.4.0/util)
VERSION="2.4.0"
SEQ_TYPE="fq"	#fastq input files
LEFT_1="${DATA_DIR}/HI.4112.001.D707---D506.X4/HI.4112.001.D707---D506.X4_R1_paired.fastq.gz"
LEFT_2="${DATA_DIR}/HI.4112.001.D707---D507.X6/HI.4112.001.D707---D507.X6_R1_paired.fastq.gz"
LEFT_3="${DATA_DIR}/HI.4112.001.D708---D504.X13/HI.4112.001.D708---D504.X13_R1_paired.fastq.gz"
LEFT_4="${DATA_DIR}/HI.4112.002.D710---D502.X19/HI.4112.002.D710---D502.X19_R1_paired.fastq.gz"
LEFT_5="${DATA_DIR}/HI.4112.002.D710---D503.X21/HI.4112.002.D710---D503.X21_R1_paired.fastq.gz"
LEFT_6="${DATA_DIR}/HI.4112.002.D711---D501.X30/HI.4112.002.D711---D501.X30_R1_paired.fastq.gz"
LEFT_7="${DATA_DIR}/HI.4254.008.Index_15.TB2/HI.4254.008.Index_15.TB2_R1_paired.fastq.gz"
LEFT_8="${DATA_DIR}/HI.4254.008.Index_7.TB9/HI.4254.008.Index_7.TB9_R1_paired.fastq.gz"
LEFT_9="${DATA_DIR}/SRR1039667_sample123/SRR1039667_sample123_R1_paired_readIDModif.fastq.gz"
LEFT_10="${DATA_DIR}/SRR1041217_sample144/SRR1041217_sample144_R1_paired_readIDModif.fastq.gz"
RIGHT_1="${DATA_DIR}/HI.4112.001.D707---D506.X4/HI.4112.001.D707---D506.X4_R2_paired.fastq.gz"
RIGHT_2="${DATA_DIR}/HI.4112.001.D707---D507.X6/HI.4112.001.D707---D507.X6_R2_paired.fastq.gz"
RIGHT_3="${DATA_DIR}/HI.4112.001.D708---D504.X13/HI.4112.001.D708---D504.X13_R2_paired.fastq.gz"
RIGHT_4="${DATA_DIR}/HI.4112.002.D710---D502.X19/HI.4112.002.D710---D502.X19_R2_paired.fastq.gz"
RIGHT_5="${DATA_DIR}/HI.4112.002.D710---D503.X21/HI.4112.002.D710---D503.X21_R2_paired.fastq.gz"
RIGHT_6="${DATA_DIR}/HI.4112.002.D711---D501.X30/HI.4112.002.D711---D501.X30_R2_paired.fastq.gz"
RIGHT_7="${DATA_DIR}/HI.4254.008.Index_15.TB2/HI.4254.008.Index_15.TB2_R2_paired.fastq.gz"
RIGHT_8="${DATA_DIR}/HI.4254.008.Index_7.TB9/HI.4254.008.Index_7.TB9_R2_paired.fastq.gz"
RIGHT_9="${DATA_DIR}/SRR1039667_sample123/SRR1039667_sample123_R2_paired_readIDModif.fastq.gz"
RIGHT_10="${DATA_DIR}/SRR1041217_sample144/SRR1041217_sample144_R2_paired_readIDModif.fastq.gz"
 
NB_CPU=8
MAX_MEM="100G"
EST_METHOD="RSEM"
ALN_METHOD="bowtie2"
bowtie2_RSEM="\"--no-mixed --no-discordant --end-to-end --gbar 1000 -k 200 \" "

#Sourcing java 1.8 if needed
source #java path

mkdir -p $WORKING_DIRECTORY/$TAG

cd $WORKING_DIRECTORY/$TAG

#Run trinity align_and_estimate_abundance.pl script on fastq files
for i in {1..10}
do
	R1=LEFT_$i ;
	R2=RIGHT_$i ;
	temp=${!R1##*/} ;
        prefix=${temp%%_R1*} ;
	cp ${HEADER} ${SCRIPT}/${TAG}_$prefix.qsub ;
	echo "time ${TRINITY_UTIL_DIR}/align_and_estimate_abundance.pl --transcripts $ASSEMBLY --seqType $SEQ_TYPE --left ${!R1} --right ${!R2} --est_method $EST_METHOD --aln_method $ALN_METHOD --bowtie2_RSEM $bowtie2_RSEM --thread_count $NB_CPU --trinity_mode  --output_prefix ${prefix} --output_dir $WORKING_DIRECTORY " >>  ${SCRIPT}/${TAG}_$prefix.qsub ;
	qsub ${SCRIPT}/${TAG}_$prefix.qsub ;
done









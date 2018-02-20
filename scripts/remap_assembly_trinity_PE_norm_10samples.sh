#!/bin/bash


#Global variables
ASSEMBLY=/projet/externe/ifremer/pauffret/pinctada_transcriptome_assembly/finalresult/Trinity.transcriptome.300118.fa
WORKING_DIRECTORY=/scratch/externe/ifremer/pauffret

#DATA_DIR=/scratch/externe/ifremer/pauffret/pinctada_transcriptome_assembly/results/trimming_trimmomatic/paired_fastq_files
DATA_DIR=/projet/externe/ifremer/pauffret/pinctada_transcriptome_assembly/input/trimming_trimmomatic/paired_fastq_files
SCRIPT=${PROJET}/pinctada_transcriptome_assembly/script/final_pipeline
HEADER=${SCRIPT}/header.txt
BWA=/usr/local/genome2/bwa/bwa
INDEX=0

#Trinity variables
TRINITY_EXEC=/usr/local/genome2/trinityrnaseq-2.4.0/Trinity 
TRINITY_UTIL_DIR=/usr/local/genome2/trinityrnaseq-2.4.0/util
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
NB_CPU=16
MAX_MEM="100G"
EST_METHOD="RSEM"
ALN_METHOD="bowtie2"

TAG="remap_assembly_trinity_PE_norm_10samples_BWA_${ASSEMBLY##*/}"

#Sourcing java 1.8
source /usr/local/genome2/envs/java-1.8-activate


if [[ $INDEX == 0 ]]
then
	cp ${HEADER} ${SCRIPT}/create_bwa_index_${ASSEMBLY##*/}.qsub ;
	echo "time ${BWA} index $ASSEMBLY" >> ${SCRIPT}/create_bwa_index_${ASSEMBLY##*/}.qsub ;
	qsub ${SCRIPT}/create_bwa_index_${ASSEMBLY##*/}.qsub ;
else


#Running bwa
mkdir -p $WORKING_DIRECTORY/$TAG

cd $WORKING_DIRECTORY/$TAG

#BWA
for i in {1..10}
do
	R1=LEFT_$i ;
	R2=RIGHT_$i ;
	temp=${!R1##*/} ;
	prefix=${temp%%_R1*} ;
	cp ${HEADER} ${SCRIPT}/remapping_BWA_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "time ${BWA} mem -t ${NB_CPU} -M ${ASSEMBLY} ${!R1} ${!R2} > ${WORKING_DIRECTORY}/${TAG}/${prefix}.bam" >> ${SCRIPT}/remapping_BWA_${ASSEMBLY##*/}_${prefix}.qsub
	qsub ${SCRIPT}/remapping_BWA_${ASSEMBLY##*/}_${prefix}.qsub ;
done

fi

 

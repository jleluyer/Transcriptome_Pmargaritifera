#!/bin/bash


#Global variables
ASSEMBLY_DIR=					#path to transcriptome directory
ASSEMBLY=					#path to transcriptome assembly
WORKING_DIRECTORY=				#path to working/output directory
DATA_DIR=					#path to trimmed fastq files directory
SCRIPT=						#path to script directory
HEADER=						#path to header.txt file (containing PBS parameters)	
GSNAP=						#path to GSNAP version 2017-10-30 (.../gmap/bin/gsnap)
GMAP_BUILD=  					#path to GMAP build version 2017-10-30 (.../gmap/bin/gmap_build)
SAMTOOLS=					#path to samtools version 1.6 
INDEX=1						#boolean : if 1 index already built, Else 0
PLATFORM="Illumina"				#sequencing platform
TRANSCRIPTOME_NAME=${ASSEMBLY##*/}_gmap		#transcriptome assembly gmap name

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
NB_CPU=16				#number of CPU
MIN_COV="0.5"				#minimum coverage

TAG="remap_assembly_GSNAP_${ASSEMBLY##*/}"

#Create transcriptome index if not existing
if [[ $INDEX == 0 ]]
then
        cp ${HEADER} ${SCRIPT}/create_gmap_index_${ASSEMBLY##*/}.qsub ;
        echo "time ${GMAP_BUILD} -D ${ASSEMBLY_DIR} -d ${TRANSCRIPTOME_NAME} ${ASSEMBLY}" >> ${SCRIPT}/create_gmap_index_${ASSEMBLY##*/}.qsub ;
        qsub ${SCRIPT}/create_gmap_index_${ASSEMBLY##*/}.qsub ;
else

#Running GSNAP
mkdir -p $WORKING_DIRECTORY/$TAG

cd $WORKING_DIRECTORY/$TAG

#GSNAP
for i in {1..10}
do
	R1=LEFT_$i ;
	R2=RIGHT_$i ;
	temp=${!R1##*/} ;
	prefix=${temp%%_R1*} ;
	cp ${HEADER} ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "time ${GSNAP} --gunzip -t ${NB_CPU} -A sam --min-coverage=${MIN_COV} -D ${ASSEMBLY_DIR} -d ${TRANSCRIPTOME_NAME} --split-output=${WORKING_DIRECTORY}/${TAG}/${prefix} --max-mismatches=5 --novelsplicing=1  --read-group-platform=${PLATFORM} ${!R1} ${!R2}" >> ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "$SAMTOOLS view -b ${WORKING_DIRECTORY}/${TAG}/${prefix}.concordant_uniq > ${WORKING_DIRECTORY}/${TAG}/${prefix}.concordant_uniq.bam " >> ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "$SAMTOOLS view -b ${WORKING_DIRECTORY}/${TAG}/${prefix}.paired_uniq_inv > ${WORKING_DIRECTORY}/${TAG}/${prefix}.paired_uniq_inv.bam " >> ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "$SAMTOOLS view -b ${WORKING_DIRECTORY}/${TAG}/${prefix}.paired_uniq_long > ${WORKING_DIRECTORY}/${TAG}/${prefix}.paired_uniq_long.bam " >> ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "$SAMTOOLS merge ${WORKING_DIRECTORY}/${TAG}/${prefix}.bam ${WORKING_DIRECTORY}/${TAG}/${prefix}.concordant_uniq.bam ${WORKING_DIRECTORY}/${TAG}/${prefix}.paired_uniq_inv.bam ${WORKING_DIRECTORY}/${TAG}/${prefix}.paired_uniq_long.bam " >> ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "$SAMTOOLS sort ${WORKING_DIRECTORY}/${TAG}/${prefix}.bam -o ${WORKING_DIRECTORY}/${TAG}/${prefix}_sorted.bam" >> ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "$SAMTOOLS index ${WORKING_DIRECTORY}/${TAG}/${prefix}_sorted.bam" >> ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	echo "$SAMTOOLS flagstat ${WORKING_DIRECTORY}/${TAG}/${prefix}_sorted.bam > ${WORKING_DIRECTORY}/${TAG}/${prefix}_sorted.bam.flagstat" >> ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	#echo "rm ${WORKING_DIRECTORY}/${TAG}/${prefix}.bam ${WORKING_DIRECTORY}/${TAG}/${prefix}.sam" >> ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
	qsub ${SCRIPT}/remapping_GSNAP_${ASSEMBLY##*/}_${prefix}.qsub ;
done

fi



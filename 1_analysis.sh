#!/bin/bash

if [ ! -d 'cut_sgrna' ];then
	mkdir cut_sgrna
fi
if [ ! -d 'cut_log' ];then
	mkdir cut_log
fi
if [ ! -d 'sgrna_index' ];then
	mkdir sgrna_index
fi
if [ ! -d 'alignment' ];then
	mkdir alignment
fi
if [ ! -d 'sgrna_counts' ];then
	mkdir sgrna_counts
fi


adapter5='CGAAACACCG'
adapter3='GTTTTAGAGC'
r_adapter5='GCTCTAAAAC'
r_adapter3='CGGTGTTTCG'

#Pre_step1. build indexes for sgRNA library
#awk -F ',' '{print ">"$1"\n"$2}' human_geckov2_library_a_and_b.csv > human_geckov2_library_a_and_b.fa
#../tools/bowtie2/bowtie2-build human_geckov2_library_a_and_b.fa sgrna_index/human_geckov2_library_a_and_b
samples=('A231_7day' 'A231_21day' 'A21mng_M1_3_7day' 'A21mng_M1_3_21day')
samples_name=""
samples_bam=""
for sample in ${samples[@]}
do
	samples_name+=$sample','
	samples_bam+='alignment/'$sample'.bam '
done
names=${samples_name:0:-1}
for sample in ${samples[@]}
do
	F_file=$sample'_Forward.fastq'
	R_file=$sample'_Reverse.fastq'
	#Step1. extract potential sgrna region
	cutadapt -n 2 -g $adapter5 -a $adapter3 -G $r_adapter5 -A $r_adapter3 --discard-untrimmed --info-file=cut_log/${sample}.log -o cut_sgrna/cut_$F_file -p cut_sgrna/cut_$R_file data/$F_file data/$R_file 

	#Step2. align sample sgRNAs to library
	../tools/bowtie2/bowtie2 -p 2 --norc -x sgrna_index/human_geckov2_library_a_and_b -1 cut_sgrna/cut_$F_file -2 cut_sgrna/cut_$R_file -S alignment/${sample}.sam 2>alignment/${sample}.log 
	#Step3. transfer into bam files
	samtools view -bS alignment/${sample}.sam > alignment/${sample}.bam
done
#Step4. get sgRNA read counts
mageck count -l human_geckov2_library_a_and_b.csv -n sgrna_counts/sgrna_raw --sample-label $names --fastq $samples_bam

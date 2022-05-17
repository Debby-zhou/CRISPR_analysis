# Pipeline for CRISPR knockout NGS data analysis
## Used softwares 
- python 3.6.13
- cutadapt 3.5
- bowtie2 2.4.5
- samtools 1.10
- mageck 0.5.9.5
## Platforms
If you are in 248 server, then please use built virtual environment(crisprenv) by conda.
```
# show env list
conda env list
# activate the environment
source activate crisprenv
# deactivate the environment
conda deactivate
```
However, if you want to set up the environment from the start, please follow the below commands.
```
conda config --get channels
conda config --add bioconda
conda install -c bioconda mageck
conda create -c bioconda -n crisprenv mageck
conda install -c bioconda samtools bowtie2 cutadapt
```
If you are in 243 server, then please download all softwares from their officials.

## Pipeline
1. extract potential sgRNA clips from raw fastq files
2. generate sgrna library fasta file then build index
3. align potential clips to sgRNA library to get hits
4. transfer aligned results into bam format
5. get sgRNA raw counts

More details please see 1_analysis.sh.


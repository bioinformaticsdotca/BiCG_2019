---
layout: tutorial_page
permalink: /bicg_2018_ia2
title: BiCG
header1: Bioinformatics for Cancer Genomics 2018
header2: Integrative Assignment Day 2
image: /site_images/CBW_cancerDNA_icon-16.jpg
home: https://bioinformaticsdotca.github.io/bicg_2018
description: Integrative Assignment Day 2
author: Hamza Farooq
modified: Marh 16th, 2018
---

# Integrated Assignment - Overview of Day 2

The following assignment will involve aligning a subset of reads from the the tumour and normal HCC1395 cell line samples to the human reference genome, and then perform copy number analysis on the samples. However, in this assignment, we'll be building all the indices of our reference genome as well perform perform the preprocessing for Titan. We will be following a similar procedure to the labs from Modules 5 and 6, including the `Data Preprocessing` sections, to properly process the samples. The analysis will be focused on chromosome 20 due to time constraints.

The fastq files for this assignment are stored in the following directory:

Task list:  
1) Build a bwa and bowtie2 index, as well as index our fasta  
2) Align our reads to the reference genome using bwa  
3) Convert the sam file to a sorted bam  
4) Generate a reference genome mappability file \*  
5) Generate a reference genome GC content file  
6) Calculate tumor and normal depth  
7) Identify heterozygous germline positions in the normal  
8) Call CNAs with Titan  

\* Because this step takes about an hour, we're going to copy the results from the command for the sake of time.

First let's set up our working folder and create an environment variable to help navigate our paths. We're also going to make a folder to hold our logs and errors for our processes in a separate folder called "jobs"

```
cd ~/workspace;
mkdir IA_tuesday;
cd IA_tuesday;
IA_HOME="/home/ubuntu/workspace/IA_tuesday"
mkdir jobs;
JOB_OUT=$IA_HOME"/jobs"
```

Now that we've setup our working directory, we can link our reference data and our tumour/normal data

```
ln -s ~/CourseData/CG_data/IA_tuesday/data
mkdir ref;
ln -s ~/CourseData/CG_data/IA_tuesday/refs/chr20_adj/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa ref/;
```

Let's start with building our reference indices for bwa and bowtie2. Make sure to consult each respective tool's page in the future to view all the options available.

```
bwa index $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa > $JOB_OUT/bwa_index.log 2>$JOB_OUT/bwa_index.err &
bowtie2-build -t 8 $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa > $JOB_OUT/bowtie2_index.log 2>$JOB_OUT/bowtie2_index.err &
samtools faidx $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa &
```

Once this is complete, we're going to use bwa to align our fastq files to the reference genome. This will take just under 3 minutes.

```
bwa mem -t 4 $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa $IA_HOME/data/HCC1395_norm.chr20.comb.fq | samtools view -bS | samtools sort > $IA_HOME/bams/HCC1395_norm.chr20.sorted.bam &
bwa mem -t 4 $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa $IA_HOME/data/HCC1395_tum.chr20.comb.fq | samtools view -bS | samtools sort > $IA_HOME/bams/HCC1395_tum.chr20.sorted.bam &
```

When our alignment is completed, we're going to index our bam files for easier parsing

```
samtools index $IA_HOME/bams/HCC1395_norm.chr20.sorted.bam 2>$JOB_OUT/index_norm.err &
samtools index $IA_HOME/bams/HCC1395_tum.chr20.sorted.bam 2>$JOB_OUT/index_tum.err &
```

Now that the setup has been done, we can start with actually analyzing our samples. Let's set up some more environment variables to where a few key scripts are stored.

```
SCRIPTS_DIR=~/CourseData/CG_data/Module6/scripts
INSTALL_DIR=~/CourseData/CG_data/Module6/install
HMMCOPY_DIR=~/CourseData/CG_data/Module6/install/hmmcopy/HMMcopy
```

Now we'll generate a reference genome mappability file. The following step typically takes about an hour even with our analysis being focused on just chromosome 20, so alternatively the processed file is available [here](https://github.com/bioinformaticsdotca/BiCG_2018/blob/master/IntegrativeAssignment2/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa.map.ws_1000.wig).

```
cd ref; curl -o Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa.map.ws_1000.wig https://github.com/bioinformaticsdotca/BiCG_2018/blob/master/IntegrativeAssignment2/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa.map.ws_1000.wig
```

However, to run it yourself, the following two commands are needed (wait till the first one is done before running the second one)

```
cd ref;
$HMMCOPY_DIR/util/mappability/internal/fastaToRead -w 35 Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa | bowtie2 -x $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa -f /dev/stdin -p 16 -N 0 -k 5 --quiet | grep "20:" | cut -f 1 | uniq -c | awk '{print $2"\tign\tign\tign\tign\tign\t"$1}' | $HMMCOPY_DIR/util/mappability/internal/readToMap.pl -m 4 | $HMMCOPY_DIR/util/bigwig/wigToBigWig stdin Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa.sizes Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa.map.bw &

$HMMCOPY_DIR/bin/mapCounter \
	-w 1000 \
	$IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa.map.bw \
	> $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa.map.ws_1000.wig &
```

We will now also generate our reference GC content file

```
$HMMCOPY_DIR/bin/gcCounter \
	$IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa \
	> $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.gc.wig &
```

Now that our coverage and mappability files have been created, we can calculate our tumor and normal depth for chromosome 20

```
cd $IA_HOME;
mkdir -p $IA_HOME/hmmcopy
$HMMCOPY_DIR/bin/readCounter \
	-c 20 \
	$IA_HOME/bams/HCC1395_norm.chr20.sorted.bam > $IA_HOME/hmmcopy/HCC1395_exome_tumour.wig &
$HMMCOPY_DIR/bin/readCounter \
	-c 20 \
	$IA_HOME/bams/HCC1395_norm.chr20.sorted.bam > $IA_HOME/hmmcopy/HCC1395_exome_normal.wig &
```

Our last step before running Titan is to identify heterozygous germline positions in the normal and extract allele counts in the tumour. Since this requires running mutationseq which calls python, we're going to add python to our PATH so that our system can use the program. We'll also use environment variables for ease of use

```
PYTHON_DIR=$INSTALL_DIR/miniconda/miniconda2
MUSEQ_DIR=$INSTALL_DIR/mutationseq/mutationseq/museq
REF_DIR=$IA_HOME/ref
export PATH=$PYTHON_DIR/lib/python2.7/site-packages/:$PATH
export LD_LIBRARY_PATH=$PYTHON_DIR/lib:$LD_LIBRARY_PATH
```
```
mkdir -p $IA_HOME/mutationseq
$PYTHON_DIR/bin/python $MUSEQ_DIR/preprocess.py \
	reference:$REF_DIR/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa \
	model:$MUSEQ_DIR/models_anaconda/model_single_v4.0.2_anaconda_sk_0.13.1.npz \
	tumour:$IA_HOME/bams/HCC1395_tum.chr20.sorted.bam \
	normal:$IA_HOME/bams/HCC1395_norm.chr20.sorted.bam \
	--verbose --single --coverage 4 --threshold 0.85 --buffer_size 2G \
	--out $IA_HOME/mutationseq/HCC1395_mutationseq.vcf \
	--log_file run_mutationseq.log \
	--config $MUSEQ_DIR/metadata.config \
	2> run_mutationseq.err
```

Once mutationseq is completed, we'll use our custom script to transform the vcf file to a counts file

```
$PYTHON_DIR/bin/python $SCRIPTS_DIR/transform_vcf_to_counts.py \
	--infile $IA_HOME/mutationseq//HCC1395_mutationseq.vcf \
	--outfile $IA_HOME/mutationseq/HCC1395_mutationseq_postprocess.txt
```

We're now going to link our install directory and scripts directory:
```
ln -s /home/ubuntu/CourseData/CG_data/Module6/install $IA_HOME
ln -s /home/ubuntu/CourseData/CG_data/Module6/scripts $IA_HOME
```

Finally we can run Titan using all the files we've created:

```
mkdir -p $IA_HOME/titan
cd $IA_HOME/titan
Rscript $IA_HOME/scripts/run_titan.R \
	--sample_id HCC1395 \
	--tumour_wig $IA_HOME/hmmcopy/HCC1395_exome_tumour.wig \
	--normal_wig $IA_HOME/hmmcopy/HCC1395_exome_normal.wig \
	--tumour_baf $IA_HOME/mutationseq/HCC1395_mutationseq_postprocess.txt \
	--gc_wig $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.gc.wig \
	--map_wig $IA_HOME/ref/Homo_sapiens.GRCh37.75.dna.primary_assembly.chr20_adjusted.fa.map.ws_1000.wig \
	--result_dir $IA_HOME/titan \
	--exome_bed ~/CourseData/CG_data/Module6/ref_data/NimbleGenExome_v3.bed \
	--num_clust 1 \
	--ploidy 2.0 \
	--normal_con 0.0 \
	> $JOB_OUT/run_titan.log \
	2> $JOB_OUT/run_titan.err &
```
In this case, the error that's created is due to the fact that Titan cannot create a valid error model at the "correctReadDepth" stage of the script due to lack of input data. This is because we're using exome data and only focused on chromosome 20, so the number of input data is too low. It's always a good idea to [search any errors](https://github.com/benjjneb/dada2/issues/171) you might come across during your own analysis.

---
layout: tutorial_page
permalink: /BiCG_2019_Module8_Lab
title: BiCG 2019 Module 8 Lab
header1: Workshop Pages for Students
header2: Bioinformatics for Cancer Genomics 2019
image: /site_images/CBW_cancerDNA_icon-16.jpg
home: https://bioinformaticsdotca.github.io/BiCG_2019
description: BiCG 2019 Module 8 Lab - Gene Expression
author: Florence Cavalli
modified: May 30th, 2019
---

# Lab Module 8 - Gene Expression

##Background
The PCA3 gene plays a role in Prostate Cancer detection due to its localized expression in prostate tissues and its over-expression in tumour tissues. This gene expression profile makes it a useful marker that can complement the most frequently used biomarker for prostate cancer, PSA. There are cancer assays available that test the presence of PCA3 in urine. 

##Objectives
In this assignment, we will be using a subset of the GSE22260 dataset, which consists of 30 RNA-seq tumour/normal pairs, to assess the prostate cancer specific expression of the PCA3 gene. 
Experimental information and other things to keep in mind:
- The libraries are polyA selected. 
- The libraries are prepared as paired end. 
- The samples are sequenced on a Illumina Genome Analyzer II (this data is now quite old). 
- Each read is 36 bp long 
- The average insert size is 150 bp with standard deviation of 38bp. 
- We will only look at chromosome 9 in this exercise. 
- The dataset is located here: GSE22260 
- 20 tumour and 10 normal samples are available 
- For this exercise we will pick 3 matched pairs (C02, C03, C06 for tumour and N02, N03, N06 for normal). We can do more if we have time. 

## PART 1: Obtaining Data and References
Goals:
- Obtain the files necessary for data processing 
- Familiarize yourself with reference and annotation file format 
- Familiarize yourself with sequence FASTQ format 
Create a working directory ~/workspace/Module8/Module8_Lab/ to store this exercise. Then create a unix environment variable named RNA_ASSIGNMENT that stores this path for convenience in later commands.

## Setup

First login into the server, and then enter the workspace directory:
In order to keep our files in one location, we're going to create a new directory for this module and enter it:

```
cd  ~/workspace
mkdir -p ~/workspace/Module8/
mkdir -p ~/workspace/Module8/Module8_Lab/
export RNA_LAB=~/workspace/Module8/Module8_Lab
```
## Obtain reference, annotation and data files and place them in the integrated assignment directory
Note: when initiating an environment variable, we do not need the $; however, everytime we call the variable, it needs to be preceded by a $.

```
echo $RNA_LAB
cd $RNA_LAB
cp ~/CourseData/CG_data/Module8/data.zip .
unzip data.zip
```

Check the files and set up the following environment variables

```
ls
ls fasta/*
ls refs/*
export RNA_DATA_DIR=$RNA_LAB/fasta
export RNA_REFS_DIR=$RNA_LAB/refs
export RNA_REF_INDEX=$RNA_REFS_DIR/Homo_sapiens.GRCh38.dna.chromosome.9
export RNA_REF_FASTA=$RNA_REF_INDEX.fa
export RNA_REF_GTF=$RNA_REFS_DIR/Homo_sapiens.GRCh38.86.chr9.gtf
export RNA_ALIGN_DIR=$RNA_LAB/hisat2
```

Q1) How many items are there under the “refs” directory (counting all files in all sub-directories)? 

A1) The answer is 12. Review these files so that you are familiar with them.

```
cd $RNA_LAB/refs/
tree
find *
find * | wc -l
```
What if this reference file was not provided for you? How would you obtain/create a reference genome fasta file for chromosome 9 only. How about the GTF transcripts file from Ensembl? How would you create one that contained only transcripts on chromosome 9?

Q2) How many exons does the gene PCA3 have?

A2) The answer is 4. Review the GTF file so that you are familiar with it. What downstream steps will we need this file for? What is it used for?

```
cd $RNA_LAB/refs
grep -w "PCA3" Homo_sapiens.GRCh38.86.chr9.gtf
grep -w "PCA3" Homo_sapiens.GRCh38.86.chr9.gtf | egrep "exon"
grep -w "PCA3" Homo_sapiens.GRCh38.86.chr9.gtf | egrep "exon" |wc -l
```

Q3) How many cancer/normal samples do you see under the data directory?

A3) The answer is 12. 6 normal and 6 tumor samples.
```
cd $RNA_LAB/fasta/
ls -l
ls -1 | wc -l
```

NOTE: The fasta files you have copied above contain sequences for chr9 only. We have pre-processed those fasta files to obtain chr9 and also matched read1/read2 sequences for each of the samples. You do not need to redo this.

Q4) What sample has the highest number of reads?

A4) The answer is that 'carcinoma_C06' has the most reads (288428/2 = 144214 reads).
An easy way to figure out the number of reads is to make use of the command ‘wc’. This command counts the number of lines in a file. Keep in mind that one sequence can be represented by multiple lines. Therefore, you need to first grep the read tag ">" and count those.

```
cd $RNA_LAB/fasta/
head carcinoma_C02_read1.fasta
```
>HWUSI-EAS230-R:2:88:885:1584#0/1
GCTCTTCGGTTCTTTCCTTCTTCAAGTGGTATGCTC
>HWUSI-EAS230-R:2:15:691:382#0/1
GGATTTTGACAAATCCTTATCTCCGGCCACCCCATA
>HWUSI-EAS230-R:2:52:111:1052#0/1
GCTGGAAAGCCACCAAGATGCTGACATTGAAGACTT
>HWUSI-EAS230-R:2:28:1640:236#0/1
CTCTGAGACGTCACCAAGTGCGGCGCCGGCAGCCTG
>HWUSI-EAS230-R:2:77:1205:89#0/1
GAGGGACACATTTGCTGTTTCTCCCGCAAGCAGATG
Running this command only give you 2 x read number:
```
cd $RNA_LAB/fasta/
wc -l YourFastaFile.fasta
wc -l *
```
Or  for the number of reads directly:
```
egrep ">" YourFastaFile.fasta |wc -l
```

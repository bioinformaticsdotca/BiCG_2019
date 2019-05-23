---
layout: tutorial_page
permalink: /day4_integrative_assignment
title: BiCG
header1: Bioinformatics for Cancer Genomics 2018
header2: Day 4 - Integrative Assignment
image: /site_images/CBW_cancerDNA_icon-16.jpg
home: https://bioinformaticsdotca.github.io/bicg_2018
---

# Day 4 - Integrative Assignment

## What did chmod 777 do?

[This link](https://www.maketecheasier.com/file-permissions-what-does-chmod-777-means/) describes what the numbers mean. (Scroll to What’s about the number?). The number 7 is equivalent the binary number 1-1-1, which is interpreted by chmod as +r+w+x. It is repeated three times for the *u*ser, *g*roup, and *o*thers.

The following two commands are equivalent:
```
chmod 777 $my_file

chmod ugo+rwx $my_file
```



## Installing programs without root access

Let's install bowtie!

#### With root access:

```
which bowtie
```
This gives no output. Bowtie cannot be found on our path. If it is installed, it is lost somewhere inside the computer.


Can we find bowtie on the linux repositories?

First, update the list of packages available
```
sudo apt-get update
```

Next, search for bowtie within the repositories.
```
apt-cache search bowtie
```
If you cannot find the name of your package here, use a search engine to find the name of the package you need.


Great. We found it. Now install.

```
sudo apt-get install bowtie
```
Now test that it can be found, and that it functions (ideally with a small test dataset)

```
which bowtie

bowtie
```

Done!





#### Without root access

Try to install as we did before:

```
sudo apt-get install bowtie
```
Sadness. No software for you.

This is because the default installation directory is "/usr/bin" or something similar. Without the correct permissions, you cannot write to these directories, therefore this installation method will fail.

Fortunately, there are many, MANY, MAAAAANY bioinformatics packages available through conda - a python-based package manager. Let's install that into OUR HOME DIRECTORY which we have permissions to modify.

First, make a directory where we will install our software.
```
SOFTWARE_HOME=/home/ubuntu/software
mkdir -p $SOFTWARE_HOME
cd $SOFTWARE_HOME
```

[Download the Anaconda installer from here](https://www.anaconda.com/download/#linux)
* 64-Bit (x86) Installer (533 MB)
* Right-click / copy link address
* Should be: https://repo.continuum.io/archive/Anaconda2-5.1.0-Linux-x86_64.sh

Download from commandline
```
wget https://repo.continuum.io/archive/Anaconda2-5.1.0-Linux-x86_64.sh
```

Run the install script:
```
bash Anaconda2-5.1.0-Linux-x86_64.sh
```
* Hold Enter to skip Readme
* Type yes
* Install to: /home/ubuntu/software/anaconda (or wherever you would like to keep this forever)
* "no" do not modify .bashrc (although you could if you want this to be maintained permanently)
* no do not get microsoft thing


Add conda to path
```
export PATH="/home/ubuntu/software/anaconda/bin:$PATH"
```
This line is what the conda installer offered to add to ~/.bashrc

You can add this manually if you would like.


Setup conda channels to download packages from
```
conda config --add channels r
conda config --add channels bioconda
conda config --add channels BioBuilds
```

Now you can install packages:

```
conda install bowtie
```

Or many packages at once:

```
conda install \
samtools \
picard \
igvtools \
bowtie \
bowtie2 \
gmap \
bwa \
chimerascan \
defuse \
perl-threaded \
perl-set-intervaltree \
star \
trinity
```




## Continuing with SNV calls


Make a directory to work in


Move there

```
IA_HOME=/home/ubuntu/workspace/IA_thursday
mkdir -p $IA_HOME
cd $IA_HOME
```

### ANNOVAR Annotations


What does ANNOVAR do?


The following command is what we ran yesterday.

(Note that we would need to redefine our environmental variable $ANNOVAR_DIR for this command to work.)
```
$ANNOVAR_DIR/table_annovar.pl \
results/mutect/mutect_passed.vcf \
$ANNOVAR_DIR/humandb/ \
-buildver hg19 \
-out results/annotated/mutect \
-remove \
-protocol refGene,cytoBand,genomicSuperDups,1000g2015aug_all,avsnp147,dbnsfp30a \
-operation g,r,r,f,f,f \
-nastring . \
--vcfinput
```


Make environmental variables to refer to out input and output files:
```
SNV_MODULE_DIR="/home/ubuntu/workspace/Module7_snv"
in_file=$SNV_MODULE_DIR/results/mutect/mutect_passed.vcf
out_file=$SNV_MODULE_DIR/results/annotated/mutect.hg19_multianno.vcf
```


All header lines contain the phrase "INFO=". Pull them out with grep.  

What is the difference between these headers?
```
grep "INFO=" $in_file
grep "INFO=" $out_file
```

To see the lines corresponding to (most of) our selected annotations
```
grep "INFO=" $out_file | grep -E "refGene|cytoBand|genomicSuperDups|1000g2015aug_all|avsnp147|dbnsfp30a"
```

Note that "annotation provided by ANNOVAR" is not a terribly helpful descriptor


The ANNOVAR user-guide provides more info
```
http://annovar.openbioinformatics.org/en/latest/user-guide/download/
http://annovar.openbioinformatics.org/en/latest/user-guide/filter/
```

Certain annotations provide a single piece of information:


cytoBand = Position along chromosome based on Giemsa-stained chromosomes


While others provide A LOT of information:


dbnsfp30a = "SIFT, PolyPhen2 HDIV, PolyPhen2 HVAR, LRT, MutationTaster, MutationAssessor, FATHMM, MetaSVM, MetaLR, VEST, CADD, GERP++, DANN, fitCons, PhyloP and SiPhy scores, but ONLY on coding variants"


Explore a few with the following links:


[SIFT](http://sift.jcvi.org/) predicts whether an amino acid substitution affects protein function. 


[PolyPhen-2](http://genetics.bwh.harvard.edu/pph2/)  (Polymorphism Phenotyping v2) is a tool which predicts possible impact of an amino acid substitution on the structure and function of a human protein using straightforward physical and comparative considerations.


[SiPhy](http://portals.broadinstitute.org/genome_bio/siphy/index.html) implements rigorous statistical tests to detect bases under selection from a multiple alignment data. 


### Adding additional databases to ANNOVAR

DO NOT run the following step today...

but in the future, you can download new annotations for use within annovar using:
```
annotate_variation.pl -buildver hg19 -downdb -webfrom annovar <Table Name>
```
We are skipping this today as the downloads can be very large and slow.


### Analysing SNV output


We already looked at .bam files to verify SNP calls from reads.


Can we visualize our specific SNPs in the context of other known SNPs?


Use these commands to view very reduced summaries of our generated data.
```
cat $SNV_MODULE_DIR/results/annotated/mutect.hg19_multianno.txt | cut -f1-3,7,9
cat $SNV_MODULE_DIR/results/annotated/strelka.hg19_multianno.csv | cut -d , -f1-3,7,9
```

How closely do the two SNV callers agree? What might explain the differences?


Looking at the annotated exonic functions, which SNV(s) might be expected to have functional consequences for the protein?


### Interactive exploration of SNVs
To further investigate this, use a web browser to navigate to St. Jude ProteinPaint
```
https://proteinpaint.stjude.org/
```

Perform the following steps to investigate one of our SNV calls:

* Enter SOX15 for the gene name of interest.
* Turn on the "COSMIC" track.
"The Catalogue Of Somatic Mutations In Cancer, is the world's largest and most comprehensive resource for exploring the impact of somatic mutations in human cancer."


* Hide "silent" at bottom.
* Zoom in near the Orange 2 Nonsense at right. (Click and drag along top edge where it says "protein length".)
* Further adjust zoom with In / Out near top


* Hover along bottom legend, just beneath the orange line. 
* What is the genomic location? How does that compare with our SNP calls?
* Hover beneath the Orange 2 to make a 3 appear. 
* Click 3.
* Examin the shaded circle that appears. Which cancer types exhibit this mutation?


* Within the shaded circle, click "List".
* Scroll right to see the full details. 
* Are any of the tumor samples familiar?


* Explore TP53 on your own.
* Can you find our SNV call?
* Does it appear to be more or less common than the mutation in SOX15?
* Is it particularly associated with breast cancer?


### Additional commandline SNV practice

If there is time and interest, we can try an additional subset of the data, following the Module7_snv lab from yesterday.

Subset the reads by specifcying a sub-region of the exome bam files using samtools view.
* b = output bam
* h = include header


This is another small region that should contain verified SNVs

```
samtools view -bh \
/home/ubuntu/CourseData/CG_data/sample_data/2017_datasets/Module5/HCC1395/HCC1395_exome_normal.ordered.bam \
12:48000000-50000000 \
-o /home/ubuntu/CourseData/CG_data/sample_data/HCC1395_subset/HCC1395_exome_normal.12.48MB-50MB.bam

samtools view -bh \
/home/ubuntu/CourseData/CG_data/sample_data/2017_datasets/Module5/HCC1395/HCC1395_exome_tumour.ordered.bam \
12:48000000-50000000 \
-o /home/ubuntu/CourseData/CG_data/sample_data/HCC1395_subset/HCC1395_exome_tumour.12.48MB-50MB.bam
```




# Some cool resources


## Database resources
### UCSC Genome Browser
```
https://genome.ucsc.edu/
```
* Downloads
* Genome Data
* Human
* Full Dataset

Download a zip containining separate fasta files for each chromosome, unzip, then concatenate these files into one.

```
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gunzip hg38.fa.gz
cat *.fa > hg38_all.fa
```


### TCGA (moved to "Genomic Data Commons")
```
https://gdc.cancer.gov/
```
* Launch Data Portal

### cBioPortal
Data for cancer genomics
```
http://www.cbioportal.org/
```

## StatQuest YouTube Series (Joshua Starmer @ UNC-Chapel Hill)
[StatQuest Home](https://www.youtube.com/user/joshstarmer/about)

Some personal favorites:

[RPKM, FPKM and TPM](https://www.youtube.com/watch?v=TTUrtCY2k-w)


[Principal Component Analysis (PCA)](https://www.youtube.com/watch?v=_UVHneBUBW0)


[FDR and the Benjamini-Hochberg Method](https://www.youtube.com/watch?v=K8LQSvtjcEo)


## Some cool tools
### FastQC
Quickly checking the quality of a sequencing run
```
https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
```


### FastQ Screen
A cool tool for checking for contamination in your sequencing libraries

```
https://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/
```

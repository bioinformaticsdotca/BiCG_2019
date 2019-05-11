---
layout: tutorial_page
permalink: /CSHL_2019_Module6_lab_supplemental
title: HT-Bio
header1: Workshop Pages for Students
header2: High-throughput Biology - From Sequence to Networks 2019 - Lab 6 Supplemental
image: /site_images/CBW-CSHL-graphic-square.png
home: https://bioinformaticsdotca.github.io/CSHL_2019
description: HT-Bio Module 6 Lab Supplemental
author: Jared Simpson
modified: June 27th, 2018
---

## Generating a preqc report for the E. coli data set

```
# First build an FM-index of the two E. coli Illumina data sets:
sga index -t 4 -a ropebwt ecoli.illumina.15x.fastq
sga index -t 4 -a ropebwt ecoli.illumina.50x.fastq

# Next, we can run `sga preqc` to run the calculations and generate the PDF report.
sga preqc -t 4 ecoli.illumina.15x.fastq > ecoli.illumina.15x.preqc
sga preqc -t 4 ecoli.illumina.50x.fastq > ecoli.illumina.50x.preqc
python sga-preqc-report.py ecoli.illumina.15x.preqc ecoli.illumina.50x.preqc
```

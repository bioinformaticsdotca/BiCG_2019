---
layout: tutorial_page
permalink: /CSHL_2019_Module14_lab
title: HT-Bio
header1: Workshop Pages for Students
header2: High-throughput Biology - From Sequence to Networks 2019 - Lab 14
image: /site_images/CBW-CSHL-graphic-square.png
home: https://bioinformaticsdotca.github.io/CSHL_2019
description: HT-Bio Module 14 Lab
author: Robin Haw
modified: June 26th, 2018
---

**This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/deed.en_US). This means that you are able to copy, share and modify the work, as long as the result is distributed under the same license.**

# Module 14 Practical Lab: Reactome

By Robin Haw

**Aim:** This exercise will provide you with an opportunity to perform pathway and network analysis using the Reactome Functional Interaction (FI) and the ReactomeFIViz app. 

**Goal:** Analyze gene lists and somatic mutation data to identify biology that contributes to GBM and ovarian cancer.

**Example 1: Network-based analysis of GBM gene-sample data** 
o	Open up Cytoscape.   
o	Go to Apps>Reactome FI and Select “Gene Set/Mutational Analysis”.    
o	Choose “2017 (Latest)” Version.   
o	Upload/Browse [GBM_genesample.txt](https://raw.githubusercontent.com/bioinformaticsdotca/HT-Biology_2017/master/GBM_genesample.txt) file.   
o	Select “Gene/sample number pair” and Choose sample cutoff value of 4.   
o	Select “Fetch FI annotations”.   
o	Click OK.  

1.	Describe the size and composition of the GBM sub-network?  
2.	What are the most frequently mutated genes?
3.	Describe the TP53-PEG3 interaction, and the source information to support this interaction?  
4.	Describe the data sources for the TAF1-TAF7L FI?  
5.	After clustering, how many modules are there?   
6.	How many pathway gene sets are there in Module 3 when the FDR Filter is set to 0.005 and Module Size Filter to 10?   
o	Hint: Analyze Module Functions>Pathway Enrichment. Select appropriate filters at each step.  
7.	What are the most significant pathway gene sets in Module 0, 2, 3?  
o	Hint: You don’t need to list them all!   

**Example 2: Network-based analysis of OvCa somatic mutation**   
o	Open up Cytoscape.   
o	Go to Apps>Reactome FI and Select “Gene Set/Mutational Analysis”.    
o	Choose “2017 (Latest)” Version.   
o	Upload/Browse [OVCA_TCGA_MAF.txt](https://raw.githubusercontent.com/bioinformatics-ca/bioinformatics-ca.github.io/master/2016_workshops/cancer/OVCA_TCGA_MAF.txt) file.   
o	Select “NCI MAF” (Mutation Annotation File) and Choose sample cutoff value of 4.   
o	Do not select “Fetch FI annotations”.   
o	Click OK.  

1.	Describe the size and composition of the OvCa network?  
2.	What are the most frequently mutated genes?  
3.	After clustering, how many modules are there?   
4.	How many pathway gene sets are there in Module 1 when the FDR Filter is set to 0.005 and Module Size Filter to 10?  
o	Hint: Analyze Module Functions>Pathway Enrichment. Select appropriate filters at each step.  
5.	What are the most significant pathway gene sets in the first 4 Modules (0 to 4)?   
6.	Do the GO Biological Process annotations correlate with the significant pathway annotations for Module 0?   
o	Hint: Analyze Module Functions>GO Biological Process. Select appropriate filters at each step.  
7.	What are the most significant GO Cell Component gene sets in Module 1 when the FDR Filter is set to 0.005 and Module Size Filter to 10? [Optional]  
o	Hint: Analyze Module Functions>GO Cell Component. Select appropriate filters at each step.  
8.	Are any of the modules annotated with the NCI Disease term: “Stage_IV_Breast_Cancer” [malignant cancer]?  
o	Hint: Load Cancer Gene Index>Neoplasm>Neoplasm_by_Site>Breast Neoplasm>…….  
9.	What are the targets of Docetaxel?
o	Hint: Overlay Cancer Drugs>Fetch Cancer Drugs. Maybe apply filters? 
10.	How many modules are statistically significant in the CoxPH analysis?   
o	Hint: Analyze Module Functions>Survival Analysis>Upload/Browse [OVCA_TCGA_Clinical.txt](https://raw.githubusercontent.com/bioinformatics-ca/bioinformatics-ca.github.io/master/2016_workshops/cancer/OVCA_TCGA_Clinical.txt). Click OK.  
11.	What does the Kaplan-Meyer plot show for the most clinically significant modules?  
o	Hint: Click the most statistically significant module link [blue line] from the CoxPH results panel. Click OK. Click #_plot.pdf to display Kaplan-Meyer plot. Repeat this for the other significant module links. KM plot: samples having genes mutated in a module (green line), and samples having no genes mutated in the module (red line).    
12. Taking into consideration what you have about module 4, what is your hypothesis?

[Answer key](https://bioinformaticsdotca.github.io/CSHL_2019_Module14_lab_answers)

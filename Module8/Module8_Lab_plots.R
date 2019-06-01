#Gene expression analysis visualization


#Malachi Griffith, mgriffit[AT]genome.wustl.edu
#Obi Griffith, ogriffit[AT]genome.wustl.edu
#Jason Walker, jason.walker[AT]wustl.edu

#McDonneLll Genome Institute, Washington Univerisity School of Medicine
#R tutorial for CBW - Bioinformatics for Cancer Genomics - RNA Sequence Analysis
#R tutorial for CSHL - Advanced Sequencing Technologies & Applications

#Starting from the output of the integrated assignment.

#Load libraries
library(ggplot2)
library(gplots)
library(GenomicRanges)
library(ballgown)

#If X11 not available, open a pdf device for output of all plots
pdf(file="assignment_Supplementary_R_output.pdf")

#Clean up workspace - i.e. delete variable created by the graphics demo
rm(list = ls(all = TRUE))

#Set working directory where results files exist
## working_dir = "~/workspace/rnaseq/de/ballgown/ref_only"


working_dir = "~/workspace/Module8/Pactical/de/ballgown/ref_only"
setwd(working_dir)

## > working_dir = "~/workspace/Module8/Pactical/de/ballgown/ref_only"
## > setwd(working_dir)
## > getwd()
## [1] "/media/workspace/Module8/Pactical/de/ballgown/ref_only"


# List the current contents of this directory
dir()
## > dir()
##  [1] "assignment_Supplementary_R_output.pdf"              
##  [2] "bg.rda"                                             
##  [3] "carcinoma_vs_normal_gene_results_filtered.tsv"      
##  [4] "carcinoma_vs_normal_gene_results_sig.tsv"           
##  [5] "carcinoma_vs_normal_gene_results.tsv"               
##  [6] "carcinoma_vs_normal_transcript_results_filtered.tsv"
##  [7] "carcinoma_vs_normal_transcript_results_sig.tsv"     
##  [8] "carcinoma_vs_normal_transcript_results.tsv"         
##  [9] "carcinoma_vs_normal.csv"                            
## [10] "save_1_ballgown.RData"

#Import expression and differential expression results from the HISAT2/StringTie/Ballgown pipeline
load('bg.rda')

# View a summary of the ballgown object
bg

## > load('bg.rda')
## > bg
## ballgown instance with 6581 transcripts and 6 samples

# Load gene names for lookup later in the tutorial
bg_table = texpr(bg, 'all')
bg_gene_names = unique(bg_table[, 9:10])


## > bg_table = texpr(bg, 'all')
## > bg_gene_names = unique(bg_table[, 9:10])
## > dim(bg_table)
## [1] 6581   22
## > head(bg_table)
##   t_id chr strand start   end          t_name num_exons length         gene_id
## 1    1   9      + 12134 13783 ENST00000421620         6    654 ENSG00000236875
## 2    2   9      - 14521 29739 ENST00000442898        11   1827 ENSG00000181404
## 3    3   9      + 27657 30891 ENST00000422679         2   2923 ENSG00000227518
## 4    4   9      + 30144 30281 ENST00000408365         1    138 ENSG00000227518
## 5    5   9      - 34394 35860 ENST00000449442         3   1126 ENSG00000218839
## 6    6   9      - 34965 35871 ENST00000305248         2    668 ENSG00000218839
##   gene_name cov.carcinoma_C02 FPKM.carcinoma_C02 cov.carcinoma_C03
## 1   DDX11L5          0.000000           0.000000                 0
## 2     WASH1          0.118227          19.856138                 0
## 3 MIR1302-9          0.049264           8.273853                 0
## 4 MIR1302-9          0.000000           0.000000                 0
## 5   FAM138C          0.000000           0.000000                 0
## 6   FAM138C          0.000000           0.000000                 0
##   FPKM.carcinoma_C03 cov.carcinoma_C06 FPKM.carcinoma_C06 cov.normal_N02
## 1                  0          0.000000            0.00000       0.000000
## 2                  0          0.256158           34.26671       0.097427
## 3                  0          0.000000            0.00000       0.000000
## 4                  0          0.000000            0.00000       0.000000
## 5                  0          0.000000            0.00000       0.000000
## 6                  0          0.000000            0.00000       0.000000
##   FPKM.normal_N02 cov.normal_N03 FPKM.normal_N03 cov.normal_N06 FPKM.normal_N06
## 1         0.00000        0.00000         0.00000       0.000000         0.00000
## 2        21.83917        0.00000         0.00000       0.253528        62.55594
## 3         0.00000        0.04858        11.39125       0.000000         0.00000
## 4         0.00000        0.00000         0.00000       0.000000         0.00000
## 5         0.00000        0.00000         0.00000       0.000000         0.00000
## 6         0.00000        0.00000         0.00000       0.000000         0.00000
## > dim(bg_gene_names)
## [1] 2242    2
## > head(bg_gene_names)
##            gene_id    gene_name
## 1  ENSG00000236875      DDX11L5
## 2  ENSG00000181404        WASH1
## 3  ENSG00000227518    MIR1302-9
## 5  ENSG00000218839      FAM138C
## 7  ENSG00000277631   PGM5P3-AS1
## 14 ENSG00000227917 RP11-143M1.3

# Pull the gene_expression data frame from the ballgown object
gene_expression = as.data.frame(gexpr(bg))

## > gene_expression = as.data.frame(gexpr(bg))
## > dim(gene_expression)
## [1] 2242    6
## > head(gene_expression)
##                 FPKM.carcinoma_C02 FPKM.carcinoma_C03 FPKM.carcinoma_C06
## ENSG00000005238           150.0483           211.2747           159.1493
## ENSG00000010438             0.0000             0.0000             0.0000
## ENSG00000011454           428.3595           314.1211           177.7178
## ENSG00000023318           452.9164           541.5681           764.0020
## ENSG00000030304             0.0000             0.0000             0.0000
## ENSG00000041982           891.6421           507.6435           254.5218
##                 FPKM.normal_N02 FPKM.normal_N03 FPKM.normal_N06
## ENSG00000005238        84.76978        173.7881        131.6718
## ENSG00000010438         0.00000          0.0000          0.0000
## ENSG00000011454       370.84608        381.0013        325.3592
## ENSG00000023318       410.19403        463.3650        723.8571
## ENSG00000030304         0.00000          0.0000          0.0000
## ENSG00000041982      1031.90326        905.6579        442.2966


data_colors=c("tomato1","tomato2","tomato3","royalblue1","royalblue2","royalblue3")
## > data_colors=c("tomato1","tomato2","tomato3","royalblue1","royalblue2","royalblue3")
## > data_colors
## [1] "tomato1"    "tomato2"    "tomato3"    "royalblue1" "royalblue2"
## [6] "royalblue3"

#View expression values for the transcripts of a particular gene symbol of chromosome 22.  e.g. 'TST'
#First determine the rows in the data.frame that match 'PCA3', aka. ENSG00000225937 , then display only those rows of the data.frame
i = row.names(gene_expression) == "ENSG00000225937"
gene_expression[i,]


## > i = row.names(gene_expression) == "ENSG00000225937"
## > gene_expression[i,]
##                 FPKM.carcinoma_C02 FPKM.carcinoma_C03 FPKM.carcinoma_C06
## ENSG00000225937           13.13212           219.7846            1009.61
##                 FPKM.normal_N02 FPKM.normal_N03 FPKM.normal_N06
## ENSG00000225937               0         87.2371        655.7819

## or
i=which(row.names(gene_expression) == "ENSG00000225937")
i
gene_expression[i,]


## > i=which(row.names(gene_expression) == "ENSG00000225937")
## > i
## [1] 1091
## > gene_expression[i,]
##                 FPKM.carcinoma_C02 FPKM.carcinoma_C03 FPKM.carcinoma_C06
## ENSG00000225937           13.13212           219.7846            1009.61
##                 FPKM.normal_N02 FPKM.normal_N03 FPKM.normal_N06
## ENSG00000225937               0         87.2371        655.7819

# Load the transcript to gene index from the ballgown object
transcript_gene_table = indexes(bg)$t2g
head(transcript_gene_table)

## > transcript_gene_table = indexes(bg)$t2g
## > head(transcript_gene_table)
##   t_id            g_id
## 1    1 ENSG00000236875
## 2    2 ENSG00000181404
## 3    3 ENSG00000227518
## 4    4 ENSG00000227518
## 5    5 ENSG00000218839
## 6    6 ENSG00000218839
## > 


#### Plot #1 - the number of transcripts per gene.  
#Many genes will have only 1 transcript, some genes will have several transcripts
#Use the 'table()' command to count the number of times each gene symbol occurs (i.e. the # of transcripts that have each gene symbol)
#Then use the 'hist' command to create a histogram of these counts
#How many genes have 1 transcript?  More than one transcript?  What is the maximum number of transcripts for a single gene?
counts=table(transcript_gene_table[,"g_id"])
c_one = length(which(counts == 1))
c_more_than_one = length(which(counts > 1))
c_max = max(counts)
hist(counts, breaks=50, col="bisque4", xlab="Transcripts per gene", main="Distribution of transcript count per gene")
legend_text = c(paste("Genes with one transcript =", c_one), paste("Genes with more than one transcript =", c_more_than_one), paste("Max transcripts for single gene = ", c_max))
legend("topright", legend_text, lty=NULL)

## > counts=table(transcript_gene_table[,"g_id"])
## > c_one = length(which(counts == 1))
## > c_more_than_one = length(which(counts > 1))
## > c_max = max(counts)
## > hist(counts, breaks=50, col="bisque4", xlab="Transcripts per gene", main="Distribution of transcript count per gene")
## > legend_text = c(paste("Genes with one transcript =", c_one), paste("Genes with more than one transcript =", c_more_than_one), paste("Max transcripts for single gene = ", c_max))
## > legend("topright", legend_text, lty=NULL)
## > 
## > head(counts)

## ENSG00000005238 ENSG00000010438 ENSG00000011454 ENSG00000023318 ENSG00000030304 
##               9               8              13               1               7 
## ENSG00000041982 
##              14 
## > table(counts)
## counts
##    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16 
## 1423  202  121   89   77   60   53   45   32   19   11   24   15   14   10    7 
##   17   18   19   20   21   22   23   24   26   27   28   29   32   33   38   56 
##    4    1    6    4    2    2    3    2    1    3    2    4    1    2    1    1 
##   65 
## 1
## > c_one
## [1] 1423
## > c_more_than_one
## [1] 819
## > c_max
## [1] 65

#### Plot #2 - the distribution of transcript sizes as a histogram
#In this analysis we supplied StringTie with transcript models so the lengths will be those of known transcripts
#However, if we had used a de novo transcript discovery mode, this step would give us some idea of how well transcripts were being assembled
#If we had a low coverage library, or other problems, we might get short 'transcripts' that are actually only pieces of real transcripts

full_table <- texpr(bg , 'all')
hist(full_table$length, breaks=50, xlab="Transcript length (bp)", main="Distribution of transcript lengths", col="steelblue")

## > full_table <- texpr(bg , 'all')
## > hist(full_table$length, breaks=50, xlab="Transcript length (bp)", main="Distribution of transcript lengths", col="steelblue")

#### Summarize FPKM values for all 6 replicates
#What are the minimum and maximum FPKM values for a particular library?
min(gene_expression[,"FPKM.carcinoma_C02"])
max(gene_expression[,"FPKM.carcinoma_C02"])

## > min(gene_expression[,"FPKM.carcinoma_C02"])
## [1] 0
## > max(gene_expression[,"FPKM.carcinoma_C02"])
## [1] 7784.915

#Set the minimum non-zero FPKM values for use later.
#Do this by grabbing a copy of all data values, coverting 0's to NA, and calculating the minimum or all non NA values
#zz = fpkm_matrix[,data_columns]
#zz[zz==0] = NA
#min_nonzero = min(zz, na.rm=TRUE)
#min_nonzero

#Alternatively just set min value to 1
min_nonzero=1

# Set the columns for finding FPKM and create shorter names for figures
data_columns=c(1:6)
short_names=c("CR_1","CR_2","CR_3","NR_1","NR_2","NR_3")

#### Plot #3 - View the range of values and general distribution of FPKM values for all 4 libraries
#Create boxplots for this purpose
#Display on a log2 scale and add the minimum non-zero value to avoid log2(0)
boxplot(log2(gene_expression[,data_columns]+min_nonzero), col=data_colors, names=short_names, las=2, ylab="log2(FPKM)", main="Distribution of FPKMs for all 6 libraries")
#Note that the bold horizontal line on each boxplot is the median

## > min_nonzero=1
## > 
## > data_columns=c(1:6)
## > short_names=c("CR_1","CR_2","CR_3","NR_1","NR_2","NR_3")
## > boxplot(log2(gene_expression[,data_columns]+min_nonzero), col=data_colors, names=short_names, las=2, ylab="log2(FPKM)", main="Distribution of FPKMs for all 6 libraries")


# Calculate the differential expression results including significance
results_genes = stattest(bg, feature="gene", covariate="type", getFC=TRUE, meas="FPKM")
results_genes = merge(results_genes,bg_gene_names,by.x=c("id"),by.y=c("gene_id"))

## > results_genes = stattest(bg, feature="gene", covariate="type", getFC=TRUE, meas="FPKM")
## > results_genes = merge(results_genes,bg_gene_names,by.x=c("id"),by.y=c("gene_id"))
## > dim(results_genes)
## [1] 2242    6
## > head(results_genes)
##                id feature        fc      pval      qval gene_name
## 1 ENSG00000005238    gene 0.7334968 0.2523626 0.8408251   FAM214B
## 2 ENSG00000010438    gene 1.0000000       NaN       NaN     PRSS3
## 3 ENSG00000011454    gene 1.2438339 0.5197590 0.8718092   RABGAP1
## 4 ENSG00000023318    gene 0.9008926 0.7184397 0.9492274     ERP44
## 5 ENSG00000030304    gene 1.0000000       NaN       NaN      MUSK
## 6 ENSG00000041982    gene 1.5311196 0.4694589 0.8468655       TNC

#### Plot #4 - View the distribution of differential expression values as a histogram
#Display only those that are significant according to Ballgown

sig=which(results_genes$pval<0.05)
results_genes[,"de"] = log2(results_genes[,"fc"])
hist(results_genes[sig,"de"], breaks=50, col="seagreen", xlab="log2(Fold change) carcinoma vs normal", main="Distribution of differential expression values")
abline(v=-2, col="black", lwd=2, lty=2)
abline(v=2, col="black", lwd=2, lty=2)
legend("topleft", "Fold-change > 4", lwd=2, lty=2)

## > sig=which(results_genes$pval<0.05)
## > results_genes[,"de"] = log2(results_genes[,"fc"])
## > hist(results_genes[sig,"de"], breaks=50, col="seagreen", xlab="log2(Fold change) carcinoma vs normal", main="Distribution of differential expression values")
## > abline(v=-2, col="black", lwd=2, lty=2)
## > abline(v=2, col="black", lwd=2, lty=2)
## > legend("topleft", "Fold-change > 4", lwd=2, lty=2)

#### Plot #5 - Display the grand expression values from carcinoma and normal and mark those that are significantly differentially expressed
gene_expression[,"carcinoma"]=apply(gene_expression[,c(1:3)], 1, mean)
gene_expression[,"normal"]=apply(gene_expression[,c(4:6)], 1, mean)

x=log2(gene_expression[,"carcinoma"]+min_nonzero)
y=log2(gene_expression[,"normal"]+min_nonzero)
plot(x=x, y=y, pch=16, cex=0.25, xlab="carcinoma FPKM (log2)", ylab="normal FPKM (log2)", main="carcinoma vs normal FPKMs")
abline(a=0, b=1)
xsig=x[sig]
ysig=y[sig]
points(x=xsig, y=ysig, col="magenta", pch=16, cex=0.5)
legend("topleft", "Significant", col="magenta", pch=16)

## > gene_expression[,"carcinoma"]=apply(gene_expression[,c(1:3)], 1, mean)
## > gene_expression[,"normal"]=apply(gene_expression[,c(4:6)], 1, mean)
## > 
## > x=log2(gene_expression[,"carcinoma"]+min_nonzero)
## > y=log2(gene_expression[,"normal"]+min_nonzero)
## > plot(x=x, y=y, pch=16, cex=0.25, xlab="carcinoma FPKM (log2)", ylab="normal FPKM (log2)", main="carcinoma vs normal FPKMs")
## > abline(a=0, b=1)
## > xsig=x[sig]
## > ysig=y[sig]
## > points(x=xsig, y=ysig, col="magenta", pch=16, cex=0.5)
## > legend("topleft", "Significant", col="magenta", pch=16)

#Get the gene symbols for the top N (according to corrected p-value) and display them on the plot
topn = order(abs(results_genes[sig,"fc"]), decreasing=TRUE)[1:25]
topn = order(results_genes[sig,"qval"])[1:25]
text(x[topn], y[topn], results_genes[topn,"gene_name"], col="black", cex=0.75, srt=45)
## > topn = order(abs(results_genes[sig,"fc"]), decreasing=TRUE)[1:25]
## > topn = order(results_genes[sig,"qval"])[1:25]
## > text(x[topn], y[topn], results_genes[topn,"gene_name"], col="black", cex=0.75, srt=45)

#### Write a simple table of differentially expressed transcripts to an output file
#Each should be significant with a log2 fold-change >= 2
sigpi = which(results_genes[,"pval"]<0.05)
sigp = results_genes[sigpi,]
sigde = which(abs(sigp[,"de"]) >= 2)
sig_tn_de = sigp[sigde,]

## > sigpi = which(results_genes[,"pval"]<0.05)
## > sigp = results_genes[sigpi,]
## > sigde = which(abs(sigp[,"de"]) >= 2)
## > sig_tn_de = sigp[sigde,]

#Order the output by or p-value and then break ties using fold-change
o = order(sig_tn_de[,"qval"], -abs(sig_tn_de[,"de"]), decreasing=FALSE)

output = sig_tn_de[o,c("gene_name","id","fc","pval","qval","de")]
write.table(output, file="SigDE_supplementary_R.txt", sep="\t", row.names=FALSE, quote=FALSE)

## > o = order(sig_tn_de[,"qval"], -abs(sig_tn_de[,"de"]), decreasing=FALSE)
## > 
## > output = sig_tn_de[o,c("gene_name","id","fc","pval","qval","de")]
## > write.table(output, file="SigDE_supplementary_R.txt", sep="\t", row.names=FALSE, quote=FALSE)

#View selected columns of the first 25 lines of output
output[1:25,c(1,4,5)]

## > output[1:25,c(1,4,5)]
##          gene_name         pval         qval
## 1996     CNTNAP3P1 1.058974e-07 0.0001332189
## 1930  RP11-149F8.3 9.619853e-05 0.0605088743
## 1218  RP11-216B9.6 1.569807e-03 0.2468521039
## 2235 CH17-296N19.1 7.342185e-04 0.2468521039
## 1755        TMEFF1 1.025843e-03 0.2468521039
## 1339    C2orf27AP3 1.372354e-03 0.2468521039
## 653          LCN10 1.491767e-03 0.2468521039
## 1838       SNRPEP2 2.448841e-03 0.3267291863
## 1260        PES1P2 2.856932e-03 0.3267291863
## 1254       SNX18P4 3.294265e-03 0.3304892051
## 1367       SNX18P8 3.415230e-03 0.3304892051
## 660        FAM166A 5.455613e-03 0.3905656891
## 1729 RP11-537H15.4 7.008558e-03 0.4055754346
## 1945   RP11-92C4.6 9.383206e-03 0.4281918350
## 282           CTSV 9.472396e-03 0.4281918350
## 206         FIBCD1 8.791766e-03 0.4281918350
## 953          FANCG 1.123547e-02 0.4490629329
## 1495         SETP5 1.206517e-02 0.4582776472
## 1947 RP11-311H10.7 1.238588e-02 0.4582776472
## 622        TMEM210 1.354445e-02 0.4733031861
## 1497  RP11-452D2.2 3.049867e-02 0.6504383020
## 1696 RP11-216M21.1 2.177131e-02 0.6504383020
## 428          PLPP7 4.874081e-02 0.6504383020
## 1120     PAPPA-AS2 2.323314e-02 0.6504383020
## NA            <NA>           NA           NA

#You can open the file "SigDE.txt" in Excel, Calc, etc.
#It should have been written to the current working directory that you set at the beginning of the R tutorial
dir()
## > dir()
##  [1] "assignment_Supplementary_R_output.pdf"              
##  [2] "bg.rda"                                             
##  [3] "carcinoma_vs_normal_gene_results_filtered.tsv"      
##  [4] "carcinoma_vs_normal_gene_results_sig.tsv"           
##  [5] "carcinoma_vs_normal_gene_results.tsv"               
##  [6] "carcinoma_vs_normal_transcript_results_filtered.tsv"
##  [7] "carcinoma_vs_normal_transcript_results_sig.tsv"     
##  [8] "carcinoma_vs_normal_transcript_results.tsv"         
##  [9] "carcinoma_vs_normal.csv"                            
## [10] "save_1_ballgown.RData"                              
## [11] "SigDE_supplementary_R.txt"


#### Plot #6 - Create a heatmap to vizualize expression differences between the eight samples
#Define custom dist and hclust functions for use with heatmaps
mydist=function(c) {dist(c,method="euclidian")}
myclust=function(c) {hclust(c,method="average")}

main_title="sig DE Transcripts"
par(cex.main=0.8)
sig_genes=results_genes[sig,"id"]
sig_gene_names=results_genes[sig,"gene_name"]
data=log2(as.matrix(gene_expression[sig_genes,data_columns])+1)
heatmap.2(data, hclustfun=myclust, distfun=mydist, na.rm = TRUE, scale="none", dendrogram="both", margins=c(6,7), Rowv=TRUE, Colv=TRUE, symbreaks=FALSE, key=TRUE, symkey=FALSE, density.info="none", trace="none", main=main_title, cexRow=0.3, cexCol=1, labRow=sig_gene_names,col=rev(heat.colors(75)))

## > mydist=function(c) {dist(c,method="euclidian")}
## > myclust=function(c) {hclust(c,method="average")}
## > 
## > main_title="sig DE Transcripts"
## > par(cex.main=0.8)
## > sig_genes=results_genes[sig,"id"]
## > sig_gene_names=results_genes[sig,"gene_name"]
## > data=log2(as.matrix(gene_expression[sig_genes,data_columns])+1)
## > heatmap.2(data, hclustfun=myclust, distfun=mydist, na.rm = TRUE, scale="none", dendrogram="both", margins=c(6,7), Rowv=TRUE, Colv=TRUE, symbreaks=FALSE, key=TRUE, symkey=FALSE, density.info="none", trace="none", main=main_title, cexRow=0.3, cexCol=1, labRow=sig_gene_names,col=rev(heat.colors(75)))


dev.off()

save.image("save_2_sup.RData")

#The output file can be viewed in your browser at the following url:
#Note, you must replace __YOUR_IP_ADDRESS__ with your own amazon instance IP
#http://__YOUR_IP_ADDRESS__/workspace/rnaseq/de/ballgown/ref_only/assignment_Supplementary_R_output.pdf
#To exit R type:
quit(save="no")


## florences-imac:CancerGenomic_2019 florence$ scp -i CBW.pem ubuntu@main.oicrcbw.ca:/home/ubuntu/workspace/Module8/Pactical/de/ballgown/ref_only/*.pdf .
## assignment_Supplementary_R_output.pdf                                                                                                                                                                                         100%   47KB  46.5KB/s   00:00    
## florences-imac:CancerGenomic_2019 florence$ open assignment_Supplementary_R_output.pdf 
## florences-imac:CancerGenomic_2019 florence$ 

## florences-imac:CancerGenomic_2019 florence$ scp -i CBW.pem ubuntu@main.oicrcbw.ca:/home/ubuntu/workspace/Module8/Pactical/de/ballgown/ref_only/*.txt .
## SigDE_supplementary_R.txt                                                                                                                                                                                                     100% 2402     2.4KB/s   00:00    
## florences-imac:CancerGenomic_2019 florence$ 


## florences-imac:CancerGenomic_2019 florence$ more SigDE_supplementary_R.txt 
## gene_name       id      fc      pval    qval    de
## CNTNAP3P1       ENSG00000273509 0.0618183901075497      1.05897404623079e-07    0.000133218935015833    -4.0158201061722
## RP11-149F8.3    ENSG00000268951 0.191103884061114       9.61985283248756e-05    0.0605088743163468      -2.38757099444345
## RP11-216B9.6    ENSG00000228395 0.0579957995520937      0.00156980670190032     0.246852103873826       -4.10790777547952
## CH17-296N19.1   ENSG00000283378 0.0650087921254606      0.000734218502468575    0.246852103873826       -3.94322134089497
## TMEFF1  ENSG00000241697 0.101662884443154       0.00102584321431354     0.246852103873826       -3.29813502535863
## C2orf27AP3      ENSG00000230804 0.155381191069293       0.00137235414012982     0.246852103873826       -2.68611621915571
## LCN10   ENSG00000187922 4.18478194984884        0.00149176745167945     0.246852103873826       2.06515245238917
## SNRPEP2 ENSG00000256968 53.6806569741949        0.00244884085823438     0.326729186317298       5.74633042305014
## PES1P2  ENSG00000229268 7.13995775911628        0.00285693247177288     0.326729186317298       2.8359155391152
## SNX18P4 ENSG00000229146 0.151586495665126       0.00329426505385921     0.330489205063857       -2.72178686053897
## SNX18P8 ENSG00000231390 0.157037848489439       0.00341523025900647     0.330489205063857       -2.67081578260284
## FAM166A ENSG00000188163 0.142460268951974       0.00545561325062738     0.390565689085645       -2.81136847580811
## RP11-537H15.4   ENSG00000239392 0.172828226800996       0.00700855822474566     0.405575434642751       -2.53258923305632
## RP11-92C4.6     ENSG00000270412 8.48066557393981        0.00938320571751727     0.428191834950422       3.08417749386178
## CTSV    ENSG00000136943 0.212965732944359       0.00947239644417153     0.428191834950422       -2.23130678128285
## FIBCD1  ENSG00000130720 0.246443926486752       0.0087917664313989      0.428191834950422       -2.02066866808968
## FANCG   ENSG00000221829 5.22168941774916        0.0112354666891702      0.449062932871892       2.38451664976136
## SETP5   ENSG00000233998 0.059035527861642       0.0120651697060185      0.458277647161477       -4.0822727532037
## RP11-311H10.7   ENSG00000270542 0.0758099236918889      0.0123858823557156      0.458277647161477       -3.72146947694591
## TMEM210 ENSG00000185863 0.116084071176536       0.0135444472957359      0.473303186056549       -3.10675807282352
## RP11-452D2.2    ENSG00000234042 0.0994206430523543      0.0304986671608972      0.650438301958431       -3.3303107551178
## RP11-216M21.1   ENSG00000237846 0.10183750729625        0.0217713068959946      0.650438301958431       -3.29565908333348
## PLPP7   ENSG00000160539 7.44220983495832        0.0487408053409542      0.650438301958431       2.89573106818285
## PAPPA-AS2       ENSG00000226604 0.19194727714019        0.0232331399194308      0.650438301958431       -2.38121799984554
## florences-imac:CancerGenomic_2019 florence$ wc -l SigDE_supplementary_R.txt 
##       25 SigDE_supplementary_R.txt

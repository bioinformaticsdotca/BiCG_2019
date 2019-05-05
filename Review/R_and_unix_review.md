---
layout: tutorial_page
permalink: /bicg-2018-Unix_and_R
title: BiCG Unix and R Review
header1: Workshop Pages for Students
header2: Bioinformatics for Cancer Genomics
image: /site_images/CBW_cancerDNA_icon-16.jpg
home: https://bioinformaticsdotca.github.io/bicg_2018
---


# CBW BiCG Unix and R Review Session  

## Introduction

Welcome to the review for **Unix and R**! This lab will introduce you to the the command line and using R.

After this lab, you will be able to:

* use common commands in Unix
* read data into R
* produce basic plots in R

## Before We Begin

Read these [directions](http://bioinformaticsdotca.github.io/AWS_setup) for information on how to log in to your assigned Amazon node.

## Unix Review

Basic commands:

* ls: list the files in the directory  

```
ls
```

* mkdir: make a new directory  

```
mkdir Review_Session
```

* cd: change directories; 

```
cd Review_Session
```

`cd ...` will take you up one directory.

* pwd: print working directory 

```
pwd
```

* echo: print what it typed  

```
echo 'Hello World!' > test.txt
```

* cat: print the contents of a file  

```
cat test.txt
```

* curl: used to get contents from a URL  

```
curl https://raw.githubusercontent.com/bioinformaticsdotca/Genomic_Med_2017/master/test.fasta > test.fasta
curl https://raw.githubusercontent.com/bioinformaticsdotca/BiCG_2017/master/Review_session/Gene_R_example.csv > Gene_R_Example.csv
```

* head and tail: get the beginning or end of a file  

```
head test.fasta
tail test.fasta
```

* less and more: look at the contents of a file  

```
less test.fasta
```

To exit `less`, press `q`.

* cp: copy 

```
cp test.fasta test2.fasta
```

* mv: move  

```
mv test2.fasta test3.fasta
```

* rm: remove  

```
rm test3.fasta
```

Note: you should be using `rm -i` to avoid accidentally deleting a wanted file.  

* grep: pattern matching

```
grep TTT test.fasta
```

You can use the pipe character `|` to string commands together:

```
head test.fasta | grep TTT
```

***

## R Review

### Connecting To RStudio

* Open an internet browser.  
* In the URL bar, enter *http://##.oicrcbw.ca:8080* replacing *xx* with your provided student number.  
* Enter the supplied username and password.  

### RStudio Notebooks

Information on RStudio Notebooks can be found [here](http://rmarkdown.rstudio.com/r_notebooks.html).  

RStudio notebooks are written in R Markdown and contain text that can be executed independently.

To start a new notebook, `File -> New File -> R Notebook`.  

To run code chunks, place your cursor within the code chunk and press *Cmd+Shift+Enter* on Mac and  *Crtl+Shift+Enter* or click the green triangle run button.  The output of the chunk appears below the code chunk.  

Copy the code [here](https://raw.githubusercontent.com/bioinformaticsdotca/BiCG_2017/master/Review_session/R_review_notebook.Rmd) into the notebook you have created.

### Getting Around

#### The Hard Way

```r
# get the current working directory:
getwd()
# set a new working directory:
setwd("C:/myPATH")
setwd("~/myPATH") # on Mac
setwd("/Users/david/myPATH") # on Mac
# list the files in the current working directory:
list.files()
# list objects in the current R session:
ls()
```

#### The Easy Way

In RStudio we can use "Session" > "Set Working Directory".  
  
### Data Types

#### Vectors

```r
numeric.vector <- c(1,2,3,4,5,6,2,1)
numeric.vector

character.vector <- c("Fred", "Barney", "Wilma", "Betty")
character.vector

logical.vector <- c(TRUE, TRUE, FALSE, TRUE)
logical.vector
```

To refer to elements in the vector:

```r
character.vector
character.vector[2]
character.vector[2:3]
character.vector[c(2,4)]
```

#### Matrices

You can create a 3x4 numeric matrix with:

```r
matrix.example <- matrix(1:12, nrow = 3, ncol=4, byrow = FALSE)
matrix.example

matrix.example <- matrix(1:12, nrow = 3, ncol=4, byrow = TRUE)
matrix.example
```

Alternatively, you can create a matrix by combining vectors:

```r
dataset.a <- c(1,22,3,4,5)
dataset.b <- c(10,11,13,14,15)
dataset.a
dataset.b

rbind.together <- rbind(dataset.a, dataset.b)
rbind.together

cbind.together <- cbind(dataset.a, dataset.b)
cbind.together
```
To get elements of the matrix:

```r
matrix.example[2,4]
matrix.example[2,]
matrix.example[,4]
```

You can add column and row names to the matrix and use the new names to get the elements of the matrix:

```r
colnames(matrix.example) <- c("Sample1","Sample2","Sample3","Sample4")
rownames(matrix.example) <- paste("gene",1:3,sep="_")
matrix.example

matrix.example[,"Sample2"]
matrix.example[1,"Sample2"]
matrix.example["gene_1","Sample2"]
```

Note that all columns in a matrix must have the same mode(numeric, character, etc.) and the same length.

#### Dataframes

Dataframes are similar to arrays but different columns can have different modes (numeric, character, factor, etc.).  

```r
people.summary <- data.frame(
                             age = c(30,29,25,25),
                             names = c("Fred", "Barney", "Wilma", "Betty"),
                             gender = c("m", "m", "f", "f")
                             )
people.summary
```

To get elements of the dataframe:

```r
people.summary[2,1]
people.summary[2,]
people.summary[,1]
people.summary$age
```

#### Lists

Lists gather together a collection of objects under one name.

```r
together.list <- list(
                      vector.example = dataset.a, 
                      matrix.example = matrix.example,
                      data.frame.example = people.summary
                      )
together.list
```

There are several ways to get elements of a list:

```r

together.list$matrix.example
together.list$matrix.example[,3]
together.list["matrix.example"]
together.list[["matrix.example"]]
together.list[["matrix.example"]][,2]
```

### Reading Data In

We use `read.data` or `read.csv` to read in data.  

```r
gene_example <- read_csv("Gene_R_example.csv")
```

In RStudio, we can use the "File" navigation window instead.  Navigate to the directory containing the Gene_R_example.csv that we downloaded previously. Click on the file name then click "Import Dataset."  A new window appears allowing you to modify attributes of your file.  Rename the file to the object "gene_example".

Commands like `head` and `tail` also work in R.

```r
head(gene_example)
View(gene_example)
```

### Basic Plotting

A very basic plot:

```r
plot(x=gene_example$Control, y=gene_example$Treated)
```

A nicer plot:

```r
plot(x=gene_example$Control, y=gene_example$Treated,
    xlab = "Control",
    ylab = "Treated",
    cex.lab = 1.5,
    main = "A nice scatter plot",
    pch = 16,
    bty = "n",
    col = "dark blue",
    las = 1
    )
## las
## How to change the axes label style in R
## To change the axes label style, use the graphics option las (label style). This changes the orientation angle of the labels:
## 0: The default, parallel to the axis
## 1: Always horizontal
## 2: Perpendicular to the axis
## 3: Always vertical

## bty
## To change the type of box round the plot area, use the option bty (box type):
## "o": The default value draws a complete rectangle around the plot.
## "n": Draws nothing around the plot.
```

Connecting the dots:

```r
plot(x=gene_example$Control, y=gene_example$Treated,
    xlab = "Control",
    ylab = "Treated",
    cex.lab = 1.5,
    main = "A nice scatter plot",
    pch = 16,
    bty = "n",
    col = "dark blue",
	type = "b",
	las = 1
	)
```

#### Histograms

```r
hist(gene_example$Control)

hist(gene_example$Control,
    xlab = "Expression",
    ylab = "Number of Genes",
    cex.lab = 1.5,
    main = "A nice histogram",
    col = "cyan",
    breaks = 10,
    las = 1
    )
```

#### Boxplots

```r
 boxplot(gene_example[,2:3])
```

```r
boxplot(gene_example[,2:3],
	width = c(3,1),
	col = "red",
	border = "dark blue",
	names = c("Control", "Treatment"),
	main = "My boxplot",
	notch = TRUE,
	horizontal = TRUE
	)
```

#### Saving your plots as PDFs

```r
pdf("myfigure.pdf", height=10, width=6)
par(mfrow=c(2,1))

plot(x=gene_example$Control, y=gene_example$Treated,
    xlab = "Control",
    ylab = "Treated",
    cex.lab = 1.5,
    main = "A nice scatter plot",
    pch = 16,
    bty = "n",
    col = "dark blue",
	type = "b",
	las = 1
	)
	
boxplot(gene_example[,2:3],
	width = c(3,1),
	col = "red",
	border = "dark blue",
	names = c("Control", "Treatment"),
	main = "My boxplot",
	notch = TRUE,
	horizontal = TRUE
	)
  
  dev.off()
```

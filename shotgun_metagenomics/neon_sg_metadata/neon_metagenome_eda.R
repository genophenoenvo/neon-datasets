#!/usr/bin/env Rscript

suppressMessages(library(neonUtilities))
suppressMessages(library(tidyverse))

#Exploratory neonUtilities metadata analysis
# These are how the data filtering was determined

# Soil Shotgun Metagenome Sequences: DP1.10107.001
#relative path to this folder
metadata__file_path <- "~/neon-datasets/shotgun_metagenomics/neon_sg_metadata/"

#list all the csv files (NEON Metadata)
data_path <- list.files(path = metadata__file_path,
                        pattern = "*.csv", full.names = TRUE)
#character vector of file names
filenames <- list.files(path = metadata__file_path,
                        pattern = "*.csv")
#read in list of files as data frames
raw_metadata <- lapply(data_path, FUN = function(i){
  read.csv(i, header=TRUE, stringsAsFactors = FALSE)})
#name the data frames in the list after their filenames
names(raw_metadata) <- filenames
colnames(raw_metadata$mms_metagenomeDnaExtraction.csv)


# function to take a column and return counts table of unique categorical variables 
# for Exploratory Data Analysis (EDA)
n2tab_count <-function(n){
  df <- as.data.frame(table(as.vector(n)), stringsAsFactors = FALSE)
  return(df)}

# DNA Extraction EDA

#get counts of laboratory
laboratory_counts <- n2tab_count(raw_metadata$mms_metagenomeDnaExtraction.csv$laboratoryName)
print(laboratory_counts)
# Var1 Freq
# 1 Argonne National Laboratory  628
# 2   Battelle Applied Genomics 3664

#get pooled status counts
pooled_status <- n2tab_count(raw_metadata$mms_metagenomeDnaExtraction.csv$dnaPooledStatus)
print(pooled_status)
# Var1 Freq
#  N   4205
#  Y   87

# QA QC status
qaqc_status <- n2tab_count(raw_metadata$mms_metagenomeDnaExtraction.csv$qaqcStatus)
print(qaqc_status)

#            Var1 Freq
# 1         Fail   16
# 2 Not recorded   99
# 3         Pass 3648


# Filter data by:
# qaqcStatus == "Pass"
# dnaPooledStatus == "N"
# laboratoryName != "Argonne National Laboratory"

metagenomeDnaExtraction <- raw_metadata$mms_metagenomeDnaExtraction.csv %>% 
  filter(qaqcStatus == "Pass" &
           dnaPooledStatus == "N" &
           laboratoryName != "Argonne National Laboratory",
         sequenceAnalysisType != "marker gene")

# sanity check: how many extractions are filtered out?
# dim(raw_metadata$mms_metagenomeDnaExtraction.csv)-dim(metagenomeDnaExtraction)
# 3271 samples removed by filtering leaving only shotgun mag data
# ---------------------------------------------------------------------------
# Filter metagenome sequencing by the DNA extraction id's included in the df above
# and remove sequencing that did not pass Quality Filtering
metagenomeSequencing <- raw_metadata$mms_metagenomeSequencing.csv %>% 
  filter(dnaSampleID %in% metagenomeDnaExtraction$dnaSampleID,
         is.na(dataQF))


colnames(raw_metadata$mms_rawDataFiles.csv)

n2tab_count(raw_metadata$mms_rawDataFiles.csv$dataQF)

n2tab_count(raw_metadata$mms_rawDataFiles.csv$laboratoryName)

rawDataFiles <- raw_metadata$mms_rawDataFiles.csv %>% 
  filter(dnaSampleID %in% metagenomeSequencing$dnaSampleID,
         is.na(dataQF))


### Checking Download from NEON API on 05-27-2021
cereus_fq <- read.table(file = "~/neon-datasets/shotgun_metagenomics/fastq_list.txt")

raw_fq <- read.csv(file = "~/neon-datasets/shotgun_metagenomics/neon_sg_metadata/processed_metadata/mms_rawDataFiles.csv", header = TRUE)

# what file is missing? 
setdiff(raw_fq$rawDataFileName, cereus_fq$V1)
# [1] "BMI_HL7C5BGX7_mms_R1_D.fastq.tar.gz"

### Testing untar
# tar -xvf BMI_H7FFKBGX5_mms_R1_A.fastq.tar.gz

# Produces the following reads:

# BMI_Plate1WellB5_mms_R1.fastq  BMI_Plate1WellG2_mms_R1.fastq
# BMI_Plate1WellB9_mms_R1.fastq  BMI_Plate1WellH7_mms_R1.fastq

# test vs. metadata
head(raw_fq)

# check counts per base plot - geospatial data depends on this
filtered_metagenome_data <- read.csv(file = "~/neon-datasets/shotgun_metagenomics/neon_sg_metadata/processed_metadata/mms_metagenomeSequencing.csv")
baseplot_sampling <- n2tab_count(filtered_metagenome_data$namedLocation)
names(baseplot_sampling) <- c("basePlot", "n_samples")
write.csv(x = baseplot_sampling, file = "~/neon-datasets/shotgun_metagenomics/baseplot_freq.csv", row.names = FALSE)

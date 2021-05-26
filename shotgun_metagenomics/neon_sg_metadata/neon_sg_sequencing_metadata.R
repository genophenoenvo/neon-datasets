#!/usr/bin/env Rscript

suppressMessages(library(neonUtilities))
suppressMessages(library(tidyverse))

# Downloading Data from NEON
# Set NEON API key
#NEON_TOKEN <- Sys.getenv(x = "NEON_TOKEN")

# Fetch metadata for shotgun metagenome sequences
#sg_met <- loadByProduct(startdate = "2013-06", enddate = "2019-09",
#                      dpID = 'DP1.10107.001', package = 'expanded',
#                     token = NEON_TOKEN, check.size = FALSE, nCores = 3)



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

# Filter data by:
# qaqcStatus == "Pass"
# dnaPooledStatus == "N"
# laboratoryName != "Argonne National Laboratory"

metagenomeDnaExtraction <- raw_metadata$mms_metagenomeDnaExtraction.csv %>% 
  filter(qaqcStatus == "Pass" &
           dnaPooledStatus == "N" &
           laboratoryName != "Argonne National Laboratory",
           sequenceAnalysisType != "marker gene")

# ---------------------------------------------------------------------------
# Filter metagenome sequencing by the DNA extraction id's included in the df above
# and remove sequencing that did not pass Quality Filtering
metagenomeSequencing <- raw_metadata$mms_metagenomeSequencing.csv %>% 
  filter(dnaSampleID %in% metagenomeDnaExtraction$dnaSampleID,
          is.na(dataQF))


#filter raw data files by:
# dnaSampleID
# QF comments = is.na(dataQF)
# only unique tar.gz directories = distinct(rawDataFileName, .keep_all = TRUE)

rawDataFiles <- raw_metadata$mms_rawDataFiles.csv %>% 
  filter(dnaSampleID %in% metagenomeSequencing$dnaSampleID,
         is.na(dataQF)) %>% 
          distinct(rawDataFileName, .keep_all = TRUE)

# output processed metadata
processed_metadata <- vector(mode = "list", length = length(raw_metadata))
# transfer all unfiltered metadata, these are usually instructional in nature
for(i in c(1,5:7)){
  processed_metadata[[i]] <- raw_metadata[[i]]
}
#transfer the same names
names(processed_metadata) <- names(raw_metadata)
#add back the processed data frames
processed_metadata[[2]] <- metagenomeDnaExtraction
processed_metadata[[3]] <- metagenomeSequencing
processed_metadata[[4]] <- rawDataFiles

#create directory in repo for processed metadata if it does not already exist
meta_dir <- "~/neon-datasets/shotgun_metagenomics/neon_sg_metadata/processed_metadata/"
if(!dir.exists(paste0(meta_dir)) ) {
  dir.create(paste0(meta_dir))
}

#write out processed metadata as csv's
for(i in names(processed_metadata)){
  write.csv(processed_metadata[[i]], file = paste0(meta_dir, i), row.names=FALSE)
}
# make general output directory for workflow
out_dir <- "~/neon_fastq/"
if(!dir.exists(paste0(out_dir)) ) {
  dir.create(paste0(out_dir))
}

# raw fastq files from NEON api get downloaded here
fq_out_dir <- paste0(out_dir, '00_raw_fastq/')
if(!dir.exists(paste0(fq_out_dir)) ) {
  dir.create(paste0(fq_out_dir))
}


# Download sequence data (lots of storage space needed!)
zipsByURI(filepath = meta_dir, savepath = fq_out_dir, check.size = FALSE,
          unzip = FALSE, saveZippedFiles = TRUE)

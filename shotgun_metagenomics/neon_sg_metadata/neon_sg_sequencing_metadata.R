library(neonUtilities)
library(tidyverse)
library(gridExtra)

# Downloading Data from NEON
# Set NEON API key
#NEON_TOKEN <- Sys.getenv(x = "NEON_TOKEN")

# Fetch metadata for shotgun metagenome sequences
#sg_met <- loadByProduct(startdate = "2013-06", enddate = "2019-09",
#                      dpID = 'DP1.10107.001', package = 'expanded',
#                     token = NEON_TOKEN, check.size = FALSE, nCores = 3)



# Soil Shotgun Metagenome Sequences: DP1.10107.001
#relative path to this folder
metadata__file_path <- "~/neon_sg_metadata/"

#list all the csv files (NEON Metadata)
data_path <- list.files(path = metadata__file_path,
                            pattern = "*.csv", full.names = TRUE)
#character vector of file names
filenames <- list.files(path = metadata__file_path,
                        pattern = "*.csv")
#read in list of files as data frames
raw_metadata <- lapply(data_path, FUN = function(i){
  read.csv(i, header=TRUE, stringsAsFactors = FALSE)})
#name the data frames in the list after their 
names(raw_metadata) <- filenames
colnames(raw_metadata$mms_metagenomeDnaExtraction.csv)


# filter out Argonne National Lab Sequences
neon_only <- vector(mode = "list", length = 6)
for(i in 1:length(neon_marker_genes)){
  neon_marker_genes[[i]] <- processed_marker_genes[[i]][processed_marker_genes[[i]]$laboratoryName != "Argonne National Laboratory",]
}
names(neon_marker_genes) <- names(processed_marker_genes)

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
# sanity check: unique tarballs of sequencing data:
# print(n2tab_count(rawDataFiles$rawDataFileName))

# generate cleaner combined metadata

# generate anvi'o TSV for sample names in snakemake workflow

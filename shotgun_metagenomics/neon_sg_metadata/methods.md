# NEON Shotgun Metagenome Data Processing

## 1. Download the Data

Download the fastq files using the R package `neon_utilities` and the script `neon_sg_metadata_merging.R`
This outputs a file for downstream processing with illumina utilities.

  * Download Metadata for Shotgun Metagenomics:
    * `neon_sg_metadata_merging.R` downloads all unique tar.gz files in the dnaSampleID's filtered
    * Untar directories of FASTQ files
  
  * Make sample bar code tsv for illumina-utils:
    * r1, r2, sample name


## 2. QA/QC

The `neon_sg_sequencing_metadata.R` script does rough QA/QC on the samples archived in the NEON database.
However, we need to QA/QC the R1 and R2 reads and demultiplex the samples.

We can do this with the following programs from meren's [illumina utils](https://github.com/meren/illumina-utils) python package.

  * Demultiplex Reads:
    * `iu-demultiplex -s sample_barcode.tsv --r1 FASTQ --r2 FASTQ`
    * adding the `-x` flag to the above statement will reverse compliment the barcodes
    * this generates the config file for quality filtering
  
  * Quality Filter Reads:
    * `iu-filter-quality-minoche config_file` 
    

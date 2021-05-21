# Purpose

*Download the shotgun metagenome data from NEON over a defined time period and generate curated metagenome assembled genomes by NEON site.*

# Contents
```
shotgun_metagenomics
 ┣ neon_sg_metadata
 ┃ ┣ categoricalCodes_10107.csv
 ┃ ┣ mms_metagenomeDnaExtraction.csv
 ┃ ┣ mms_metagenomeSequencing.csv
 ┃ ┣ mms_rawDataFiles.csv
 ┃ ┣ neon_sg_sequencing_metadata.R
 ┃ ┣ readme_10107.csv
 ┃ ┣ validation_10107.csv
 ┃ ┗ variables.csv
 ┣ README.md
 ┗ neon-anvio-config.snake
```

The contents of the directory `/neon_sg_metadata` allow a user to download the shotgun metagenome data from NEON over a defined time period and assemble/bin metagenome assembled genomes by site. The directory also includes the associated metadata files for the NEON API.

These FASTQ files are QA/QC'd with [illumina-utils](https://github.com/merenlab/illumina-utils), and the file `neon-anvio-config.snake` contains the instructions for the [anvi'o](https://merenlab.org/software/anvio/) snakemake shotgun metagenomics [workflow](https://merenlab.org/2018/07/09/anvio-snakemake-workflows/#metagenomics-workflow). The anvi'o workflow runs, via Docker or Singularity, inside a [configured instance](https://github.com/rbartelme/anvio-singularity) of the official [anvio](https://hub.docker.com/r/meren/anvio) Docker image.

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
    

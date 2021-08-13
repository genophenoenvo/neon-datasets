# Explore to see if file structure similar across all .txt files
library(ggplot2)
library(dplyr)

# Obtain all file names, then separate by site
all <- list.files("../rawData/phenophases")
clat <- grep("Clatskanie", all, value = TRUE)
corv <- grep("Corvallis", all, value = TRUE)
plac <- grep("Placerville", all, value = TRUE)
ucd <- grep("UCDavis", all, value = TRUE)

# Read in files and compare dimensions
n <- length(all)
all_txt <- list()
dim_df <- data.frame(name = character(n), rows = numeric(n), cols = numeric(n), uniqueIDs = numeric(n),
                     bin1 = numeric(n), bin2 = numeric(n),  bin3 = numeric(n), 
                     bin4 = numeric(n),  bin5 = numeric(n), bin6 = numeric(n))
for(i in 1:length(all)){
  all_txt[[i]] <- read.table(file = paste0("../rawData/phenophases/", all[i]))
  dim_df$name[i] <- all[i]
  dim_df[i, 2:ncol(dim_df)] <- c(nrow(all_txt[[i]]), 
                                 ncol(all_txt[[i]]),
                                 length(unique(all_txt[[i]][,1])),
                                 length(which(all_txt[[i]][,2] == 1)),
                                 length(which(all_txt[[i]][,2] == 2)),
                                 length(which(all_txt[[i]][,2] == 3)),
                                 length(which(all_txt[[i]][,2] == 4)),
                                 length(which(all_txt[[i]][,2] == 5)),
                                 length(which(all_txt[[i]][,2] == 6)))
                   
}
str(dim_df)
# How many duplicates?
dim_df$dupN <- dim_df$rows - dim_df$uniqueIDs
hist(dim_df$dupN, breaks = 30)

### compare to cultivar ids from genomic dataset
gen_ids <- read.table(file = "../rawData/cultivar_ids.txt")
gen_ids <- unlist(gen_ids)
str(gen_ids)
# obtain all unique cultivars
cults <- list()
for(i in 1:length(all_txt)){
  cults[[i]] <- data.frame(cultivar_ids = unique(all_txt[[i]]$V1))
}

max(unlist(lapply(cults, nrow))) # maximum number of unique cultivars is 1396 for any given phenophase dataset

phen_ids <- unlist(unique(do.call(rbind, cults)))
length(phen_ids) # Across surveys, 1482 unique cultivars represented

sum(gen_ids %in% phen_ids) # 1221 cottonwood cultivars overlap, have data for both
sum(phen_ids %in% gen_ids)

### Plot # of overlapping cultivars
sum_overlap <- data.frame(files = all)
sum_overlap$cultivar_overlap <- c()
sum_overlap$overlap_prop <- c()
for(i in 1:length(all_txt)){
  sum_overlap$cultivar_overlap[i] <- sum(unique(all_txt[[i]]$V1) %in% gen_ids)
  sum_overlap$overlap_prop[i] <- sum(unique(all_txt[[i]]$V1) %in% gen_ids) / length(unique(all_txt[[i]]$V1))
}
range(sum_overlap$cultivar_overlap)
range(sum_overlap$overlap_prop)

jpeg(filename = "../plots/01_explore/cultivar_overlap.jpg", 
     height = 8, width = 8, units = "in", res = 600)
ggplot(sum_overlap, aes(x = files, y = cultivar_overlap)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_bw(base_size = 12)
dev.off()


### Combine phenophase data across sites/dates/phenophases
all <- list.files("../rawData/phenophases")
all_list <- list()
files_df <- data.frame(fn = character(0),
                       site = character(0),
                       bud = character(0),
                       year = integer(0),
                       block = integer(0),
                       score = integer(0),
                       date = as.Date(x = integer(0), origin = "1970-01-01"))
dup_list <- list()
for(i in 1:length(all)){
  
  # Obtain characteristics from file names
  fn <- all[i]
  vars <- unlist(strsplit(fn, "\\_|\\.")) # split by either _ or .
  site <- vars[which(vars %in% c("Clatskanie", "Corvallis", "Placerville", "UCDavis"))] # which of 4 sites
  bud <- unique(vars[which(vars %in% c("Flush", "break", "burst", "Set"))]) # which phenophase; can match up "break" later
  year <- if(length(grep("^\\d{4}$", vars)) > 0) {
    as.numeric(grep("^\\d{4}$", vars, value = TRUE))
    } else {NA} # exact match of 4 digit year code
  rep <- if(length(grep("rep", vars, ignore.case = TRUE)) > 0) {
    readr::parse_number(grep("rep", vars, ignore.case = TRUE, value = TRUE))
    } else {NA} # rep number regardless of case
  score <- if(length(grep("score\\d{1}$", vars)) > 0) {
    readr::parse_number(grep("score\\d{1}$", vars, value = TRUE))
    } else if(length(grep("^\\d{1}$", vars)) > 0) {
    as.numeric(grep("^\\d{1}$", vars, value = TRUE))
    } else {NA}
  date <- if(length(grep("^\\d{1,2}-\\d{1,2}", vars)) > 0) {
    as.Date(paste0(year, "-", grep("^\\d{1,2}-\\d{1,2}", vars, value = TRUE)))
    } else {NA}
  
  # Add descriptors to dataframe
  all_list[[i]] <- read.table(file = paste0("../rawData/phenophases/", fn)) %>%
    rename(cultivar_id = V1, phenophase = V2) %>%
    mutate(site = site,
           budPhase = ifelse(bud %in% c("break", "burst"), "Flush", bud), # categorizes break and burst as Flush
           year = year,
           date = date,
           rep = rep,
           score = score) %>%
    relocate(cultivar_id, phenophase, .after = last_col())
  
  # Add descriptors to file list
  files_df[i, 1:6] <- c(fn, site, bud, year, rep, score)
  files_df[i, 7] <- date
  
  # Create list of duplicates
  dups <- all_list[[i]]$cultivar_id[duplicated(all_list[[i]]$cultivar_id)]
  dup_list[[i]] <- read.table(file = paste0("../rawData/phenophases/", fn)) %>%
    rename(cultivar_id = V1, phenophase = V2) %>%
    filter(cultivar_id %in% dups) %>%
    count(cultivar_id) %>%
    mutate(site = site,
           budPhase = ifelse(bud %in% c("break", "burst"), "Flush", bud), # categorizes break and burst as Flush
           year = year,
           date = date,
           rep = rep,
           score = score)
}

# Compare number of duplicates with dim_df
dup_df <- do.call(rbind.data.frame, dup_list)
hist(dup_df$n)
write.csv(dup_df, file = "../cleanData/dupGenotypes.csv")

# Write out files with missing dates
files_nodates <- files_df %>%
  filter(is.na(date))
write.csv(files_nodates, file = "../cleanData/noDates.csv")

# rbind all 76 files and check for budPhase terminology
all_df <- do.call(rbind.data.frame, all_list)
all_df$date <- as.Date(all_df$date, origin = "1970-01-01")
table(all_df$budPhase)

table(all_df$site, all_df$year)


### Summarize dataset availability by site-year-phenophase
files_sum <- files_df %>%
  group_by(site, year, bud) %>%
  count(bud)

# All 3 sites have 3 sampling points for 2010 bud set, 
# 1-2 sampling points for 2010 bud flush
# 1-2 sampoign points for 2013 bud flush

# Starting with 2010 bud set at Placerville site (has dates), 
# see if level 3.5 can be estimated with any confidence across reps/blocks

pl_2010_set <- all_df %>%
  filter(site == "Placerville" & year == 2010 & budPhase == "Set")

foo <- pl_2010_set %>%
  filter(phenophase %in% 1:6) %>%
  group_by(cultivar_id) %>%
  count(cultivar_id)


cults <- foo$cultivar_id[which(foo$n >= 9)]

length(cults) # 474, divisible by 6 and 79
for(i in 1:6){
  pdf(paste0("../plots/01_explore/Pl_2010_Set_", i, ".pdf"),
      height = 10, width = 10)
  pl_2010_set %>% 
    filter(cultivar_id %in% cults[(i*79-78):(i*79)] & phenophase %in% 1:6) %>%
    ggplot(aes(x = date, y = phenophase, color = as.factor(rep))) +
    geom_jitter(height = 0.1, width = 0) +
    scale_y_discrete(limits = factor(1:6)) +
    scale_x_date(date_breaks = "2 weeks", date_labels = "%m/%d") +
    facet_wrap(~cultivar_id)
  dev.off()
}


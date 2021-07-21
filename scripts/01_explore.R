# Explore to see if file structure similar across all .txt files
library(ggplot2)

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
for(i in 1:length(all_txt)){
  sum_overlap$cultivar_overlap[i] <- sum(unique(all_txt[[i]]$V1) %in% gen_ids)
}
range(sum_overlap$cultivar_overlap)

jpeg(filename = "../plots/01_explore/cultivar_overlap.jpg", 
     height = 8, width = 8, units = "in", res = 600)
ggplot(sum_overlap, aes(x = files, y = cultivar_overlap)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_bw(base_size = 12)
dev.off()

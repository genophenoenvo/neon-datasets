### Determine most frequent phases for bud break and bud set
library(dplyr)

load("../cleanData/all_df.Rdata")

# Give score to each of the dates
# Ignore UCDavis 2021 data, and bud burst by Marie
all  <- all_df %>%
  filter(site != "UCDavis") %>%
  mutate(score = ifelse(is.na(score), case_when(site == "Corvallis" & date == as.Date("2013-03-26") ~ 1,
                           site == "Corvallis" & date == as.Date("2013-04-01") ~ 2,
                           site == "Placerville" & date == as.Date("2010-04-01") ~ 1,
                           site == "Placerville" & date == as.Date("2010-04-22") ~ 2,
                           site == "Placerville" & date == as.Date("2010-09-02") ~ 1,
                           site == "Placerville" & date == as.Date("2010-09-16") ~ 2,
                           site == "Placerville" & date == as.Date("2010-10-01") ~ 3,
                           site == "Placerville" & date == as.Date("2012-04-20") ~ 1,
                           site == "Placerville" & date == as.Date("2012-05-01") ~ 2,
                           site == "Placerville" & date == as.Date("2013-03-29") ~ 1,
                           site == "Placerville" & date == as.Date("2013-04-12") ~ 2
                           ), score))

# Summarize by site, year, phase, cultivar_id, replicate

sum_df <- all %>%
  group_by(site, year, budPhase, score, cultivar_id) %>%
  summarize(start = min(phenophase, na.rm = TRUE),
            end = max(phenophase, na.rm = TRUE)) %>%
  mutate(cat = paste0(site, "_", year, "_", budPhase))

# Plot range as errorbars
sum_df %>%
  filter(is.nan(start) == FALSE & is.nan(end) == FALSE) %>%
  ggplot() +
  geom_errorbar(aes(x= cultivar_id, ymin = start, ymax = end), 
                alpha = 0.5) +
  scale_y_discrete("Phase") +
  facet_wrap(~cat)

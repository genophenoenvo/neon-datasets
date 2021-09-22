Curated NEON datasets
================

Contains scripts for downloading and cleaning data, and the resulting
data files. Metadata for original and curated datasets are in this
README.

### 1. Plant cover

#### Original data

-   **Plant presence and percent cover** dataset
-   Product ID *DP1.10058.001*
-   [Data portal
    link](https://data.neonscience.org/data-products/DP1.10058.001)
-   Summary: Plant cover for each species of plant was estimated in six
    1m2 subplots within 400m2 plots, where plant cover was percent of
    subplot ground covered as viewed from above. Each site has around 30
    plots, with sites distributed across the USA. Plant cover was taken
    multiple times per year over multiple years, depending on the site.
-   Additional useful information
    -   Some plants have vouchers/tissues collected that may be useful
        for genetic analyses
    -   The only data for plant height is `heightPlantOver300cm`, which
        indicates whether plants are taller than 9.8 feet

#### File structure

-   `plant_cover` folder
    -   Scripts
        -   `curate_data.R` cleans up data
    -   Derived data and figures
        -   `plant_cover.csv` is curated data

#### Curated data details

Columns:

-   `species`: species identification
-   `lat`: latitude of plot (decimal degrees)
-   `lon`: longitude of plot (decimal degrees)
-   `sitename`: site, plot, and subplot info combined in format
    `sitecode_plotID_subplotID`; e.g., `DSNY_DSNY_017_32.4.1` is site
    DSNY, plot 017, subplot 32.4.1
-   `date`: date of end of sampling in format YYYY-MM-DD
-   `canopy_cover`: amount of ground covered by that species in 1m2 area
    (%)
-   `uid`: unique identifier for each record as assigned by NEON

Summary figures and stats:

**Locations**

-   39 sites with 1307 total plots
-   Coordinates correspond to plot, not subplot
-   Map of plot locations:

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

-   Figure of number of plots per site, ordered by number of plots:

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

**Taxonomy**

-   293078 records for 3035 species
-   Table of the 20 species with the most records and their number of
    occurrences:

| Species                                                | Occurrences |
|:-------------------------------------------------------|------------:|
| Acer rubrum L.                                         |        5512 |
| Parthenocissus quinquefolia (L.) Planch.               |        4600 |
| Bouteloua gracilis (Willd. ex Kunth) Lag. ex Griffiths |        4181 |
| Maianthemum canadense Desf.                            |        3091 |
| Poa pratensis L.                                       |        2991 |
| Toxicodendron radicans (L.) Kuntze                     |        2986 |
| Schizachyrium scoparium (Michx.) Nash                  |        2387 |
| Bromus inermis Leyss.                                  |        2195 |
| Bromus tectorum L.                                     |        2126 |
| Sphaeralcea coccinea (Nutt.) Rydb.                     |        2116 |
| Bouteloua curtipendula (Michx.) Torr.                  |        2080 |
| Ambrosia psilostachya DC.                              |        2031 |
| Lonicera japonica Thunb.                               |        2027 |
| Aristida purpurea Nutt.                                |        1878 |
| Gutierrezia sarothrae (Pursh) Britton & Rusby          |        1808 |
| Plantago patagonica Jacq.                              |        1762 |
| Pascopyrum smithii (Rydb.) Á. Löve                     |        1761 |
| Vulpia octoflora (Walter) Rydb.                        |        1737 |
| Hesperostipa comata (Trin. & Rupr.) Barkworth          |        1630 |
| Microstegium vimineum (Trin.) A. Camus                 |        1629 |

**Time**

-   Records taken on 861 days from 2013-06-24 to 2019-11-12
-   Plot of number of records per day across entire time range:

![](README_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

### 2. Phenology measurements

#### Original data

**Plant phenology observations** dataset

-   Product ID *DP1.10055.001*
-   [Data portal
    link](https://data.neonscience.org/data-products/DP1.10055.001)
-   Summary: Phenophase status recorded for \~100 individual plants at
    each site across multiple years. Records are made for all plants up
    to multiple times a week depending on phenology activity. Each site
    has one transect along which all plants are included, with each
    individual plant tracked across each year. Tracked phenophases
    include initial growth, young leaves/needles, open flowers/pollen
    cones, colored leaves/needles, and falling leaves/needles.

**Precipitation** dataset

-   Product ID *DP1.00006.001*
-   [Data portal
    link](https://data.neonscience.org/data-products/DP1.00006.001)
-   Summary: Three methods of measuring precipiation were used, with
    only one or two used at some sites. Primary measurements were with a
    weighing gauge, second measurements with a tipping bucket on the
    tower, and throughfall measurements with tipping buckets on the
    ground. Both primary and throughfall methods were known to have
    errors in the data.

**Relative humidity** dataset

-   Product ID *DP1.00098.001*
-   [Data portal
    link](https://data.neonscience.org/data-products/DP1.00098.001)
-   Summary: At each NEON site, a Vaisala probe sensor collected
    relative humidity, air temperature, and dew point temperature
    measurements at every minute and 30 minutes at multiple locations,
    including one on the tower at the site. There are missing datapoints
    for all sites.

#### File structure

-   `phenology` folder
    -   Scripts
        -   `curate_data.R` cleans up data
    -   Input data
        -   `NPN_species_subset1_notes.csv` and
            `NPN_species_subset2.csv` contain lists of species from NPN
            with sequenced genomes
    -   Derived data and figures
        -   `phenology.csv` is curated data

#### Curated data details

Columns:

-   `individualID`: unique identifier assigned to each plant
-   `species`: species identification, including only species from [this
    NPN-based
    list](https://docs.google.com/document/d/1RnuLpn7sKXCJsJaM1UvufTpWRxXNYkgrRHPCijCIM1E/edit)
-   `lat`: latitude of plot (decimal degrees)
-   `lon`: longitude of plot (decimal degrees)
-   `sitename`: site and unique transect identifier, in the format
    site\_plotID
-   `first_flower_date`: earliest date per year for each individual to
    reach at least 50% of flowers open (i.e., `open flowers` is
    categorized as `50-74%`)
-   `uid_pheno`: unique identifier for the phenophase record
-   `uid_ind`: unique identifier for the individual record
-   `mean_daily_precip`: mean precipitation (millimeters) at that
    individual’s site in the year of `first_flower_date`, after summing
    precipitation for each day of year with 48 measurements and taking
    the mean across the year
-   `mean_humid`: mean yearly value, from daily mean humidity values
    calculated from days with at least ten humidity measurements on
    tower and summarized across years with at least 180 days of values
    (%)
-   `min_humid`: same as `mean_humid` but minimum value
-   `max_humid`: same as `mean_humid` but maximum value
-   `mean_temp`: mean yearly value, from daily mean air temperature
    values calculated from days with at least ten temperature
    measurements on tower and summarized across years with at least 180
    days of values (C)
-   `min_temp`: same as `mean_temp` but minimum value
-   `max_temp`: same as `mean_temp` but maximum value
-   `gdd`: cumulative growing degree days for date of individual’s
    `first_flower_date` starting from beginning of year, summed from
    growing degree day calculated for each day of the year from minimum
    and maximum daily temperature for days with at least 24 measurements
    using 10 degrees as cutoff

Summary figures and stats:

**Locations**

-   13 sites with 18 total transects
-   From 1 to 2 transects per site
-   Map of transect locations:

<!-- -->

    ## Warning in showSRID(uprojargs, format = "PROJ", multiline = "NO", prefer_proj =
    ## prefer_proj): Discarded datum unknown in Proj4 definition

![](README_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

**Taxonomy**

-   528 records for 9 species
-   Table of all species ordered by number of occurrences:

| Species                         | Occurrences |
|:--------------------------------|------------:|
| Acer rubrum L.                  |         110 |
| Lonicera maackii (Rupr.) Herder |          89 |
| Juglans nigra L.                |          81 |
| Larrea tridentata (DC.) Coville |          67 |
| Lindera benzoin (L.) Blume      |          65 |
| Prosopis velutina Woot.         |          58 |
| Acer rubrum L. var. rubrum      |          45 |
| Glycine max (L.) Merr.          |           7 |
| Zea mays L.                     |           6 |

-   Table of all species ordered by number of individuals:

| Species                         | Individuals |
|:--------------------------------|------------:|
| Acer rubrum L.                  |          67 |
| Lindera benzoin (L.) Blume      |          36 |
| Lonicera maackii (Rupr.) Herder |          34 |
| Juglans nigra L.                |          31 |
| Larrea tridentata (DC.) Coville |          31 |
| Acer rubrum L. var. rubrum      |          29 |
| Prosopis velutina Woot.         |          25 |
| Glycine max (L.) Merr.          |           7 |
| Zea mays L.                     |           6 |

-   Taxonomic tree of species:

![](README_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

**Time**

-   Records taken on 141 days from 2014-04-16 to 2020-07-22
-   Plot of number of records per day across entire time range:

![](README_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

### 3. Phenology images

#### Original data

**Phenology images** dataset

-   Product ID *DP1.00033.001*
-   [Data portal
    link](https://data.neonscience.org/data-products/DP1.00033.001)
    -   Data stored on
        [PhenoCam](https://phenocam.sr.unh.edu/webcam/about/) website
        [here](https://phenocam.sr.unh.edu/webcam/network/search/?sitename=&type=&primary_vegtype=&dominant_species=&active=unknown&fluxdata=unknown&group=neon);
        probably have to be downloaded individually by site?
-   Summary: Images (RGB and IR) taken from tops of towers at each site
    every 15 minutes, available for most sites back to early 2017.

**PhenoCam-derived phenology** data

-   [Metadata descriptions](https://phenocam.sr.unh.edu/webcam/tools/)
    (under “Standard Data Products” tab)
    -   [ROI Image
        Statistics](https://phenocam.sr.unh.edu/webcam/tools/roi_statistics_format/)
        files have values, including `gcc`, for each camera image
    -   [PhenoCam
        1-day](https://phenocam.sr.unh.edu/webcam/tools/summary_file_format/)
        files contain daily summaries of values from ROI Image
        Statistics, including `gcc_90`

**Weather** dataset

-   From ORNL’s [Daymet](https://daymet.ornl.gov/)
-   Data downloaded using R package
    [daymetr](https://github.com/bluegreen-labs/daymetr)
    -   Note: package has not been updated for Daymet Version 4, so 2020
        data not available
-   Summary: daily interpolated weather data on 1km x 1km grid for North
    America

#### File structure

-   `pheno_images` folder
    -   Scripts
        -   `curate_weather.R` downloads, cleans, and joins Daymet
            weather data to GCC dataset
    -   Derived data
        -   `targets_gcc.csv` is data curated into targets by [EFI
            Forecasting
            Challenge](https://ecoforecast.org/efi-rcn-forecast-challenges/)
            team
        -   `gcc_weather.csv` is joined GCC and Daymet data

#### Curated data details

[The
script](https://github.com/eco4cast/neon4cast-phenology/blob/master/phenology-workflow.R)
for downloading and cleaning the phenology data provided by EFI
Forecasting team. Data up to the current date can be downloaded into
this repo by doing the following:

``` r
targets_gcc <- readr::read_csv("https://data.ecoforecast.org/targets/phenology/phenology-targets.csv.gz")
write.csv(targets_gcc, "pheno_images/targets_gcc.csv", row.names = FALSE)
```

Columns:

-   `time`: date
-   `siteID`: name of NEON site
-   `gcc_90`: 90th percentile of green chromatic coordinate (GCC) from
    PhenoCam 1-day DB\_1000 file
-   `gcc_sd`: standard deviation of recalculated 90th percentile GCC
    from ROI Image Statistics DB\_1000 file
-   `daylength`: daily day light duration (seconds/day)
-   `precipitation`: sum of daily precipitation (mm/day)
-   `radiation`: shortwave radiation flux density (W/m2)
-   `snow_water_equiv`: amount of water in snow pack (kg/m2)
-   `max_temp`: daily maximum temperature (C)
-   `min_temp`: daily minimum temperature (C)
-   `vapor_pressure`: water vapor pressure (Pa)

Summary figures and stats:

-   8 sites and 7 weather variables

**GCC time series**

![](README_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

**Data availability across time**

![](README_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

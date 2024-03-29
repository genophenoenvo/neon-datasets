# Harmonizing Daymet and NOAA weather variables

For weather variables to be used in forecasting at eight NEON sites, past and projected weather data must be harmonized to the same time scale and units. Daymet data is reported daily, while NOAA weather forecasts were retrieved as hourly for 31 ensembles. NOAA data was first summarized as the hourly median across the ensembles and then as the sum, max, min, or mean to the daily scale. Unfortunately, VPD could not be calculated from the Daymet variables due to non-linearity between air temperature and saturated vapor pressure, and so is only available for the NOAA forecasts. 

| Variable | Units  |  Daymet name | Daymet process   | NOAA name  | NOAA process  |
|---|---|---|---|---|---|
| radiation  |MJ m<sup>-2</sup>d<sup>-1</sup>   | radiation  | Multiply average daylight incident shortwave radiation flux density by daylength (s) and convert to d | surface_downwelling_shortwave_flux_in_air  | Daily sum  |
| max_temp |  &deg;C | max_temp  |-   | air_temperature  | Daily maximum  |
| min_temp  | &deg;C  | min_temp  | -  | air_temperature  | Daily minimum  |
| precip  | mm d<sup>-1</sup>  | precipitation  | - | precipitation_flux  | Convert from flux units to height units, take daily maximum (is cumulative) |
| vpd  | kPa  | vapor_pressure  | NA; cannot calculate due to non-linearity  | relative_humidity, air_temperature  | Calculate hourly VPD and take daily mean |
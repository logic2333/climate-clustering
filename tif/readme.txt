pet = potential evapotranspiration, comes from TerraClimate http://www.climatologylab.org/terraclimate.html
other data are from CHELSA https://chelsa-climate.org/
pr = precipitation (unit: 0.1 mm, divide it by 10 to get values in mm), temp = temperature (unit: 0.1 K, divide it by 10 and minus 273.15 to get values in Celcius)

Bounding box: lat [-90, 83.5], lon [-180, 179.5]
Resolution: 0.5 degree * 0.5 degree, 347 * 719
CRS: WGS 84

More descriptions about the data please refer to CHELSA tech specification page 31
annual_pr: bio12
annual_temp: bio1
annual_temp_range: bio7
diurnal_temp_range: bio2
dry_pr: bio17
dry_temp: bio9
grow_season_length: gsl
pr_seasonal: bio15
snow_cover: duration(in days) of snow staying on ground within a year, scd of CHELSA(not documented in the tech spec)
summer_pr: bio18
summer_temp: bio10
temp_seasonal: bio4
wet_temp: bio8
wet_pr: bio16
winter_temp: bio11
winter_pr: bio19

t1..t12: daily mean temperature of each month
tmax1..tmax12: average daily high temperature of each month
tmin1..tmin12: average daily low temperature of each month

The tif files are all matrices storing corresponding values on the 0.5 degree * 0.5 degree grids
GeoTIFF format, can be loaded into GIS softwares like QGIS

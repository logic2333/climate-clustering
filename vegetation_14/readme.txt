This dataset uses Most likely IGBP class layer in the original HDF file for year 2019.
Original data access: https://lpdaac.usgs.gov/products/mcd12c1v006/
The layer is downsampled and clipped with QGIS using Nearest Neighbor algorithm.

This layer originally classifies global land into 16 vegetation categories.
Urban areas, unrelated to climate, are ignored(assigned as ocean/water body).
Croplands and Croplands/Natural Vegetation Mosaics are merged into one class, Cropland Mosaics.
So now we have 14 vegetation categories in total.


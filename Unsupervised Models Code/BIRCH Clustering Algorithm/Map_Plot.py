import pandas as pd
import numpy as np
from numpy import unique
from matplotlib import pyplot
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import os

# Parent Directory path
parent_dir = "Plots/"


def plot_map(name,k,df,lon,lat):
    directory = name
    path = os.path.join(parent_dir, directory)
    try:
        os.makedirs(path, exist_ok=True)
    except OSError as error:
        print("Directory '%s' can not be created" % directory)

    df['lat']= lat.apply(lambda x: 80-(0.5*x))
    df['lon']= lon.apply(lambda x: -180+(0.5*x))
    #FOR WHOLE MAP
    pyplot.figure(figsize=(20,20))
    ax = pyplot.axes(projection= ccrs.PlateCarree())
    pyplot.scatter(df['lon'],df['lat'], c=df['Clusters'],cmap='rainbow')
    ax.coastlines()
    ax.stock_img()
    ax.add_feature(cfeature.LAND)
    ax.add_feature(cfeature.OCEAN)
    ax.add_feature(cfeature.LAKES, alpha=0.5)
    ax.add_feature(cfeature.RIVERS)
    ax.add_feature(cfeature.COASTLINE)
    ax.add_feature(cfeature.BORDERS, linestyle=':')
    pyplot.title(f'{name} with {k} Clusters',fontsize = 50)
    pyplot.savefig(f'Plots/{name}/{name}{k}_complete.jpg')



def plot_maps(name,k,df,lon,lat):
    df['lat'] = lat.apply(lambda x: 80 - (0.5 * x))
    df['lon'] = lon.apply(lambda x: -180 + (0.5 * x))
    for i in range(k):
        pyplot.figure(figsize=(20,20))
        ax = pyplot.axes(projection= ccrs.PlateCarree())
        plot_df = df[df['Clusters']==i]
        pyplot.scatter(plot_df['lon'],plot_df['lat'],c=plot_df['Clusters'],cmap='rainbow')
        ax.coastlines()
        ax.stock_img()
        ax.add_feature(cfeature.LAND)
        ax.add_feature(cfeature.OCEAN)
        ax.add_feature(cfeature.LAKES, alpha=0.5)
        ax.add_feature(cfeature.RIVERS)
        ax.add_feature(cfeature.COASTLINE)
        ax.add_feature(cfeature.BORDERS, linestyle=':')
        pyplot.title(f' {name} (Cluster = {i})',fontsize = 50)
        pyplot.savefig(f'Plots/{name}/{name}{i}.jpg')
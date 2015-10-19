"""
Starting with a csv composed of the major cities in the world and their coordinates
we transform the coordinates to their equivalent on the cube and print the one
that fall on the same voxel
"""
import pandas as pd
from helpers import testPoint

path = "C:/Users/amate_000/Google Drive/WearHacks/L3DCube/Code/L3DCube-Processing-scripts/earth_weather_data/data/cities_list.csv"
cities_df = pd.read_csv(path, header=0, sep=",")

radius = 4
offset = 4

coord_list = []
for i in range(len(cities_df)):
    x, x_r, y, y_r, z, z_r = testPoint(cities_df.ix[i]["lat"], cities_df.ix[i]["long"], radius, offset=offset)
    coord = int(str(x_r)+str(y_r)+str(z_r))
    coord_list.append(coord)
    
cities_df["coord"] = coord_list
duplicates = set([x for x in coord_list if coord_list.count(x) > 1])

# print all duplicates
for value in duplicates:
    print(cities_df[cities_df["coord"]==value])
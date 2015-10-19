"""
Starting with a csv composed of the major cities in the world and their coordinates
we transform the coordinates to their equivalent on the cube and print the one
that fall on the same voxel
"""
import pandas as pd
import numpy as np
from helpers import testPoint

path = "C:/Users/amate_000/Google Drive/WearHacks/L3DCube/Code/L3DCube-Processing-scripts/earth_weather_data/data/world_capitals.csv"
cities_df = pd.read_csv(path, header=0, sep=",")
cities_df["lat"] = cities_df["lat"].convert_objects(convert_numeric=True)
cities_df["long"] = cities_df["long"].convert_objects(convert_numeric=True)

radius = 4
offset = 4

coord_list = []
for i in range(len(cities_df)):
    x, x_r, y, y_r, z, z_r = testPoint(cities_df.ix[i]["lat"], cities_df.ix[i]["long"], radius, offset=offset)
    coord = int(str(x_r)+str(y_r)+str(z_r))
    coord_list.append(coord)
    
cities_df["coord"] = coord_list

# Get coordinates for which duplicates exist
duplicates = set([x for x in coord_list if coord_list.count(x) > 1])

# print all duplicates and choose a random city between them
# delete others from df
for value in duplicates:
    dup_group = cities_df[cities_df["coord"]==value]
    print(dup_group)
    
    city_kept = np.random.randint(0, len(dup_group))
    print(dup_group.iloc[city_kept])
    dup_group = dup_group.drop([dup_group.index[city_kept]])
    
    for id, dup in dup_group.iterrows():
        cities_df = cities_df.drop([id])


# save new df
cities_df = cities_df.reset_index(drop=True)
cities_df = cities_df.drop("coord", 1)
cities_df.to_csv(path[:-4] + "_processed.csv", sep=",")

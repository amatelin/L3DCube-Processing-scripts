"""
Starting with a csv composed of the major cities in the world and their coordinates
we transform the coordinates to their equivalent on the cube and print the one
that fall on the same voxel
"""
import pandas as pd
import numpy as np
import json
from helpers import testPoint, list_duplicates

## This file is the list of the world's capitals as scraped from wikipedia
#path = "C:/Users/amate_000/Google Drive/WearHacks/L3DCube/Code/L3DCube-Processing-scripts/earth_weather_data/data/world_capitals.csv"
## That one comes from the weather API we'll be using. It's a json of all the cities in their db (+200k)
path = ".../earth_weather_data/data/openweathermap_cities.list.json"

# Parse json file
raw_data = []
with open(path, 'r', encoding="utf8") as infile:
    for line in infile:
        if "\ufeff" in line:
            pass
        else:
            parsed_json = json.loads(line)
            raw_data.append([parsed_json["_id"], parsed_json["name"], parsed_json["coord"]["lat"], parsed_json["coord"]["lon"]])

# Create df from file
cities_df = pd.DataFrame(raw_data, columns=["api_id", "name", "lat", "long"])    
#cities_df = pd.read_csv(path, header=0, sep=",")

cities_df["lat"] = cities_df["lat"].convert_objects(convert_numeric=True)
cities_df["long"] = cities_df["long"].convert_objects(convert_numeric=True)

radius = 4
offset = 4

# Get coordinates as they will be displayed on the cube
coord_list = []
for i in range(len(cities_df)):
    x, x_r, y, y_r, z, z_r = testPoint(cities_df.ix[i]["lat"], cities_df.ix[i]["long"], radius, offset=offset)
    coord = int(str(x_r)+str(y_r)+str(z_r))
    coord_list.append(coord)
    
cities_df["coord"] = coord_list

# Get coordinates for which duplicates exist 
# (it will take some time if you're using the api's json)
duplicates = list_duplicates(coord_list)

# print all duplicates and choose a random city between them
# delete others from df
# (comment print statements if analyzing json)
for value in duplicates:
    dup_group = cities_df[cities_df["coord"]==value]
#    print(dup_group)
    
    city_kept = np.random.randint(0, len(dup_group))
#    print(dup_group.iloc[city_kept])
    dup_group = dup_group.drop([dup_group.index[city_kept]])
    
    for id, dup in dup_group.iterrows():
        cities_df = cities_df.drop([id])


# save new df
cities_df = cities_df.reset_index(drop=True)
cities_df = cities_df.drop("coord", 1)
cities_df.to_csv(path[:-4] + "_processed.csv", sep=",")

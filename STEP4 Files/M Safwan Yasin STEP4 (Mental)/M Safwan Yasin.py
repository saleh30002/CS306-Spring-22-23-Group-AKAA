import geopandas as gpd
import matplotlib.pyplot as plt
import pandas as pd
import mysql.connector
from mysql.connector import errorcode
import numpy as np

try:
  db = mysql.connector.connect(user='root', password='helloworld123',
                              host='127.0.0.1',
                              database='cs306-project-akaa')
except mysql.connector.Error as err:
  if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
    print("Something is wrong with your user name or password")
  elif err.errno == errorcode.ER_BAD_DB_ERROR:
    print("Database does not exist")
  else:
    print(err)


query = "SELECT * FROM `cs306-project-akaa`.avgdalypercountry;"
avgDalyPerCountryDF = pd.read_sql(query, db)
db.close()


# Load the world shapefile data
world_map = gpd.read_file(gpd.datasets.get_path('naturalearth_lowres'))

# Merge the world map with your data
merged_data = world_map.merge(avgDalyPerCountryDF, left_on='iso_a3', right_on='countryCode', how='left')

# Plot the scatter map
fig, ax = plt.subplots(figsize=(20, 10))
merged_data.plot(column='avgDaly', cmap='Reds', linewidth=0.8, ax=ax, edgecolor='1', legend=True)

# Set plot title and axis labels
plt.title('Average DALY (1990-2015)')
plt.savefig("figure1.png", format="png", dpi=1200)
# Show the plot
plt.show()

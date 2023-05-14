import mysql.connector
from mysql.connector import errorcode
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, RadioButtons

try:
  db = mysql.connector.connect(user='root', password='cs306',
                              host='127.0.0.1',
                              database='cs306project')
except mysql.connector.Error as err:
  if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
    print("Something is wrong with your user name or password")
  elif err.errno == errorcode.ER_BAD_DB_ERROR:
    print("Database does not exist")
  else:
    print(err)


query = "SELECT * FROM cs306project."

countriesDF = pd.read_sql(query + "countries", db)
foodmanagementpercountryDF = pd.read_sql(query + "foodmanagementpercountry", db) 
meatmanagementpercountryDF = pd.read_sql(query + "meatmanagementpercountry", db)
vegetablesmanagementpercountryDF = pd.read_sql(query + "vegetablesmanagementpercountry", db)
db.close()

#print(countriesDF.head(5))
#print(meatmanagementpercountryDF.head(5))
#print(vegetablesmanagementpercountryDF.head(5))

data = foodmanagementpercountryDF

# Create initial plot
fig, ax = plt.subplots(figsize=(20,20))
plt.subplots_adjust(left=0.27, bottom=0.25)  # Adjust the plot to make room for the slider and radio buttons

# Initial values
year_0 = data['year'].min()
type_0 = 'Meat'
filtered_data = data[(data['year'] == year_0) & (data['typeOfFood'] == type_0)]

# Scatter plot
scatter = ax.scatter(filtered_data['production_1000_tonnes'], filtered_data['domestic_supply_quantity_1000_tonnes'], s=5, picker=True)

# Labels for the scatter points
labels = filtered_data['countryCode'].tolist()
for i, label in enumerate(labels):
    ax.annotate(label, (filtered_data['production_1000_tonnes'].iloc[i], filtered_data['domestic_supply_quantity_1000_tonnes'].iloc[i]), xytext=(0, 5), textcoords='offset points')

# Set axis labels
ax.set_xlabel('production_1000_tonnes')
ax.set_ylabel('domestic_supply_quantity_1000_tonnes')
ax.set_xscale('log')
ax.set_yscale('log')
ax.set_title(type_0 + ' production_1000_tonnes vs. domestic_supply_quantity_1000_tonnes by Country in '+ str(year_0))
# Add slider for year
ax_year = plt.axes([0.25, 0.1, 0.65, 0.03])
slider_year = Slider(ax_year, 'Year', data['year'].min(), data['year'].max(), valinit=year_0, valstep=1)

# Add radio buttons for type of food
ax_type = plt.axes([0.025, 0.5, 0.15, 0.15])
radio_type = RadioButtons(ax_type, ('Meat', 'Vegetables'), active=0)

# Update function
def update(val):
    
    year = int(slider_year.val)
    type_of_food = radio_type.value_selected
    filtered_data = data[(data['year'] == year) & (data['typeOfFood'] == type_of_food)]
    ax.cla()
    scatter = ax.scatter(filtered_data['production_1000_tonnes'], filtered_data['domestic_supply_quantity_1000_tonnes'], s=5, picker=True)
    labels = filtered_data['countryCode'].tolist()
    for i, label in enumerate(labels):
        ax.annotate(label, (filtered_data['production_1000_tonnes'].iloc[i], filtered_data['domestic_supply_quantity_1000_tonnes'].iloc[i]), xytext=(0, 5), textcoords='offset points')
    
    ax.set_xlabel('production_1000_tonnes')
    ax.set_ylabel('domestic_supply_quantity_1000_tonnes')
    ax.set_xscale('log')
    ax.set_yscale('log')
    ax.set_title(type_of_food + ' production_1000_tonnes vs. domestic_supply_quantity_1000_tonnes by Country in '+ str(year))
    fig.canvas.draw_idle()

slider_year.on_changed(update)
radio_type.on_clicked(update)

plt.show()
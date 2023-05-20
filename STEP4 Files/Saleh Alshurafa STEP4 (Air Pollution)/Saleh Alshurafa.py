import mysql.connector 
from mysql.connector import errorcode
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.widgets as widgets
import math


def connectionCreator():
  try:
    cnx = mysql.connector.connect(user="root", password="saleh123", database="cs306-project")
    print("Connection established with the database")
    return cnx
  except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
      print("Something is wring with your user name or password")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
      print("Database does not exist")
    else:
      print(err)
    return None
  else:
    cnx.close()
    return None
  
mydb = connectionCreator()

query = f"""SELECT *
    FROM `cs306-project`.airpollution A"""

df = pd.read_sql(query, mydb)

fig, ax = plt.subplots(figsize=(12, 6))

def on_radio_button_clicked(event):
    selected_year = int(radio_buttons_year.value_selected)
    selected_subset = int(radio_buttons_subset.value_selected)
    
    query =f"""SELECT *
    FROM `cs306-project`.airpollution A
    WHERE A.Year = {selected_year}"""

    df = pd.read_sql(query, mydb)
    countries = df['countryCode'] # country codes list
    subset_size = 31  # Number of countries in each subset

    # To split the countries into proper subsets, we find start and end indices from the country codes lists
    start_index = selected_subset * subset_size
    end_index = min((selected_subset + 1) * subset_size, len(countries))

    # Filtering the data based on the selected year and subset
    filtered_data = df[(df['Year'] == selected_year) & (df['countryCode'].isin(countries[start_index:end_index]))]

    # Extract the required columns
    subset_countries = filtered_data['countryCode']
    subset_pollution = filtered_data['PM2.5, mean annual exposure (μg/m³)']

    ax.clear()
    ax.barh(subset_countries, subset_pollution)
    ax.set_xlabel('PM2.5, mean annual exposure (μg/m³)')
    ax.set_ylabel('Country Code')
    ax.set_title(f'Pollution Data for Subset {selected_subset} and Year {selected_year}')
    plt.xticks(rotation='vertical')
    plt.subplots_adjust(bottom=0.3)
    plt.show()

years = df['Year'].unique()

"""At the start I used the query without the WHERE statement so that I can get all the year data correctly.
Had I not done that and instead declared and initalized the variable years after the initial_query,
the radio buttons would only show one year since the WHERE statement limits the number of years to only one.
An alternative can be to manually put the years into the years variable as a list, then there would not be a
need to have a query and initial_query different from each other."""

initial_query = f"""SELECT *
    FROM `cs306-project`.airpollution A
    WHERE A.Year = 1990"""   
df = pd.read_sql(initial_query, mydb)

countries = df['countryCode']
subset_size = 31
num_subsets = math.ceil(len(countries) / subset_size)

radio_button_ax_year = plt.axes([0.1, 0.05, 0.2, 0.2])
radio_buttons_year = widgets.RadioButtons(radio_button_ax_year, years, active=0)

radio_button_ax_subset = plt.axes([0.4, 0.05, 0.2, 0.2])
radio_buttons_subset = widgets.RadioButtons(radio_button_ax_subset, range(num_subsets), active=0)

radio_buttons_year.on_clicked(on_radio_button_clicked)
radio_buttons_subset.on_clicked(on_radio_button_clicked)

initial_start_index = 0
initial_end_index = min(subset_size, len(countries))

initial_year = years[0]
initial_filtered_data = df[df['Year'] == initial_year]

initial_subset_countries = initial_filtered_data['countryCode'][initial_start_index:initial_end_index]
initial_subset_pollution = initial_filtered_data['PM2.5, mean annual exposure (μg/m³)'][initial_start_index:initial_end_index]

ax.barh(initial_subset_countries, initial_subset_pollution)
ax.set_xlabel('PM2.5, mean annual exposure (μg/m³)')
ax.set_ylabel('Country Code')
ax.set_title(f'Pollution Data for Subset 0 and Year {initial_year}')
plt.xticks(rotation='vertical')
plt.subplots_adjust(bottom=0.3)
plt.show()
import mysql.connector
from mysql.connector import errorcode
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, RadioButtons

print(pd.__version__)

try:
  db = mysql.connector.connect(user='root', password='root',
                              host='127.0.0.1',
                              database='substance_abuse')
except mysql.connector.Error as err:
  if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
    print("Something is wrong with your user name or password")
  elif err.errno == errorcode.ER_BAD_DB_ERROR:
    print("Database does not exist")
  else:
    print(err)

cursor = db.cursor()

query = "SELECT * FROM substance_abuse."

cursor.execute(query + "countries")
countriesDF = pd.DataFrame(cursor.fetchall())
countriesDF.columns = ["countryCode", "countryName"]

cursor.execute(query + "substanceabusepercountry")
substanceabusepercountryDF = pd.DataFrame(cursor.fetchall())
substanceabusepercountryDF.columns = ["countryCode", "Year","AlcoholUseDisorder_Percent","DrugUseDisorder_Percent"]

cursor.execute(query + "countries_with_alcohol_higher_than_2")
alcohol_higher_than_2DF = pd.DataFrame(cursor.fetchall())
alcohol_higher_than_2DF.columns = ["countryCode","Year", "AlcoholUseDisorder_Percent"]

cursor.execute(query + "countries_with_drug_higher_than_alcohol")
drughigherthanalcoholDF = pd.DataFrame(cursor.fetchall())
drughigherthanalcoholDF.columns = ["countryCode", "Year", "AlcoholUseDisorder_Percent","DrugUseOrder_Percent"]

db.close()

#print(countriesDF.head(5))
#print(substanceabusepercountryDF.head(5))
#print(alcohol_higher_than_2DF.head(5))
#print(drughigherthanalcoholDF.head(5))

df = substanceabusepercountryDF

# Initialize the figure and axes
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 5))
plt.subplots_adjust(bottom=0.25)

# Function to update the pie charts based on the selected year
def update(year):
    ax1.clear()
    ax2.clear()
    
    # Filter data for the selected year
    filtered_df = df[df['Year'] == year]
    
    # Calculate the percentage of countries with alcohol percent above 2
    above_and_equal_2_alcohol = filtered_df[filtered_df['AlcoholUseDisorder_Percent'] >= 2].shape[0]
    below_2_alcohol = filtered_df[filtered_df['AlcoholUseDisorder_Percent'] < 2].shape[0]
    alcohol_percentages = [above_and_equal_2_alcohol, below_2_alcohol]
    
    # Calculate the percentage of countries with substance percent above 2
    more_Drug_Disorder = filtered_df[filtered_df['DrugUseDisorder_Percent'] >= filtered_df['AlcoholUseDisorder_Percent']].shape[0]
    more_Alcohol_Disorder = filtered_df[filtered_df['DrugUseDisorder_Percent'] < filtered_df['AlcoholUseDisorder_Percent']].shape[0]
    substance_percentages = [more_Drug_Disorder, more_Alcohol_Disorder]
    
    # Create pie charts
    ax1.pie(alcohol_percentages, explode=(0.1, 0), labels=['Above and Equal 2', 'Below 2'], colors=['green', 'red'], autopct='%1.1f%%')
    ax1.set_title('AlcoholUseDisorder_Percent')
    ax2.pie(substance_percentages, explode=(0.2, 0), labels=['More Drug Disorder', 'More Alcohol Disorder'], colors=['blue', 'orange'], autopct='%1.1f%%')
    ax2.set_title('DrugUseDisorder_Percent')
    
    plt.draw()

# Slider configuration
ax_slider = plt.axes([0.25, 0.1, 0.65, 0.03])
slider = Slider(ax_slider, 'Year', df['Year'].min(), df['Year'].max(), valinit=df['Year'].min(), valstep=1)

# Event handler for slider change
def on_slider_change(val):
    year = int(val)
    update(year)

slider.on_changed(on_slider_change)

# Initial update with the minimum year
update(df['Year'].min())

# Show the figure
plt.show()

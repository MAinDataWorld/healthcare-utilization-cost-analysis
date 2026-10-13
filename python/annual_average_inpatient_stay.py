from pathlib import Path
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_OUTPUT_DIR = PROJECT_ROOT / "data" / "sql_outputs"
CHART_DIR = PROJECT_ROOT / "visualizations"

CHART_DIR.mkdir(parents=True, exist_ok=True)

pd.set_option('display.max_columns', None)

# Load the inpatient utilization data
a = pd.read_csv(
    SQL_OUTPUT_DIR / "INPATIENT UTILIZATION*.*csv"
)

# Calculate the total inpatient length of stay for each year
average_length_yearly = a.groupby('encounter_year')['average_length_of_stay'].sum()

# Display the yearly results
print(average_length_yearly)

# Create the figure and define its dimensions
plt.figure(figsize=(10, 7))

# Plot annual inpatient length of stay
plt.plot(
    average_length_yearly.index,
    average_length_yearly.values,
    marker='o'
)

# Add chart labels and title
plt.xlabel('Year')
plt.ylabel('Average Length of Stay (Minutes)')
plt.title('Annual Average Inpatient Length of Stay')

# Adjust the layout to prevent overlapping elements
plt.tight_layout()

# Save the chart as a high-resolution PNG image
plt.savefig(
    CHART_DIR / "annual_average_inpatient_stay.png",
    dpi=300,
    bbox_inches='tight'
)

# Display the chart
plt.show()
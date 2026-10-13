from pathlib import Path
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_OUTPUT_DIR = PROJECT_ROOT / "data" / "sql_outputs"
CHART_DIR = PROJECT_ROOT / "visualizations"

CHART_DIR.mkdir(parents=True, exist_ok=True)

pd.set_option('display.max_columns', None)

# Load the readmission data
a = pd.read_csv(
   SQL_OUTPUT_DIR / "calculate rate of readmission within 30 days and total discharge.csv"
)

# Display the data
print(a)

# Extract readmission and discharge counts
total_discharges = a['total_discharges'].iloc[0]
readmission_30 = a['total_critical_readmission'].iloc[0]
readmission_over_30 = a['total_readmission_morethan30days'].iloc[0]

# Calculate discharges without readmission
no_readmission = total_discharges - readmission_30 - readmission_over_30

# Create categories for the pie chart
labels = [
    'No Readmission',
    'Readmission within ≤30 Days',
    'Readmission within >30 Days'
]

values = [
    no_readmission,
    readmission_30,
    readmission_over_30
]

# Create the pie chart
plt.figure(figsize=(8, 8))

wedges, _, _ = plt.pie(
    values,
    autopct='%1.1f%%',
    startangle=90
)

# Add a legend identifying each category
plt.legend(
    wedges,
    labels,
    title='Readmission Status',
    loc='best'
)

plt.title('Inpatient Readmission Status Following Discharge')

# Adjust the layout to prevent overlapping elements
plt.tight_layout()

# Save the chart as a high-resolution PNG image
plt.savefig(
     CHART_DIR / "inpatient_readmission_after_discharge.png",
    dpi=300,
    bbox_inches='tight'
)

# Display the chart
plt.show()
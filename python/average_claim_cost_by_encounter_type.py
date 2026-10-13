from pathlib import Path
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_OUTPUT_DIR = PROJECT_ROOT / "data" / "sql_outputs"
CHART_DIR = PROJECT_ROOT / "visualizations"

CHART_DIR.mkdir(parents=True, exist_ok=True)

pd.set_option('display.max_columns', None)

# Load the CSV file containing average claim costs by encounter type
a = pd.read_csv(
   SQL_OUTPUT_DIR / "total and average cost per encounter type.csv"
)

# Select encounter type and average claim cost, then sort in ascending order
average_claim = a.loc[:, ('encounterclass', 'average_claim_cost')].sort_values(
    'average_claim_cost',
    ascending=True
)

# Display the sorted data
print(average_claim)

# Create the figure and define its dimensions
plt.figure(figsize=(10, 7))

# Create a horizontal bar chart
plt.barh(
    average_claim['encounterclass'],
    average_claim['average_claim_cost']
)

# Add chart labels and title
plt.xlabel('Average Claim Cost')
plt.ylabel('Encounter Type')
plt.title('Average Claims Cost by Encounter Type')

# Adjust the layout to prevent overlapping elements
plt.tight_layout()

# Save the chart as a high-resolution PNG image
plt.savefig(
      CHART_DIR / "average_claimscost_by_encounter_type.png",
    dpi=300,
    bbox_inches='tight'
)

# Display the chart
plt.show()
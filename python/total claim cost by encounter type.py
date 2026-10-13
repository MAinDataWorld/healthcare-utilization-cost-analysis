from pathlib import Path
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from matplotlib.ticker import StrMethodFormatter

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_OUTPUT_DIR = PROJECT_ROOT / "data" / "sql_outputs"
CHART_DIR = PROJECT_ROOT / "visualizations"

CHART_DIR.mkdir(parents=True, exist_ok=True)

pd.set_option('display.max_columns', None)

# Load the CSV file containing total and average claim costs by encounter type
a = pd.read_csv(
    SQL_OUTPUT_DIR / "total and average cost per encounter type.csv"
)

# Create a separate DataFrame for total claim costs
total_claim_cost = a.loc[:, ('encounterclass', 'total_claim_cost')].sort_values(
    'total_claim_cost',
    ascending=True
)


# Display the total claim cost data
print(total_claim_cost)

# Create the figure and define its dimensions
plt.figure(figsize=(10, 7))

# Create a horizontal bar chart of total claim costs
plt.barh(
    total_claim_cost['encounterclass'],
    total_claim_cost['total_claim_cost']
)

# Add chart labels and title
plt.xlabel('Total Claim Cost')
plt.ylabel('Type of Encounter')
plt.title('Total Claim Cost by Encounter Type')

# Format x-axis values with commas and no decimal places
plt.gca().xaxis.set_major_formatter(StrMethodFormatter('{x:,.0f}'))

# Adjust the layout to prevent overlapping elements
plt.tight_layout()

# Save the chart as a high-resolution PNG image
plt.savefig(
    CHART_DIR / "total_claimcost_by_encountertype.png",
    dpi=300,
    bbox_inches='tight'
)

# Display the chart
plt.show()
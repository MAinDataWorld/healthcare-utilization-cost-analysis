from pathlib import Path
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_OUTPUT_DIR = PROJECT_ROOT / "data" / "sql_outputs"
CHART_DIR = PROJECT_ROOT / "visualizations"

CHART_DIR.mkdir(parents=True, exist_ok=True)

pd.set_option('display.max_columns', None)

# Load the CSV file containing encounter counts by type
a = pd.read_csv(
    SQL_OUTPUT_DIR / "encounters_by_type.csv"
)

# Sort encounter types by total encounters in ascending order
a = a.sort_values('total_encounters', ascending=True)

# Display the sorted data
print(a)

# Create the figure and define its dimensions
plt.figure(figsize=(10, 7))

# Create a horizontal bar chart
plt.barh(a['encounter_type'], a['total_encounters'])

# Add chart labels and title
plt.xlabel('Number of Encounters')
plt.ylabel('Encounter Type')
plt.title('Encounters by Encounter Type')

# Adjust the layout to prevent overlapping elements
plt.tight_layout()

# Save the chart as a high-resolution PNG image
plt.savefig(
     CHART_DIR / "encounters_by_type.png",
    dpi=300,
    bbox_inches='tight'
)

# Display the chart
plt.show()
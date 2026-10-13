from pathlib import Path
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_OUTPUT_DIR = PROJECT_ROOT / "data" / "sql_outputs"
CHART_DIR = PROJECT_ROOT / "visualizations"

CHART_DIR.mkdir(parents=True, exist_ok=True)

pd.set_option('display.max_columns', None)

# Load the CSV file containing encounter counts by age group
a = pd.read_csv(
     SQL_OUTPUT_DIR / "encounters_by_age_group.csv"
)

# Sort age groups in ascending order
a = a.sort_values('age_group', ascending=True)

# Display the sorted data
print(a)

# Create the figure and define its dimensions
plt.figure(figsize=(10, 7))

# Create a bar chart of encounters by age group
plt.bar(a['age_group'], a['total_encounters'])

# Add chart labels and title
plt.xlabel('Age Group')
plt.ylabel('Number of Encounters')
plt.title('Encounters by Age Group')

# Adjust the layout to prevent overlapping elements
plt.tight_layout()

# Save the chart as a high-resolution PNG image
plt.savefig(
    CHART_DIR / "encounters_by_age_group.png",
    dpi=300,
    bbox_inches='tight'
)

# Display the chart
plt.show()
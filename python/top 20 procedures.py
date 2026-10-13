from pathlib import Path
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_OUTPUT_DIR = PROJECT_ROOT / "data" / "sql_outputs"
CHART_DIR = PROJECT_ROOT / "visualizations"

CHART_DIR.mkdir(parents=True, exist_ok=True)

# Display all columns when printing DataFrames
pd.set_option('display.max_columns', None)

# Load SQL-generated results
a = pd.read_csv(
    SQL_OUTPUT_DIR / "top 20 procedures.csv"
)

# Sort procedures by frequency
a = a.sort_values('total_procedures', ascending=True)

# Remove "(procedure)" from procedure descriptions for cleaner labels
a['procedure_details'] = a['procedure_details'].str.rstrip('(procedure)')

print(a)

# Create horizontal bar chart
plt.figure(figsize=(10, 7))

plt.barh(
    a['procedure_details'],
    a['total_procedures']
)

plt.xlabel('Total Number of Procedures')
plt.ylabel('Procedure')
plt.title('Top 20 Procedures by Frequency')

plt.tight_layout()

# Save the figure at high resolution
plt.savefig(
   CHART_DIR / "Top_20_Procedures.png",
    dpi=300,
    bbox_inches='tight'
)

plt.show()
from pathlib import Path
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_OUTPUT_DIR = PROJECT_ROOT / "data" / "sql_outputs"
CHART_DIR = PROJECT_ROOT / "visualizations"

CHART_DIR.mkdir(parents=True, exist_ok=True)

pd.set_option('display.max_columns', None)

a = pd.read_csv(
    SQL_OUTPUT_DIR / "encounters over time.csv"
)

# Aggregate encounters by year
yearly_encounters = a.groupby('encounter_year')['total_encounters'].sum()

print(a.head())

print(yearly_encounters)

plt.figure(figsize=(12, 7))

plt.bar(yearly_encounters.index, yearly_encounters.values)

plt.xlabel('Year')
plt.ylabel('Number of Encounters')
plt.title('Encounters Over Time')

plt.xticks(rotation=45)

plt.tight_layout()

# Save the figure at high resolution
plt.savefig(
   CHART_DIR / "encounters_over_time.png",
    dpi=300,
    bbox_inches='tight'
)

plt.show()
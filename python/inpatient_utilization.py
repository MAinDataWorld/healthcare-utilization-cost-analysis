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
    SQL_OUTPUT_DIR / "INPATIENT UTILIZATION.csv"
)

# Calculate total inpatient admissions by year
yearly_utilization = a.groupby('encounter_year')[['total_admissions', 'total_discharges']].sum()

print(yearly_utilization)

plt.figure(figsize=(10, 7))

plt.plot(
    yearly_utilization.index,
    yearly_utilization['total_admissions'],
    marker='o'
)

plt.xlabel('Year')
plt.ylabel('Number of Inpatient Admissions')
plt.title('Annual Inpatient Admissions')

# Adjust the layout
plt.tight_layout()

plt.savefig(
    CHART_DIR / "total_yearly_inpatient_admissions.png',
    dpi=300,
    bbox_inches='tight'
)

plt.show()
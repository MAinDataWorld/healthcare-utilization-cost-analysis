from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

PROJECT_ROOT = Path(__file__).resolve().parents[1]

SQL_OUTPUT_DIR = PROJECT_ROOT / "data" / "sql_outputs"
CHART_DIR = PROJECT_ROOT / "visualizations"
CHART_DIR.mkdir(parents=True, exist_ok=True)

pd.set_option('display.max_columns', None)

# Load the monthly inpatient utilization data (one row per year-month)
a = pd.read_csv(SQL_OUTPUT_DIR / "INPATIENT UTILIZATION.csv")  # use your exact file name

# Convert each month's average back to total minutes, then weight by admissions
a['total_minutes'] = a['average_length_of_stay'] * a['total_admissions']

yearly = a.groupby('encounter_year').agg(
    total_minutes=('total_minutes', 'sum'),
    admissions=('total_admissions', 'sum')
)
yearly['avg_length_of_stay'] = yearly['total_minutes'] / yearly['admissions']

print(yearly)

plt.figure(figsize=(10, 7))
plt.plot(yearly.index, yearly['avg_length_of_stay'], marker='o')

plt.xlabel('Year')
plt.ylabel('Average Length of Stay (Minutes)')
plt.title('Annual Average Inpatient Length of Stay')
plt.tight_layout()

plt.savefig(CHART_DIR / "annual_average_inpatient_stay.png", dpi=300, bbox_inches='tight')
plt.show()
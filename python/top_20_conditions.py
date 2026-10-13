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
    SQL_OUTPUT_DIR / "top 20 conditions.csv"
)

# Split the original description into condition name and condition type
a['description_name'] = a['description'].str.split('(').str[0].str.strip()
a['description_type'] = a['description'].str.split('(').str[1].str.strip(')')

# Remove the original combined description column
a = a.drop(columns='description')

# Sort conditions in ascending order for the horizontal bar chart
a = a.sort_values('occurrence', ascending=True)

print(a)

plt.figure(figsize=(10, 7))

# Assign colors according to condition type
colors = a['description_type'].map({
    'disorder': 'steelblue',
    'finding': 'orange',
    'situation': 'green'
})

plt.barh(
    a['description_name'],
    a['occurrence'],
    color=colors
)

plt.xlabel('Number of Conditions')
plt.ylabel('Condition Name')
plt.title('Top 20 Conditions')

plt.legend(
    handles=[
        plt.Rectangle((0, 0), 1, 1, color='steelblue', label='Disorder'),
        plt.Rectangle((0, 0), 1, 1, color='orange', label='Finding'),
        plt.Rectangle((0, 0), 1, 1, color='green', label='Situation')
    ],
    title='Condition Type',
    loc='upper center',
    bbox_to_anchor=(0.5, 1.18),
    ncol=3
)

plt.tight_layout()

# Save the figure at high resolution before displaying it
plt.savefig(
    CHART_DIR / "Top_20_Conditions.png",
    dpi=300,
    bbox_inches='tight'
)

plt.show()


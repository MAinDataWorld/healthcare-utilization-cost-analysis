# Healthcare Utilization & Cost Analysis

An end-to-end healthcare analytics project exploring patient encounters, clinical activity, healthcare spending, and outcomes using **SQL Server, Python, and Power BI**.

The project combines data cleaning, exploratory SQL analysis, statistical visualization, and interactive dashboard development to identify utilization patterns, cost drivers, and potential areas for further investigation.

**Data source:** [Synthea — Synthetic Patient Generator](https://github.com/synthetichealth/synthea)

*All data are synthetic and do not represent real patient records.*

---

## Project at a Glance

| Metric | Result |
|---|---:|
| Patients | 108 |
| Healthcare encounters | 5,571 |
| Conditions / procedures / medication records | 3,517 / 15,884 / 3,850 |
| Total encounter claim cost | $16.81M |
| Payer coverage | $12.45M (74.1%) |
| Uncovered claim cost | $4.35M (25.9%) |
| Average cost per encounter | $3,016.72 |
| Emergency encounters | 270 |
| Inpatient admissions | 58 |
| 30-day inpatient readmission rate | 15.52% |

## Key Findings

**1. Ambulatory care drives overall spending.**

Ambulatory encounters represent 52.8% of all visits but account for approximately **76.3% of total claim costs ($12.82M)**. Inpatient and skilled nursing encounters have higher average costs per visit but occur much less frequently.

**2. Prenatal care emerged as a potential major cost driver.**

The initial analysis identified 502 prenatal-related encounters, with approximately $6.77M in associated claim costs. This finding requires confirmation of the encounter-identification criteria and cost calculation before being interpreted as a verified share of total spending.

**3. Healthcare utilization and costs are concentrated among a small group of patients.**

The ten highest-cost patients account for **37.8% of total claim costs**. Encounter volume alone does not explain spending: the most frequent users are not necessarily the most expensive patients.

**4. Wellness visits have a substantial coverage gap.**

Approximately **64% of wellness-visit costs are uncovered**, compared with around 21% for ambulatory and inpatient care. Overall, payer coverage accounts for 74.1% of total encounter claim costs.

**5. Emergency care affects most patients in the dataset.**

A total of 83 out of 108 patients (76.9%) had at least one emergency encounter. Emergency visits represent 4.8% of all encounters, with an average claim cost of approximately $3,108 per visit.

**6. Inpatient stays and readmissions warrant further investigation.**

The average inpatient stay is approximately 79 hours, while the median is 24 hours, indicating that a small number of long stays influence the average. Nine of 58 inpatient stays were followed by another admission within 30 days, giving a descriptive rate of 15.52% under the project's calculation.

**7. Healthcare activity increased over time, with important data limitations.**

Annual encounter volume peaked at 561 in 2021 and remained relatively high through 2025. However, the dataset contains sparse earlier records and only partial data for 2026, limiting direct year-to-year comparisons.

## Key Observations & Recommendations

These recommendations illustrate how the findings could guide further investigation in a real healthcare setting. They are exploratory, not clinical or operational conclusions.

- **Investigate major cost drivers:** Validate prenatal-related spending and compare costs across encounter types and patient groups.
- **Review preventive-care coverage:** Investigate why wellness visits have a high proportion of uncovered costs.
- **Examine high-cost patients:** Explore clinical characteristics and care patterns among the ten highest-cost patients rather than relying on encounter volume alone.
- **Evaluate inpatient transitions:** Investigate readmissions and prolonged stays to identify opportunities for improved discharge planning and follow-up.
- **Improve utilization monitoring:** Use patient-level and time-based analysis to distinguish changes in service volume from changes in cost.

## Power BI Dashboard

The interactive Power BI report combines a relational data model, DAX measures, and multiple report pages.

| Page | Focus |
|---|---|
| Healthcare Overview | Patient and encounter KPIs, spending, and utilization trends |
| Healthcare Utilization | Encounter patterns by age group, type, and time |
| Conditions & Procedures | Frequently recorded conditions and procedures |
| Cost & Outcomes | Healthcare costs, cost distribution, and inpatient outcomes |
| Medication & Procedure Costs | Medication and procedure cost analysis |
| Patient Details | Patient-level encounter history and clinical activity |

## Methodology

1. **Data preparation:** Explored and cleaned six source tables using Python and Pandas.
2. **SQL analysis:** Used SQL Server queries to investigate utilization, patient-level patterns, clinical activity, costs, length of stay, and readmissions.
3. **Data visualization:** Generated Matplotlib charts from SQL query outputs.
4. **Dashboard development:** Built a relational Power BI model with DAX measures and interactive report pages.
5. **Validation:** Compared key analytical outputs across SQL, Python visualizations, and Power BI.

## Tools & Technologies

- **SQL Server:** Exploratory analysis, joins, aggregations, CTEs, window functions, and date calculations
- **Python:** Data exploration and cleaning
- **Pandas:** Data manipulation
- **Matplotlib:** Statistical and descriptive visualizations
- **Power BI:** Data modeling, DAX, and interactive dashboards
- **GitHub:** Project organization and documentation

## Repository Structure

```text
healthcare-utilization-cost-analysis/
├── data/
│   ├── raw/
│   ├── processed/
│   └── sql_outputs/
├── python/
├── sql/
├── visualizations/
├── powerbi/
├── .gitignore
└── README.md
```

## Limitations

- **Synthetic data:** Findings cannot be generalized to real patient populations or healthcare systems.
- **Small sample:** The dataset contains only 108 patients, making several findings sensitive to individual records.
- **Incomplete time coverage:** Sparse historical records and a partial final year limit trend comparisons.
- **Cost definitions:** Encounter, procedure, and medication costs use different underlying measures and should not be added together.
- **Readmission analysis:** The calculated rate is descriptive and depends on the project's definition and available follow-up records.
- **Exploratory findings:** Observed patterns indicate areas for further analysis, not causal relationships.

## Reproducibility

The repository contains the original and cleaned datasets, Python scripts, SQL queries, query-output CSVs, Matplotlib visualizations, and Power BI report. Data-source paths may need adjustment when reproducing the project in another environment.

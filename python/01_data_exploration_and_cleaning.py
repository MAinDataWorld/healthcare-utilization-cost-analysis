#importing pathlib, pandas and numpy
from pathlib import Path

import pandas as pd

import numpy as np

# project root: the folder containing data/, python/, and sql/
PROJECT_ROOT = Path(__file__).resolve().parents[1]

RAW_DATA_DIR = PROJECT_ROOT / "data" / "raw"

PROCESSED_DATA_DIR = PROJECT_ROOT / "data" / "processed"

PROCESSED_DATA_DIR.mkdir(parents=True, exist_ok=True)

#displaying all columns

pd.set_option("display.max_columns", None)

pd.set_option("display.max_colwidth", None)

pd.set_option("display.width", None)

pd.set_option("display.expand_frame_repr", False)

#importing data from all 6 csv files

patients = pd.read_csv(RAW_DATA_DIR / "patients*.*csv")

encounters = pd.read_csv(RAW_DATA_DIR / "encounters*.*csv")

conditions = pd.read_csv(RAW_DATA_DIR / "conditions*.*csv")

procedures = pd.read_csv(RAW_DATA_DIR / "procedures*.*csv")

medications = pd.read_csv(RAW_DATA_DIR / "medications*.*csv")

observations = pd.read_csv(RAW_DATA_DIR / "observations*.*csv")

# Store all tables for systematic quality checks

tables = {
    "patients": patients,
    "encounters": encounters,
    "conditions": conditions,
    "procedures": procedures,
    "medications": medications,
    "observations": observations
}

# Check for exact duplicate rows

print("\n--- Duplicate row check ---")

for name, df in tables.items():

    print(
        f"{name.capitalize()}: "
        f"{df.duplicated().sum()} exact duplicate rows"
    )

#Check whether key identifiers are duplicated

print("\n--- Duplicate ID check ---")

print(
    f"Duplicate patient IDs: "
    f"{patients['Id'].duplicated().sum()}"
)

print(
    f"Duplicate encounter IDs: "
    f"{encounters['Id'].duplicated().sum()}"
)

# Check for missing values

print("\n--- Missing value check ---")

for name, df in tables.items():

    missing_values = df.isna().sum()

    missing_values = missing_values[missing_values > 0]

    print(f"\n{name.upper()}")

    if missing_values.empty:

        print("No missing values.")

    else:

        print(missing_values.to_string())

# Check missing-value percentages

print("\n--- Missing value percentages ---")

for name, df in tables.items():

    missing_percentage = (
        df.isna().mean() * 100
    )

    missing_percentage = (
        missing_percentage[
            missing_percentage > 0
        ]
        .sort_values(ascending=False)
    )

    print(f"\n{name.upper()}")

    if missing_percentage.empty:

        print("No missing values.")

    else:

        print(
            missing_percentage.round(2).to_string()
        )


#Converting date columns to datetime datatype where needed

patients['BIRTHDATE'] = pd.to_datetime(patients['BIRTHDATE'], dayfirst=True, errors="coerce")

patients['DEATHDATE'] = pd.to_datetime(patients['DEATHDATE'], dayfirst=True, errors="coerce")

encounters['START'] = pd.to_datetime(encounters['START'], errors="coerce")

encounters['STOP'] = pd.to_datetime(encounters['STOP'], errors="coerce")

conditions['START'] = pd.to_datetime(conditions['START'], dayfirst=True, errors="coerce")

conditions['STOP'] = pd.to_datetime(conditions['STOP'], dayfirst=True, errors="coerce")

procedures['START'] = pd.to_datetime(procedures['START'], errors="coerce")

procedures['STOP'] = pd.to_datetime(procedures['STOP'], errors="coerce")

medications['START'] = pd.to_datetime(medications['START'], errors="coerce")

medications['STOP'] = pd.to_datetime(medications['STOP'], errors="coerce")

observations['DATE'] = pd.to_datetime(observations['DATE'], errors="coerce")

# Verify date conversion

print("\n--- Date datatype check ---")

date_columns = {
    "patients": ["BIRTHDATE", "DEATHDATE"],
    "encounters": ["START", "STOP"],
    "conditions": ["START", "STOP"],
    "procedures": ["START", "STOP"],
    "medications": ["START", "STOP"],
    "observations": ["DATE"]
}

for name, columns in date_columns.items():

    print(f"\n{name.upper()}")

    for column in columns:

        print(
            f"{column}: "
            f"{tables[name][column].dtype} | "
            f"missing/NaT: "
            f"{tables[name][column].isna().sum()}"
        )


#Standardize column names

patients.columns = patients.columns.str.lower()

encounters.columns = encounters.columns.str.lower()

conditions.columns = conditions.columns.str.lower()

procedures.columns = procedures.columns.str.lower()

medications.columns = medications.columns.str.lower()

observations.columns = observations.columns.str.lower()


#saving cleaned data to cleaned data folder

patients.to_csv( PROCESSED_DATA_DIR / "patients_clean*.*csv", index=False)

encounters.to_csv( PROCESSED_DATA_DIR / "encounters_clean*.*csv", index=False)

conditions.to_csv( PROCESSED_DATA_DIR / "conditions_clean*.*csv", index=False)

procedures.to_csv( PROCESSED_DATA_DIR / "procedures_clean*.*csv", index=False)

medications.to_csv( PROCESSED_DATA_DIR / "medications_clean*.*csv", index=False)

observations.to_csv( PROCESSED_DATA_DIR / "observations_clean*.*csv", index=False)


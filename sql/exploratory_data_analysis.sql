USE Healthcare_Utilization;

-- How many patients --
SELECT
    COUNT(DISTINCT id) AS total_patients
FROM patients;

SELECT
    COUNT(*) AS total_patients
FROM patients;

-- How many encounters --
SELECT
    COUNT(DISTINCT id)
FROM encounters;

-- How many encounters per patient --
SELECT
    t1.id AS patient_id,
    CONCAT(t1.first, ' ', t1.last) AS patient_name,
    COUNT(t2.id) AS total_encouters
FROM patients t1
LEFT JOIN encounters t2
    ON t1.id = t2.patient
GROUP BY t1.id, CONCAT(t1.first, ' ', t1.last)
ORDER BY total_encouters;

-- How many patients had at least one encounter --
WITH cte_main AS (
    SELECT
        t1.id AS patient_id,
        CONCAT(t1.first, ' ', t1.last) AS patient_name,
        COUNT(t2.id) AS total_encounters
    FROM patients t1
    LEFT JOIN encounters t2
        ON t1.id = t2.patient
    GROUP BY t1.id, CONCAT(t1.first, ' ', t1.last)
)
SELECT
    COUNT(patient_id)
FROM cte_main
WHERE total_encounters >= 1;

-- Average encounters per patient --
WITH cte_main AS (
    SELECT
        t1.id AS patient_id,
        CONCAT(t1.first, ' ', t1.last) AS patient_name,
        COUNT(t2.id) AS total_encounters
    FROM patients t1
    LEFT JOIN encounters t2
        ON t1.id = t2.patient
    GROUP BY t1.id, CONCAT(t1.first, ' ', t1.last)
)
SELECT
    ROUND(CAST(SUM(total_encounters) AS DECIMAL(10, 2)) / COUNT(patient_id), 2) AS average_encounters
FROM cte_main;

-- Most common encounter types --
SELECT
    encounterclass AS encounter_type,
    COUNT(id) AS total_encounters
FROM encounters
GROUP BY encounterclass
ORDER BY total_encounters DESC;

SELECT TOP 5
    encounterclass AS encounter_type,
    COUNT(id) AS total_encounters
FROM encounters
GROUP BY encounterclass
ORDER BY total_encounters DESC;

-- Emergency utilization --
SELECT
    COUNT(*) AS emergency_encounters
FROM encounters
WHERE encounterclass LIKE '%emergency%';

-- Number of patients with emergency encounters --
SELECT
    COUNT(DISTINCT patient) AS emergency_patients
FROM encounters
WHERE encounterclass LIKE '%emergency%';

-- Inpatient utilization and number of patients with inpatient encounters --
SELECT
    COUNT(*) AS total_inpatient_encounters,
    COUNT(DISTINCT patient) AS inpatient_patients
FROM encounters
WHERE encounterclass LIKE '%inpatient%';

-- Encounter duration --
SELECT
    *,
    DATEDIFF(minute, start, stop) AS encounter_duration
FROM encounters;

-- Average inpatient length of stay --
SELECT
    AVG(DATEDIFF(hour, start, stop)) AS average_hoursinpatient_lengthofstay,
    AVG(DATEDIFF(minute, start, stop)) AS average_minutesinpatient_lengthofstay
FROM encounters
WHERE encounterclass LIKE '%inpatient%';

-- Patient age at encounter --
SELECT
    t2.id AS encounter_id,
    t1.id AS patient_id,
    CONCAT(t1.first, ' ', t1.last) AS patient_name,
    DATEDIFF(year, t1.birthdate, t2.start) -
        (CASE
            WHEN DATEADD(year, DATEDIFF(year, t1.birthdate, t2.start), t1.birthdate) > t2.start
                THEN 1
            ELSE 0
        END) AS patient_age_at_encounter,
    t1.birthdate,
    t2.start,
    t2.stop,
    t2.encounterclass
FROM patients t1
LEFT JOIN encounters t2
    ON t1.id = t2.patient;

-- Age groups and number of patients in each (at encounter) --
WITH cte_main AS (
    SELECT
        t2.id AS encounter_id,
        t1.id AS patient_id,
        t1.birthdate,
        t2.start,
        DATEDIFF(year, t1.birthdate, t2.start) -
            (CASE
                WHEN DATEADD(year, DATEDIFF(year, t1.birthdate, t2.start), t1.birthdate) > t2.start
                    THEN 1
                ELSE 0
            END) AS age_at_encounter
    FROM patients t1
    LEFT JOIN encounters t2
        ON t1.id = t2.patient
)
SELECT
    CASE
        WHEN age_at_encounter < 18 THEN '0-17'
        WHEN age_at_encounter < 30 THEN '18-29'
        WHEN age_at_encounter < 45 THEN '30-44'
        WHEN age_at_encounter < 65 THEN '45-64'
        WHEN age_at_encounter >= 65 THEN '65+'
        ELSE 'N/A'
    END AS age_group,
    COUNT(encounter_id) AS total_encounters
FROM cte_main
GROUP BY
    CASE
        WHEN age_at_encounter < 18 THEN '0-17'
        WHEN age_at_encounter < 30 THEN '18-29'
        WHEN age_at_encounter < 45 THEN '30-44'
        WHEN age_at_encounter < 65 THEN '45-64'
        WHEN age_at_encounter >= 65 THEN '65+'
        ELSE 'N/A'
    END;

-- Most common conditions --
SELECT TOP 20
    code,
    description,
    COUNT(*) AS occurrence
FROM conditions
GROUP BY code, description
ORDER BY occurrence DESC;

-- Conditions by encounter type and condition description --
SELECT
    t1.encounterclass,
    t2.description AS condition_description,
    COUNT(t2.code) AS total_conditions
FROM encounters t1
INNER JOIN conditions t2
    ON t1.id = t2.encounter
GROUP BY t1.encounterclass, t2.description;

-- Conditions by encounter type --
SELECT
    t1.encounterclass,
    COUNT(t2.code) AS total_conditions
FROM encounters t1
INNER JOIN conditions t2
    ON t1.id = t2.encounter
GROUP BY t1.encounterclass;

-- Conditions by age group --
WITH cte_main AS (
    SELECT
        *,
        DATEDIFF(year, t1.birthdate, t2.start) -
            (CASE
                WHEN DATEADD(year, DATEDIFF(year, t1.birthdate, t2.start), t1.birthdate) > t2.start
                    THEN 1
                ELSE 0
            END) AS age_at_condition
    FROM patients t1
    INNER JOIN conditions t2
        ON t1.id = t2.patient
)
SELECT
    CASE
        WHEN age_at_condition < 30 THEN '18-29'
        WHEN age_at_condition < 45 THEN '30-44'
        WHEN age_at_condition < 65 THEN '45-64'
        WHEN age_at_condition >= 65 THEN '65+'
        ELSE 'N/A'
    END AS age_group,
    COUNT(code) AS total_conditions
FROM cte_main
GROUP BY
    CASE
        WHEN age_at_condition < 30 THEN '18-29'
        WHEN age_at_condition < 45 THEN '30-44'
        WHEN age_at_condition < 65 THEN '45-64'
        WHEN age_at_condition >= 65 THEN '65+'
        ELSE 'N/A'
    END;

-- Most common procedures --
SELECT TOP 20
    code AS procedure_code,
    description AS procedure_details,
    COUNT(*) AS total_procedures
FROM procedures
GROUP BY code, description
ORDER BY total_procedures DESC;

-- Count of procedures per encounter type --
SELECT
    t1.encounterclass AS encounter_type,
    COUNT(t2.code) AS total_procedures
FROM encounters t1
INNER JOIN procedures t2
    ON t1.id = t2.encounter
GROUP BY t1.encounterclass;

SELECT
    t1.encounterclass AS encounter_type,
    t2.description AS procedure_,
    COUNT(t2.code) AS total_procedures
FROM encounters t1
INNER JOIN procedures t2
    ON t1.id = t2.encounter
GROUP BY t1.encounterclass, t2.description;

-- Most frequently recorded medications --
SELECT TOP 20
    description AS medication,
    COUNT(*) AS total_prescriptions
FROM medications_clean
GROUP BY description
ORDER BY total_prescriptions DESC;

-- Count of medications per patient --
SELECT
    t2.patient AS patient_id,
    CONCAT(t1.first, ' ', t1.last) AS patient_name,
    COUNT(t2.description) AS total_medications
FROM patients t1
INNER JOIN medications_clean t2
    ON t1.id = t2.patient
GROUP BY t2.patient, CONCAT(t1.first, ' ', t1.last);

-- Count of patients with above-average number of encounters --
WITH cte_main AS (
    SELECT
        COUNT(DISTINCT t1.id) AS total_patients,
        COUNT(t2.description) AS total_encounters,
        1.0 * COUNT(t2.description) / COUNT(DISTINCT t1.id) AS average_encounters_perpatient
    FROM patients t1
    LEFT JOIN encounters t2
        ON t1.id = t2.patient
),
cte_sub AS (
    SELECT
        t1.id AS patient_id,
        CONCAT(t1.first, ' ', t1.last) AS patient_name,
        COUNT(t2.description) AS total_encounters_perpatient
    FROM patients t1
    LEFT JOIN encounters t2
        ON t1.id = t2.patient
    GROUP BY t1.id, CONCAT(t1.first, ' ', t1.last)
)
SELECT
    *
FROM cte_sub t1
CROSS JOIN cte_main t2
WHERE t1.total_encounters > t2.average_encounters_perpatient;

-- Rank patients by number of encounters --
SELECT
    t1.id AS patient_id,
    CONCAT(t1.first, ' ', t1.last) AS patient_name,
    COUNT(t2.id) AS total_encounters,
    DENSE_RANK() OVER (ORDER BY COUNT(t2.id) DESC) AS ranking
FROM patients t1
LEFT JOIN encounters t2
    ON t1.id = t2.patient
GROUP BY t1.id, CONCAT(t1.first, ' ', t1.last)
ORDER BY ranking;

-- Rank conditions within each encounter class --
SELECT
    t1.encounterclass,
    t2.code AS condition_code,
    t2.description AS condition,
    COUNT(t2.code) AS total_conditions,
    DENSE_RANK() OVER (
        PARTITION BY t1.encounterclass
        ORDER BY COUNT(t2.code) DESC
    ) AS ranking
FROM encounters t1
INNER JOIN conditions t2
    ON t1.id = t2.encounter
GROUP BY t1.encounterclass, t2.code, t2.description
ORDER BY t1.encounterclass, ranking;

-- Readmission analysis (same patient readmission within 30 days after previous discharge) --
WITH cte_main AS (
    SELECT
        t2.patient AS patient_id,
        CONCAT(t1.first, ' ', t1.last) AS patient_name,
        t2.encounterclass,
        t2.start,
        t2.stop,
        LEAD(t2.start) OVER (PARTITION BY t2.patient ORDER BY t2.start) AS readmission
    FROM patients t1
    LEFT JOIN encounters t2
        ON t1.id = t2.patient
    WHERE t2.encounterclass = 'inpatient'
)
SELECT
    *,
    DATEDIFF(day, stop, readmission) AS daystillreadmission,
    CASE
        WHEN DATEDIFF(day, stop, readmission) <= 30 THEN 'within 30 days'
        WHEN DATEDIFF(day, stop, readmission) > 30 THEN 'more than 30 days'
        ELSE 'n/a'
    END AS readmission_analysis
FROM cte_main;

-- How many events and patients with readmission within 30 days --
WITH cte_main AS (
    SELECT
        t2.patient AS patient_id,
        CONCAT(t1.first, ' ', t1.last) AS patient_name,
        t2.encounterclass,
        t2.start,
        t2.stop,
        LEAD(t2.start) OVER (PARTITION BY t2.patient ORDER BY t2.start) AS readmission
    FROM patients t1
    LEFT JOIN encounters t2
        ON t1.id = t2.patient
    WHERE t2.encounterclass = 'inpatient'
),
cte_sub AS (
    SELECT
        *,
        DATEDIFF(day, stop, readmission) AS daystillreadmission,
        CASE
            WHEN DATEDIFF(day, stop, readmission) <= 30 THEN 'within 30 days'
            WHEN DATEDIFF(day, stop, readmission) > 30 THEN 'more than 30 days'
            ELSE 'n/a'
        END AS readmission_analysis
    FROM cte_main
)
SELECT
    COUNT(DISTINCT patient_id) AS patients_with_critical_readmission,
    COUNT(readmission_analysis) AS number_of_critical_readmission_events
FROM cte_sub
WHERE readmission_analysis = 'within 30 days';

-- Calculate rate of readmission within 30 days compared to total discharged inpatient patients --
WITH cte_main AS (
    SELECT
        t2.patient AS patient_id,
        CONCAT(t1.first, ' ', t1.last) AS patient_name,
        t2.encounterclass,
        t2.start,
        t2.stop,
        LEAD(t2.start) OVER (PARTITION BY t2.patient ORDER BY t2.start) AS readmission
    FROM patients t1
    LEFT JOIN encounters t2
        ON t1.id = t2.patient
    WHERE t2.encounterclass = 'inpatient'
),
cte_sub AS (
    SELECT
        *,
        DATEDIFF(day, stop, readmission) AS daystillreadmission,
        CASE
            WHEN DATEDIFF(day, stop, readmission) <= 30 THEN 'within 30 days'
            WHEN DATEDIFF(day, stop, readmission) > 30 THEN 'more than 30 days'
            ELSE 'n/a'
        END AS readmission_analysis
    FROM cte_main
)
SELECT
    CONCAT(
        ROUND(
            (CAST(
                (SELECT COUNT(readmission_analysis)
                 FROM cte_sub
                 WHERE readmission_analysis = 'within 30 days') AS float
            ) / COUNT(stop) * 100),
            2
        ),
        '%'
    ) AS rate_of_readmissionwithin30days
FROM cte_sub;

-- Healthcare cost analysis --

-- Total healthcare claim cost, total encounters, and average cost per encounter --
SELECT
    COUNT(id) AS total_encounters,
    ROUND(SUM(total_claim_cost), 2) AS total_claim_cost,
    ROUND(AVG(total_claim_cost), 2) AS average_cost_per_encounter
FROM encounters;

-- Total and average cost per encounter type --
SELECT
    encounterclass,
    ROUND(SUM(total_claim_cost), 2) AS total_claim_cost,
    ROUND(AVG(total_claim_cost), 2) AS average_claim_cost
FROM encounters
GROUP BY encounterclass
ORDER BY total_claim_cost DESC;

-- Total claim cost, total payer coverage, and total uncovered cost --
SELECT
    ROUND(SUM(total_claim_cost), 2) AS total_claim_cost,
    ROUND(SUM(payer_coverage), 2) AS total_payer_coverage,
    ROUND(SUM(total_claim_cost) - SUM(payer_coverage), 2) AS total_uncovered_cost
FROM encounters;

-- Cost by patient --
SELECT
    t1.id AS patient_id,
    CONCAT(t1.first, ' ', t1.last) AS patient_name,
    ROUND(SUM(t2.total_claim_cost), 2) AS total_claim_cost,
    ROUND(AVG(t2.total_claim_cost), 2) AS average_claim_cost
FROM patients t1
LEFT JOIN encounters t2
    ON t1.id = t2.patient
GROUP BY t1.id, CONCAT(t1.first, ' ', t1.last)
ORDER BY SUM(t2.total_claim_cost) DESC;

-- Ranking patients by their total claim cost --
WITH cte_main AS (
    SELECT
        t1.id AS patient_id,
        CONCAT(t1.first, ' ', t1.last) AS patient_name,
        ROUND(SUM(t2.total_claim_cost), 2) AS total_claim_cost,
        ROUND(AVG(t2.total_claim_cost), 2) AS average_claim_cost
    FROM patients t1
    LEFT JOIN encounters t2
        ON t1.id = t2.patient
    GROUP BY t1.id, CONCAT(t1.first, ' ', t1.last)
)
SELECT
    *,
    DENSE_RANK() OVER (ORDER BY total_claim_cost DESC) AS ranking
FROM cte_main
ORDER BY ranking;

-- Count of encounters per month and year --
SELECT
    YEAR(start) AS encounter_year,
    MONTH(start) AS encounter_month,
    DATENAME(month, start) AS encounter_month_name,
    COUNT(id) AS total_encounters
FROM encounters
GROUP BY YEAR(start), MONTH(start), DATENAME(month, start)
ORDER BY encounter_year;

-- Count of emergency encounters per year --
SELECT
    YEAR(start) AS encounter_year,
    COUNT(id) AS total_encounters
FROM encounters
WHERE encounterclass LIKE '%emergency%'
GROUP BY YEAR(start)
ORDER BY total_encounters DESC;

-- Inpatient utilization: number of admissions, discharges, and average length of inpatient stay per month and year --
SELECT
    YEAR(t2.start) AS encounter_year,
    MONTH(t2.start) AS encounter_month,
    DATENAME(month, t2.start) AS encounter_month,
    COUNT(start) AS total_admissions,
    COUNT(stop) AS total_discharges,
    AVG(DATEDIFF(minute, start, stop)) AS average_lenngth_of_stay
FROM patients t1
LEFT JOIN encounters t2
    ON t1.id = t2.patient
WHERE t2.encounterclass = 'inpatient'
GROUP BY YEAR(t2.start), MONTH(t2.start), DATENAME(month, t2.start)
ORDER BY encounter_year;

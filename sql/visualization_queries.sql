USE Healthcare_Utilization;
--SQL QUERIES LOADED SEPARATELY TO .CSV FOR MATPLOTLIB PLOTTING--
--calculate rate of readmission within 30 days compared to total discharged inpatient patients AND total number of readmissions of within 30 days, more than 30 days, and total discharge--
WITH cte_main AS(
SELECT 
t2.patient AS patient_id,
CONCAT (t1.first, ' ', t1.last) AS patient_name,
t2.encounterclass,
t2.start,
t2.stop,
LEAD (t2.start) OVER (PARTITION BY t2.patient ORDER BY t2.start) AS readmission
FROM patients t1
LEFT JOIN encounters t2
ON t1.id = t2.patient
WHERE t2.encounterclass = 'inpatient'
),
cte_sub AS(
SELECT *,
DATEDIFF(day, stop, readmission) AS daystillreadmission,
CASE WHEN DATEDIFF(day, stop, readmission) <= 30 
THEN 'within 30 days'
WHEN DATEDIFF(day, stop, readmission) > 30 
THEN 'more than 30 days'
ELSE 'n/a'
END AS readmission_analysis
FROM cte_main
)
SELECT
CONCAT (ROUND((CAST ((SELECT COUNT (readmission_analysis) FROM cte_sub WHERE readmission_analysis = 'within 30 days') AS float) /COUNT(stop) * 100),2), '%')  AS rate_of_readmissionwithin30days,
(SELECT COUNT (readmission_analysis) FROM cte_sub WHERE readmission_analysis = 'within 30 days') AS total_critical_readmission,
(SELECT COUNT (readmission_analysis) FROM cte_sub WHERE readmission_analysis = 'more than 30 days') AS total_readmission_morethan30days,
COUNT(stop) AS total_discharges
FROM cte_sub;
--age groups and number of patients in each (at encounter)--
WITH cte_main AS (
SELECT 
t2.id AS encounter_id,
t1.id AS patient_id, 
t1.birthdate,
t2.start,
DATEDIFF (year, t1.birthdate, t2.start) - (CASE WHEN DATEADD( year, DATEDIFF (year, t1.birthdate, t2.start), t1.birthdate) > t2.start 
THEN 1
ELSE 0 
END) AS age_at_encounter
FROM patients t1
LEFT JOIN encounters t2
ON t1.id = t2.patient
)
SELECT 
CASE WHEN age_at_encounter < 18 THEN '0-17'
WHEN age_at_encounter < 30 THEN '18-29'
WHEN age_at_encounter < 45 THEN '30-44'
WHEN age_at_encounter <65 THEN '45-64'
WHEN age_at_encounter >= 65 THEN '65+' 
ELSE 'N/A'
END AS age_group,
COUNT(encounter_id) AS total_encounters
FROM cte_main
GROUP BY CASE WHEN age_at_encounter < 18 THEN '0-17'
WHEN age_at_encounter < 30 THEN '18-29'
WHEN age_at_encounter < 45 THEN '30-44'
WHEN age_at_encounter <65 THEN '45-64'
WHEN age_at_encounter >= 65 THEN '65+' 
ELSE 'N/A'
END;
--Most common encounter types--
SELECT 
encounterclass AS encounter_type,
COUNT(id) AS total_encounters
FROM encounters
GROUP BY encounterclass
ORDER BY total_encounters DESC;
--Count of encounters per month and year--
SELECT 
YEAR(start) AS encounter_year,
MONTH(start) AS encounter_month,
DATENAME(month, start) AS encounter_month_name,
COUNT(id) AS total_encounters
FROM encounters
GROUP BY YEAR(start), MONTH(start), DATENAME(month, start)
ORDER BY encounter_year;
--total and average cost per encounter type--
SELECT 
encounterclass,
ROUND(SUM(total_claim_cost),2) AS total_claim_cost,
ROUND(AVG(total_claim_cost),2) AS average_claim_cost
FROM encounters
GROUP BY encounterclass
ORDER BY total_claim_cost DESC;
-- Most common conditions--
SELECT 
TOP 20
code,
description,
COUNT(*) AS occurrence
FROM conditions
GROUP BY code,description
ORDER BY occurrence DESC;
--most common procedures--
SELECT 
TOP 20 
code AS procedure_code,
description AS procedure_details,
COUNT(*) AS total_procedures
FROM procedures
GROUP BY code, description
ORDER BY total_procedures DESC;
--INPATIENT UTILIZATION: number of admissions, discharges, and average length of inpatient stay per month and year--
SELECT 
YEAR(t2.start) AS encounter_year,
MONTH(t2.start) AS encounter_month,
DATENAME(month, t2.start) AS encounter_month,
COUNT(start) AS total_admissions,
COUNT(stop) AS total_discharges,
AVG(DATEDIFF( minute, start, stop)) AS average_lenngth_of_stay 
FROM patients t1
LEFT JOIN encounters t2
ON t1.id = t2.patient
WHERE t2.encounterclass = 'inpatient'
GROUP BY YEAR(t2.start), MONTH(t2.start), DATENAME(month, t2.start)
ORDER BY encounter_year




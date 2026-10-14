USE Healthcare_Utilization;

-- Age groups --
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
    *,
    CASE
        WHEN age_at_encounter < 18 THEN '0-17'
        WHEN age_at_encounter < 30 THEN '18-29'
        WHEN age_at_encounter < 45 THEN '30-44'
        WHEN age_at_encounter < 65 THEN '45-64'
        WHEN age_at_encounter >= 65 THEN '65+'
        ELSE 'N/A'
    END AS age_group
FROM cte_main;


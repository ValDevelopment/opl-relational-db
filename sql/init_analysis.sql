USE powerlifting_analytics;

SELECT
    r.result_id,
    l.Name,
    l.Sex,
    m.MeetName,
    m.Date,
    m.Federation,
    r.Event,
    r.Equipment,
    r.BodyweightKg,
    r.TotalKg,
    r.Dots
FROM results AS r
JOIN lifters AS l
    ON r.lifter_id = l.lifter_id
JOIN meets AS m
    ON r.meet_id = m.meet_id
WHERE r.TotalKg IS NOT NULL
ORDER BY r.Dots DESC
LIMIT 25;


SELECT 
	m.Federation, 
	COUNT(*) AS result_count 
FROM results AS r
JOIN meets AS m
	ON r.meet_id = m.meet_id
GROUP BY m.Federation
ORDER BY result_count DESC;


SELECT 
	m.Federation,
    AVG(r.Dots) AS avg_dots
FROM results AS r
JOIN meets AS m
	ON r.meet_id = m.meet_id
WHERE r.Dots IS NOT NULL
GROUP BY m.Federation
ORDER BY avg_dots DESC;

SELECT
	m.Federation,
    COUNT(r.Dots) AS result_count,
    AVG(r.Dots) AS avg_dots
FROM results AS r
JOIN meets AS m
	ON r.meet_id = m.meet_id
GROUP BY m.Federation
HAVING COUNT(r.Dots) > 100
ORDER BY avg_dots DESC;


SELECT
	r.Equipment,
    AVG(r.Dots) as avg_dots
FROM results AS r
WHERE Event = 'SBD'
GROUP BY r.Equipment
ORDER BY avg_dots DESC;

SELECT
	r.Equipment,
    l.Sex,
    COUNT(r.Dots) as dots_count,
    AVG(r.Dots) as avg_dots
FROM results AS r
JOIN lifters AS l
	ON r.lifter_id = l.lifter_id
WHERE Event = 'SBD'
GROUP BY r.Equipment, l.Sex
ORDER BY r.Equipment, avg_dots DESC;

SELECT
	r.Equipment,
    l.Sex,
    AVG(r.TotalKg) as avg_total
FROM results AS r
JOIN lifters AS l
	ON r.lifter_id = l.lifter_id
WHERE Event = 'SBD'
GROUP BY r.Equipment, l.Sex
ORDER BY avg_total DESC;

SELECT
    r.Equipment,
    COUNT(r.Squat3Kg) AS third_attempts,
    AVG(
        CASE
            WHEN r.Squat3Kg > 0 THEN 1
            ELSE 0
        END
    ) * 100 AS success_rate_pct
FROM results AS r
WHERE r.Event = 'SBD'
  AND r.Squat3Kg IS NOT NULL
GROUP BY r.Equipment
ORDER BY success_rate_pct DESC;

SELECT 
	r.Equipment,
    COUNT(r.Bench3Kg) AS third_attempt,
    AVG(
		CASE
			WHEN r.Bench3Kg > 0 THEN 1
            ELSE 0
		END
	) * 100 AS success_pct
FROM results AS r
WHERE r.Event = 'SBD'
	AND r.Bench3Kg IS NOT NULL
GROUP BY r.Equipment
ORDER BY success_pct DESC;

SELECT 
	r.Equipment,
    COUNT(r.Deadlift3Kg) AS third_attempt,
    AVG(
		CASE
			WHEN r.Deadlift3Kg > 0 THEN 1
            ELSE 0
		END
	) * 100 AS success_pct
FROM results AS r
WHERE r.Event = 'SBD'
	AND r.Deadlift3Kg IS NOT NULL
GROUP BY r.Equipment
ORDER BY success_pct DESC;

SELECT
    r.Equipment,

    COUNT(r.Squat3Kg) AS squat_third_attempts,
    AVG(
        CASE
            WHEN r.Squat3Kg > 0 THEN 1
            WHEN r.Squat3Kg < 0 THEN 0
            ELSE NULL
        END
    ) * 100 AS pct_squat,

    COUNT(r.Bench3Kg) AS bench_third_attempts,
    AVG(
        CASE
            WHEN r.Bench3Kg > 0 THEN 1
            WHEN r.Bench3Kg < 0 THEN 0
            ELSE NULL
        END
    ) * 100 AS pct_bench,

    COUNT(r.Deadlift3Kg) AS deadlift_third_attempts,
    AVG(
        CASE
            WHEN r.Deadlift3Kg > 0 THEN 1
            WHEN r.Deadlift3Kg < 0 THEN 0
            ELSE NULL
        END
    ) * 100 AS pct_deadlift
FROM results AS r
WHERE r.Event = 'SBD'
GROUP BY r.Equipment;


WITH equipment_averages AS (
    SELECT
        r.Equipment,
        AVG(r.TotalKg) AS avg_total
    FROM results AS r
    WHERE r.Event = 'SBD'
      AND r.TotalKg IS NOT NULL
    GROUP BY r.Equipment
),
overall_average AS (
    SELECT
        AVG(r.TotalKg) AS overall_avg_total
    FROM results AS r
    WHERE r.Event = 'SBD'
      AND r.TotalKg IS NOT NULL
)
SELECT
    e.Equipment,
    e.avg_total
FROM equipment_averages AS e
CROSS JOIN overall_average AS o
WHERE e.avg_total > o.overall_avg_total
ORDER BY e.avg_total DESC;


WITH equipment_averages AS (
    SELECT
    r.Equipment,
    AVG(r.TotalKg) AS avg_total
    FROM results AS r
    WHERE r.Event = 'SBD'
    GROUP BY r.Equipment
)
SELECT *
FROM equipment_averages
ORDER BY avg_total DESC;

WITH raw_sbd AS (
	SELECT
    r.TotalKg,
    r.lifter_id
    FROM results AS r
    WHERE r.Equipment = 'raw'
    AND r.Event = 'SBD'
)
SELECT 
	l.Sex,
    AVG(raw.TotalKg) AS avg_total
    FROM raw_sbd AS raw
    JOIN lifters AS l
    ON raw.lifter_id = l.lifter_id
    GROUP BY l.Sex
    ORDER BY avg_total DESC;
    
    
    

WITH sanctioned_meets AS (
	SELECT 
    m.Sanctioned,
    m.meet_id,
    m.Federation
    FROM meets as m
    WHERE m.Sanctioned = 'Yes'
)
SELECT
    r.meet_id,
    COUNT(*) AS result_count
FROM results AS r
JOIN sanctioned_meets AS sm
    ON r.meet_id = sm.meet_id
GROUP BY sm.Federation
ORDER BY result_count;
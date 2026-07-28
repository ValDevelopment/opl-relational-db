USE powerlifting_analytics;

-- Results by federation
SELECT
    m.Federation,
    COUNT(*) AS result_count
FROM results AS r
JOIN meets AS m
    ON r.meet_id = m.meet_id
GROUP BY m.Federation
ORDER BY result_count DESC;


-- Average DOTS by federation
SELECT
    m.Federation,
    COUNT(r.Dots) AS dots_count,
    AVG(r.Dots) AS avg_dots
FROM results AS r
JOIN meets AS m
    ON r.meet_id = m.meet_id
GROUP BY m.Federation
HAVING COUNT(r.Dots) > 100
ORDER BY avg_dots DESC;


-- Average DOTS by equipment for SBD results
SELECT
    r.Equipment,
    COUNT(r.Dots) AS dots_count,
    AVG(r.Dots) AS avg_dots
FROM results AS r
WHERE r.Event = 'SBD'
GROUP BY r.Equipment
ORDER BY avg_dots DESC;


-- Average DOTS by equipment and sex
SELECT
    r.Equipment,
    l.Sex,
    COUNT(r.Dots) AS dots_count,
    AVG(r.Dots) AS avg_dots
FROM results AS r
JOIN lifters AS l
    ON r.lifter_id = l.lifter_id
WHERE r.Event = 'SBD'
GROUP BY r.Equipment, l.Sex
ORDER BY r.Equipment, avg_dots DESC;


-- Third-attempt success rates by equipment
SELECT
    r.Equipment,

    COUNT(r.Squat3Kg) AS squat_third_attempts,
    AVG(
        CASE
            WHEN r.Squat3Kg > 0 THEN 1
            WHEN r.Squat3Kg < 0 THEN 0
            ELSE NULL
        END
    ) * 100 AS squat_success_pct,

    COUNT(r.Bench3Kg) AS bench_third_attempts,
    AVG(
        CASE
            WHEN r.Bench3Kg > 0 THEN 1
            WHEN r.Bench3Kg < 0 THEN 0
            ELSE NULL
        END
    ) * 100 AS bench_success_pct,

    COUNT(r.Deadlift3Kg) AS deadlift_third_attempts,
    AVG(
        CASE
            WHEN r.Deadlift3Kg > 0 THEN 1
            WHEN r.Deadlift3Kg < 0 THEN 0
            ELSE NULL
        END
    ) * 100 AS deadlift_success_pct

FROM results AS r
WHERE r.Event = 'SBD'
GROUP BY r.Equipment;
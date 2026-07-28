USE powerlifting_analytics;

-- Average SBD total by equipment
WITH equipment_averages AS (
    SELECT
        r.Equipment,
        AVG(r.TotalKg) AS avg_total
    FROM results AS r
    WHERE r.Event = 'SBD'
      AND r.TotalKg IS NOT NULL
    GROUP BY r.Equipment
)
SELECT
    Equipment,
    avg_total
FROM equipment_averages
ORDER BY avg_total DESC;


-- Average DOTS by sex for Raw SBD results
WITH raw_sbd AS (
    SELECT
        r.lifter_id,
        r.Dots
    FROM results AS r
    WHERE r.Equipment = 'Raw'
      AND r.Event = 'SBD'
      AND r.Dots IS NOT NULL
)
SELECT
    l.Sex,
    AVG(raw.Dots) AS avg_dots
FROM raw_sbd AS raw
JOIN lifters AS l
    ON raw.lifter_id = l.lifter_id
GROUP BY l.Sex
ORDER BY avg_dots DESC;


-- Federation summary
WITH federation_summary AS (
    SELECT
        m.Federation,
        COUNT(r.Dots) AS dots_count,
        AVG(r.Dots) AS avg_dots
    FROM results AS r
    JOIN meets AS m
        ON r.meet_id = m.meet_id
    GROUP BY m.Federation
)
SELECT
    Federation,
    dots_count,
    avg_dots
FROM federation_summary
WHERE dots_count > 500
ORDER BY avg_dots DESC;


-- Result counts for sanctioned meets
WITH sanctioned_meets AS (
    SELECT
        m.meet_id,
        m.Federation
    FROM meets AS m
    WHERE REPLACE(m.Sanctioned, '\r', '') = 'Yes'
)
SELECT
    sm.Federation,
    COUNT(*) AS result_count
FROM results AS r
JOIN sanctioned_meets AS sm
    ON r.meet_id = sm.meet_id
GROUP BY sm.Federation
ORDER BY result_count DESC;
USE powerlifting_analytics;

-- Row counts
SELECT COUNT(*) AS lifter_count
FROM lifters;

SELECT COUNT(*) AS meet_count
FROM meets;

SELECT COUNT(*) AS result_count
FROM results;


-- Foreign-key relationship checks
SELECT COUNT(*) AS missing_lifter_links
FROM results AS r
LEFT JOIN lifters AS l
    ON r.lifter_id = l.lifter_id
WHERE l.lifter_id IS NULL;

SELECT COUNT(*) AS missing_meet_links
FROM results AS r
LEFT JOIN meets AS m
    ON r.meet_id = m.meet_id
WHERE m.meet_id IS NULL;


-- Duplicate primary-key checks
SELECT lifter_id, COUNT(*) AS row_count
FROM lifters
GROUP BY lifter_id
HAVING COUNT(*) > 1;

SELECT meet_id, COUNT(*) AS row_count
FROM meets
GROUP BY meet_id
HAVING COUNT(*) > 1;

SELECT result_id, COUNT(*) AS row_count
FROM results
GROUP BY result_id
HAVING COUNT(*) > 1;


-- Missing-value summary
SELECT
    COUNT(*) AS total_rows,
    SUM(Age IS NULL) AS missing_age,
    SUM(BodyweightKg IS NULL) AS missing_bodyweight,
    SUM(Squat1Kg IS NULL) AS missing_squat1,
    SUM(Bench1Kg IS NULL) AS missing_bench1,
    SUM(Deadlift1Kg IS NULL) AS missing_deadlift1,
    SUM(TotalKg IS NULL) AS missing_total,
    SUM(Dots IS NULL) AS missing_dots
FROM results;


-- Check event categories
SELECT
    Event,
    COUNT(*) AS result_count
FROM results
GROUP BY Event
ORDER BY result_count DESC;


-- Check equipment categories
SELECT
    Equipment,
    COUNT(*) AS result_count
FROM results
GROUP BY Equipment
ORDER BY result_count DESC;


-- Check suspicious numeric values
SELECT
    SUM(Age <= 0) AS invalid_age,
    SUM(BodyweightKg <= 0) AS invalid_bodyweight,
    SUM(TotalKg < 0) AS negative_total,
    SUM(Dots < 0) AS negative_dots
FROM results;
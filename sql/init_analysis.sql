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

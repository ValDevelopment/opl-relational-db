USE powerlifting_analytics;

-- Top 10 SBD performances within each equipment type
WITH ranked_lifters AS (
    SELECT
        r.Equipment,
        l.Name,
        r.Dots,
        RANK() OVER (
            PARTITION BY r.Equipment
            ORDER BY r.Dots DESC
        ) AS equipment_rank
    FROM results AS r
    JOIN lifters AS l
        ON r.lifter_id = l.lifter_id
    WHERE r.Event = 'SBD'
      AND r.Dots IS NOT NULL
)
SELECT
    Equipment,
    Name,
    Dots,
    equipment_rank
FROM ranked_lifters
WHERE equipment_rank <= 10
ORDER BY Equipment, equipment_rank;
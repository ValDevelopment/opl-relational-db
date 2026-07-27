USE powerlifting_analytics;

LOAD DATA LOCAL INFILE 'C:/Users/Capta/Documents/GitHub/opl-relational-db/data/processed/lifters.csv'
INTO TABLE lifters
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(lifter_id, Name, Sex, BirthYearClass, Country);

LOAD DATA LOCAL INFILE 'C:/Users/Capta/Documents/GitHub/opl-relational-db/data/processed/meets.csv'
INTO TABLE meets
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    meet_id,
    Date,
    MeetCountry,
    MeetState,
    MeetTown,
    MeetName,
    Federation,
    ParentFederation,
    Tested,
    Sanctioned
);

LOAD DATA LOCAL INFILE
'C:/Users/Capta/Documents/GitHub/opl-relational-db/data/processed/results.csv'
INTO TABLE results
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    result_id,
    Event,
    Equipment,
    @Age,
    AgeClass,
    Division,
    @BodyweightKg,
    WeightClassKg,

    @Squat1Kg,
    @Squat2Kg,
    @Squat3Kg,
    @Best3SquatKg,

    @Bench1Kg,
    @Bench2Kg,
    @Bench3Kg,
    @Best3BenchKg,

    @Deadlift1Kg,
    @Deadlift2Kg,
    @Deadlift3Kg,
    @Best3DeadliftKg,

    @TotalKg,
    Place,
    @Dots,
    lifter_id,
    meet_id
)
SET
    Age = NULLIF(@Age, ''),
    BodyweightKg = NULLIF(@BodyweightKg, ''),

    Squat1Kg = NULLIF(@Squat1Kg, ''),
    Squat2Kg = NULLIF(@Squat2Kg, ''),
    Squat3Kg = NULLIF(@Squat3Kg, ''),
    Best3SquatKg = NULLIF(@Best3SquatKg, ''),

    Bench1Kg = NULLIF(@Bench1Kg, ''),
    Bench2Kg = NULLIF(@Bench2Kg, ''),
    Bench3Kg = NULLIF(@Bench3Kg, ''),
    Best3BenchKg = NULLIF(@Best3BenchKg, ''),

    Deadlift1Kg = NULLIF(@Deadlift1Kg, ''),
    Deadlift2Kg = NULLIF(@Deadlift2Kg, ''),
    Deadlift3Kg = NULLIF(@Deadlift3Kg, ''),
    Best3DeadliftKg = NULLIF(@Best3DeadliftKg, ''),

    TotalKg = NULLIF(@TotalKg, ''),
    Dots = NULLIF(@Dots, '');

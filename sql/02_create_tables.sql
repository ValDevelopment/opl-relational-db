USE powerlifting_analytics;


CREATE TABLE lifters (
    lifter_id INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Sex VARCHAR(10),
    BirthYearClass VARCHAR(20),
    Country VARCHAR(100)
);


CREATE TABLE meets (
    meet_id INT PRIMARY KEY,
    Date DATE,
    MeetCountry VARCHAR(100),
    MeetState VARCHAR(100),
    MeetTown VARCHAR(150),
    MeetName VARCHAR(255),
    Federation VARCHAR(100),
    ParentFederation VARCHAR(100),
    Tested VARCHAR(10),
    Sanctioned VARCHAR(10)
);


CREATE TABLE results (
    result_id INT PRIMARY KEY,
    Event VARCHAR(10),
    Equipment VARCHAR(50),
    Age DECIMAL(5,2),
    AgeClass VARCHAR(20),
    Division VARCHAR(150),
    BodyweightKg DECIMAL(7,2),
    WeightClassKg VARCHAR(20),

    Squat1Kg DECIMAL(7,2),
    Squat2Kg DECIMAL(7,2),
    Squat3Kg DECIMAL(7,2),
    Best3SquatKg DECIMAL(7,2),

    Bench1Kg DECIMAL(7,2),
    Bench2Kg DECIMAL(7,2),
    Bench3Kg DECIMAL(7,2),
    Best3BenchKg DECIMAL(7,2),

    Deadlift1Kg DECIMAL(7,2),
    Deadlift2Kg DECIMAL(7,2),
    Deadlift3Kg DECIMAL(7,2),
    Best3DeadliftKg DECIMAL(7,2),

    TotalKg DECIMAL(8,2),
    Place VARCHAR(20),
    Dots DECIMAL(8,3),

    lifter_id INT NOT NULL,
    meet_id INT NOT NULL,

    CONSTRAINT fk_results_lifter
        FOREIGN KEY (lifter_id)
        REFERENCES lifters(lifter_id),

    CONSTRAINT fk_results_meet
        FOREIGN KEY (meet_id)
        REFERENCES meets(meet_id)
);


USE powerlifting_analytics;

SHOW TABLES;

DESCRIBE results;
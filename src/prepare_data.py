from pathlib import Path

import pandas as pd


RAW_PATH = Path("data/raw/openpowerlifting.csv")
PROCESSED_DIR = Path("data/processed")
SAMPLE_ROWS = 100_000

SELECTED_COLUMNS = [
    "Name",
    "Sex",
    "Event",
    "Equipment",
    "Age",
    "AgeClass",
    "BirthYearClass",
    "Division",
    "BodyweightKg",
    "WeightClassKg",
    "Squat1Kg",
    "Squat2Kg",
    "Squat3Kg",
    "Best3SquatKg",
    "Bench1Kg",
    "Bench2Kg",
    "Bench3Kg",
    "Best3BenchKg",
    "Deadlift1Kg",
    "Deadlift2Kg",
    "Deadlift3Kg",
    "Best3DeadliftKg",
    "TotalKg",
    "Place",
    "Dots",
    "Tested",
    "Country",
    "Federation",
    "ParentFederation",
    "Date",
    "MeetCountry",
    "MeetState",
    "MeetTown",
    "MeetName",
    "Sanctioned",
]

NUMERIC_COLUMNS = [
    "Age",
    "BodyweightKg",
    "Squat1Kg",
    "Squat2Kg",
    "Squat3Kg",
    "Best3SquatKg",
    "Bench1Kg",
    "Bench2Kg",
    "Bench3Kg",
    "Best3BenchKg",
    "Deadlift1Kg",
    "Deadlift2Kg",
    "Deadlift3Kg",
    "Best3DeadliftKg",
    "TotalKg",
    "Dots",
]


def load_data() -> pd.DataFrame:
    return pd.read_csv(
        RAW_PATH,
        nrows=SAMPLE_ROWS,
        usecols=SELECTED_COLUMNS,
        low_memory=False,
    )


def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()

    df["Date"] = pd.to_datetime(df["Date"], errors="coerce")

    for column in NUMERIC_COLUMNS:
        df[column] = pd.to_numeric(df[column], errors="coerce")

    return df


def build_lifters(df: pd.DataFrame) -> pd.DataFrame:
    lifters = (
        df[["Name", "Sex", "BirthYearClass", "Country"]]
        .drop_duplicates()
        .reset_index(drop=True)
    )

    lifters.insert(0, "lifter_id", range(1, len(lifters) + 1))
    return lifters


def build_meets(df: pd.DataFrame) -> pd.DataFrame:
    meet_columns = [
        "Date",
        "MeetCountry",
        "MeetState",
        "MeetTown",
        "MeetName",
        "Federation",
        "ParentFederation",
        "Tested",
        "Sanctioned",
    ]

    meets = (
        df[meet_columns]
        .drop_duplicates()
        .reset_index(drop=True)
    )

    meets.insert(0, "meet_id", range(1, len(meets) + 1))
    return meets



def build_results(
    df: pd.DataFrame,
    lifters: pd.DataFrame,
    meets: pd.DataFrame,
) -> pd.DataFrame:
    lifter_keys = ["Name", "Sex", "BirthYearClass", "Country"]

    meet_keys = [
        "Date",
        "MeetCountry",
        "MeetState",
        "MeetTown",
        "MeetName",
        "Federation",
        "ParentFederation",
        "Tested",
        "Sanctioned",
    ]

    results = df.merge(
        lifters[lifter_keys + ["lifter_id"]],
        on=lifter_keys,
        how="left",
        validate="many_to_one",
    )

    results = results.merge(
        meets[meet_keys + ["meet_id"]],
        on=meet_keys,
        how="left",
        validate="many_to_one",
    )

    results = results.drop(columns=lifter_keys + meet_keys)
    results.insert(0, "result_id", range(1, len(results) + 1))

    return results





def main() -> None:
    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

    df = load_data()
    df = clean_data(df)

    lifters = build_lifters(df)
    meets = build_meets(df)
    results = build_results(df, lifters, meets)

    assert lifters["lifter_id"].is_unique
    assert meets["meet_id"].is_unique
    assert results["result_id"].is_unique
    assert results["lifter_id"].notna().all()
    assert results["meet_id"].notna().all()

    lifters.to_csv(PROCESSED_DIR / "lifters.csv", index=False)
    meets.to_csv(PROCESSED_DIR / "meets.csv", index=False)
    results.to_csv(PROCESSED_DIR / "results.csv", index=False)

    print(f"Lifters: {len(lifters):,}")
    print(f"Meets: {len(meets):,}")
    print(f"Results: {len(results):,}")


if __name__ == "__main__":
    main()


    
# FIFA Player Data Analysis (SQL)

## Overview
Analysis of a Kaggle FIFA player dataset (~17,900 players) using SQLite, 
exploring player value, ratings, nationality trends, and career-age patterns.

## Key Findings

- **Portugal and Brazil lead in average player rating** (71.1) among nations 
  with 20+ players, but Portugal achieves this with less than half of Brazil's 
  player count (335 vs. 832) — suggesting more concentrated quality per player.

- **England produces the most elite-rated (85+) players** by a wide margin 
  (1,658), ahead of Germany (1,199) and Spain (1,070) — though this may partly 
  reflect Premier League visibility bias in how players are rated.

- **Player value and wage are stored as TEXT in the source data**, causing 
  incorrect lexicographic sorting (e.g., "975000" ranking above "9500000"). 
  Identified this via `typeof()` inspection and resolved it by explicitly 
  casting to REAL in all numeric comparisons — a reminder to validate column 
  types before trusting sort/rank behavior on any imported CSV data.

- **After correcting for the type bug**, several young Portuguese players 
  (Gedson Fernandes, João Félix) show the largest gap between market value 
  rank and wage rank — consistent with clubs paying transfer premiums for 
  potential before wages catch up.

- **Player ratings peak in the 26-30 age bracket** (69.0 avg), following a 
  rise from Under-21 (59.0) and a slight decline at 31+ (69.5 vs. peak), 
  matching known career trajectories in professional football.

## Tools
SQLite (via VSCode), window functions (RANK), CTEs, CASE-based bucketing, 
type casting for data cleaning.

## Files
- `analysis.sql` — all queries with comments
- `fifa_players.csv` — source dataset (Kaggle)
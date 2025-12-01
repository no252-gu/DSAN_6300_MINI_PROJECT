# The Hidden Patterns of Flight Delays

A data-driven investigation into U.S. airline performance using April 2019 flight data from the U.S. Department of Transportation.

## Project Overview

This Quarto website presents a comprehensive analysis of airline on-time performance, examining:
- Flight volume patterns and trends
- Airline delay extremes
- Airport performance bottlenecks
- Cancellation causes and patterns

**Live Website**: [URL will be added after GitHub Pages deployment]

## Key Findings

- **System Volume**: Monday peaks at 106,575 flights; clear weekday/weekend pattern
- **Delays**: Maximum delay of 2,620 minutes (43+ hours) recorded
- **Airports**: Southwest Oregon Regional averages 47-minute delays
- **Cancellations**: 14,488 flights cancelled; weather is the dominant cause

## Project Structure

```
DSAN_6300_MINI_PROJECT/
├── index.qmd              # Homepage
├── analysis.qmd           # Full analysis with visualizations
├── about.qmd              # Project details and methodology
├── _quarto.yml            # Quarto configuration
├── styles.css             # Custom CSS styling
├── SQL_exports/           # CSV files from SQL queries
└── README.md              
```

## Technologies

- **AWS**: Database Host
- **MySQLWorkbench**: For data querying
- **R**: Data analysis and visualization (tidyverse, ggplot2)

The rendered site will be in the `_site/` directory.

## Data Source

**Dataset**: Airline On-Time Performance and Causes of Delay
**Source**: U.S. Department of Transportation, Bureau of Transportation Statistics
**Period**: April 2019
**Source**: https://www.transtats.bts.gov/

## Author

**Nkemdibe Okweye**
Georgetown University - DSAN 6300
Fall 2025



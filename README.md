# NHS RTT Waiting List Analysis

I built this project to look at how the NHS waiting list changed over 12 months, from April 2025 to March 2026.

## Why I built it

I spent a year working in Radiology at Epsom and St Helier NHS Trust. I used to check RTT pathways every day for patients I was booking. This project takes that same idea and looks at it at a national scale across all NHS trusts and specialties.

## What RTT means

Referral to Treatment (RTT) measures how long patients wait from a GP referral to the start of hospital treatment. The NHS standard is that 92% of patients on incomplete pathways should be waiting less than 18 weeks. The current figure sits around 65%.

## What I found

- The waiting list dropped from 7.42 million to 7.05 million.
- 18-week compliance went up from 59.7% to 65.2%.
- Patients waiting over 52 weeks halved, from 192,560 to 95,824.
- Oral Surgery and Plastic Surgery had the worst compliance.
- Trauma and Orthopaedics had the biggest waiting list.
- Mid and South Essex NHS Foundation Trust had the most 52-week breaches.

My numbers match what NHS England publishes each month.

## How I did it

1. **Collected the data.** I downloaded 12 monthly RTT files from NHS England, April 2025 to March 2026.
2. **Cleaned it in Python.** I wrote a function that unzips each monthly file, cleans it and combines the months into around 49,000 analysis-ready rows. This saved repeating the same steps twelve times by hand.
3. **Analysed it in SQL.** I used joins, GROUP BY and aggregations to build the England-wide monthly trend, 18-week compliance by specialty and 52-week breaches by trust. I filtered to incomplete pathways, which is how NHS England reports the waiting list.
4. **Built the dashboard in Power BI.** It has KPI cards for the headline numbers, trend charts and breakdowns by specialty and trust.
5. **Checked my numbers.** I compared my totals with NHS England's published monthly figures, and they match.

## How to run it

1. Run the notebook in `Notebooks/` to clean the raw files.
2. Run the queries in `nhs_rtt_queries.sql` on the cleaned data.
3. Open the `.pbix` file in `PowerBI/` to explore the dashboard.

## Tools I used

- Python (for cleaning the data)
- SQL (for the analysis)
- Power BI (for the dashboard)

## Data source

NHS England publishes RTT data every month. I downloaded 12 months of it from their website.

## About me

I'm Keerthana Krishna. I have an MSc in Data Science and Analytics from Cardiff University and a year of NHS experience. I'm looking for data analyst roles in the UK.

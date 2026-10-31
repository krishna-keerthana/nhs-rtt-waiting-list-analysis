-- NHS RTT Waiting List Analysis
-- SQL queries supporting the Power BI dashboard
-- Author: Keerthana Krishna
-- Date: October 2026
-- Source: NHS England Monthly RTT Statistics, April 2025 to March 2026


-- =====================================================
-- Q1: England-wide monthly waiting list trend
-- Powers the headline trend line on the dashboard
-- =====================================================
SELECT
    month,
    SUM(total_waiting) AS england_total,
    SUM(waiting_within_18wks) AS within_18wks,
    SUM(waiting_over_52wks) AS over_52wks
FROM rtt_specialty
GROUP BY month
ORDER BY month;


-- =====================================================
-- Q2: Specialty-level 18-week compliance, March 2026
-- Which specialties are missing the 18-week target?
-- =====================================================
SELECT
    "Treatment Function Name" AS specialty,
    SUM(total_waiting) AS total_waiting,
    SUM(waiting_within_18wks) AS within_18wks,
    ROUND(SUM(waiting_within_18wks) * 100.0 / SUM(total_waiting), 1) AS pct_within_18wks
FROM rtt_specialty
WHERE month = '2026-03'
GROUP BY "Treatment Function Name"
ORDER BY pct_within_18wks ASC;


-- =====================================================
-- Q3: Top 20 trusts by 52-week breach count, March 2026
-- Which trusts have the most patients waiting over a year?
-- =====================================================
SELECT
    "Provider Org Name" AS trust,
    SUM(waiting_over_52wks) AS over_52wks
FROM rtt_trust
WHERE month = '2026-03'
GROUP BY "Provider Org Name"
ORDER BY over_52wks DESC
LIMIT 20;


-- =====================================================
-- Q4: Reconciliation check against NHS England published figures
-- Confirms the pipeline matches the official statistics
-- =====================================================
SELECT
    SUM(total_waiting) AS my_total,
    7045510 AS nhs_england_published,
    SUM(total_waiting) - 7045510 AS difference
FROM rtt_specialty
WHERE month = '2026-03';


-- =====================================================
-- Q5: April 2025 vs March 2026 by specialty - change in waiting list
-- Uses a JOIN to compare two time points side by side
-- =====================================================
SELECT
    apr."Treatment Function Name" AS specialty,
    SUM(apr.total_waiting) AS total_apr25,
    SUM(mar.total_waiting) AS total_mar26,
    SUM(mar.total_waiting) - SUM(apr.total_waiting) AS change_in_waiting
FROM rtt_specialty apr
JOIN rtt_specialty mar
    ON apr."Treatment Function Name" = mar."Treatment Function Name"
WHERE apr.month = '2025-04' AND mar.month = '2026-03'
GROUP BY apr."Treatment Function Name"
ORDER BY change_in_waiting ASC;


-- =====================================================
-- Q6: Specialties with the worst 52-week breach RATE, March 2026
-- Rate (not count) tells you where the risk is proportionally highest
-- =====================================================
SELECT
    "Treatment Function Name" AS specialty,
    SUM(waiting_over_52wks) AS over_52wks,
    SUM(total_waiting) AS total_waiting,
    ROUND(SUM(waiting_over_52wks) * 100.0 / SUM(total_waiting), 2) AS pct_over_52wks
FROM rtt_specialty
WHERE month = '2026-03'
GROUP BY "Treatment Function Name"
ORDER BY pct_over_52wks DESC
LIMIT 10;


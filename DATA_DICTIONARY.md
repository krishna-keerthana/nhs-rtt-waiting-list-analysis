# Data dictionary

This file explains every table and field in the project: where it comes from, what it means and how I calculated it.

## Source data

| Item | Detail |
|---|---|
| Publisher | NHS England, Consultant-led Referral to Treatment (RTT) Waiting Times statistics |
| Files used | 12 monthly full extract CSV files (zipped), April 2025 to March 2026 |
| Size | About 184,000 rows and 121 columns per month, about 2.2 million rows in total |
| Part of the data used | Incomplete pathways only (`RTT Part Type` = `Part_2`). These are patients still waiting at the end of the month, which is how NHS England reports the waiting list. |
| Parts not used | New RTT periods (Part_3), completed admitted (Part_1A), completed non-admitted (Part_1B) and incomplete pathways with a decision to admit (Part_2A) |

## Tables

| Table | Where | Rows | One row is |
|---|---|---|---|
| `rtt_2026_03_clean.csv` | `Data/clean/` | 63,833 | One provider, commissioner and treatment function in March 2026, before grouping. A worked example of the cleaning steps for one month. |
| `rtt_specialty` | `Data/clean/rtt.db`, `Outputs/rtt_by_specialty.csv` | 43,248 | One month, provider and treatment function (specialty), summed across commissioners. Excludes the `C_999` total rows. |
| `rtt_trust` | `Data/clean/rtt.db`, `Outputs/rtt_by_trust.csv` | 5,874 | One month and provider, all specialties combined (`C_999` rows only). |
| `rtt_specialty_trend` | `Outputs/rtt_specialty_trend.csv` | 276 | One month and treatment function for England (12 months x 23 specialties). |

## Fields

| Field | Type | Source | Definition and calculation |
|---|---|---|---|
| `month` | Text (YYYY-MM) | Derived | Taken from the zip file name, for example `rtt_2026_03.zip` becomes `2026-03`. The month the waiting list snapshot refers to (end of month). |
| `Provider Org Code` | Text | Raw | ODS code of the organisation treating the patient, for example `RTK`. |
| `Provider Org Name` | Text | Raw | Name of the provider. Includes NHS trusts and independent sector providers. |
| `Treatment Function Code` | Text | Raw | The specialty code. `C_100` to `C_502` are named specialties, `X02` to `X06` are the "Other" groups, and `C_999` is the total for all specialties. |
| `Treatment Function Name` | Text | Raw | The specialty name, for example `Trauma and Orthopaedic Service`. 23 specialties plus `Total`. |
| `total_waiting` | Number | Calculated | Sum of every weekly wait band column, from `Gt 00 To 01 Weeks SUM 1` to `Gt 104 Weeks SUM 1`. I calculated this myself because the raw `Total` column was empty for many incomplete pathway rows. Excludes patients with an unknown clock start date, which NHS England reports separately. |
| `waiting_within_18wks` | Number | Calculated | Sum of the wait bands from 0 up to 18 weeks (`Gt 00 To 01` to `Gt 17 To 18`). The 18-week standard. |
| `waiting_over_52wks` | Number | Calculated | Sum of the wait bands over 52 weeks (`Gt 52 To 53` to `Gt 104 Weeks`). Long waiters. |
| `pct_within_18wks` | Number (%) | Calculated | `waiting_within_18wks / total_waiting x 100`, rounded to 1 decimal place. The NHS standard is 92%. For any group (England, specialty, trust) I recalculate it from the summed counts, never by averaging percentages. |

## Specialty codes

| Code | Specialty | Code | Specialty |
|---|---|---|---|
| C_100 | General Surgery | C_330 | Dermatology |
| C_101 | Urology | C_340 | Respiratory Medicine |
| C_110 | Trauma and Orthopaedics | C_400 | Neurology |
| C_120 | Ear Nose and Throat | C_410 | Rheumatology |
| C_130 | Ophthalmology | C_430 | Elderly Medicine |
| C_140 | Oral Surgery | C_502 | Gynaecology |
| C_150 | Neurosurgery | X02 | Other - Medical |
| C_160 | Plastic Surgery | X03 | Other - Mental Health |
| C_170 | Cardiothoracic Surgery | X04 | Other - Paediatric |
| C_300 | General Internal Medicine | X05 | Other - Surgical |
| C_301 | Gastroenterology | X06 | Other - Other |
| C_320 | Cardiology | C_999 | Total (all specialties) |

## Assumptions and limitations

- **No estimates for missing trusts.** My figures use the data trusts submitted. NHS England's headline figure adds estimates for trusts that did not submit that month, so it is slightly higher than mine (for example, about 7.11 million in March 2026 against my 7.05 million).
- **Snapshot, not flow.** Incomplete pathways show who is waiting at the end of each month. They do not show how many people started or finished treatment.
- **Unknown clock starts excluded.** Patients with an unknown clock start date are not in any wait band, so they are not in my totals.
- **Not every trust reports every month.** Sheffield Teaching Hospitals (about 92,000 patients) has no data from July 2025 to March 2026, and Barking, Havering and Redbridge (about 70,000 patients) is missing for November 2025. This explains part of the fall in the national total and the dip in November 2025. Comparing only providers that reported in both April 2025 and March 2026, the waiting list fell from 7.32 million to 7.03 million (about 4%) rather than 7.42 million to 7.05 million (about 5%). The 18-week figure is almost the same either way (59.6% to 65.2%).
- **Providers change.** The number of providers reporting also varies as small independent providers start or stop reporting (469 in April 2025, 532 in March 2026).
- **Published data can be revised.** I used the files available when I downloaded them (the March 2026 file is the revised version).

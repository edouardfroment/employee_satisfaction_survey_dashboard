# Technical Documentation: HR Employee Satisfaction Survey Database

## 1. Data Architecture Overview
This database follows a **Star Schema** design. It is built to analyze employee feedback from annual surveys while tracking historical changes in employee status (department, country, seniority) using a **Slowly Changing Dimension (SCD Type 2)** approach.

### The Importance of SCD Type 2 Logic
The database uses an SCD Type 2 approach via the `dim_employee_situation` table. This allows us to maintain a history of an employee's profile and ensures that survey results are linked to the *correct context* at the time of the response.

---

## 2. Table Definitions & Data Dictionary

### 2.1. `FACT_survey_response`
This central fact table stores the results of the employee satisfaction surveys. Each row represents an individual response.

| Column | Description |
| :--- | :--- |
| **survey_response_id** | Primary Key. Unique identifier for each survey entry. |
| **employee_scd_id** | Foreign Key. Links to `dim_employee_situation` to capture the employee's profile at the time of the survey. |
| **year** | The calendar year the survey was conducted. |
| **recommendation_rating** | Numeric score (0–10) given by the employee. |
| **comment** | Open-ended feedback provided by the employee. |
| **has_comment** | True or False (text). Indicates if the employee left a text comment. |
| **enps_category** | Employee Net Promoter Score category (*promoter, passive, detractor*). |
| **topics_positive** | Categorized positive themes mentioned in the comments. |
| **topics_negative** | Categorized negative themes mentioned in the comments. |
| **sentiment** | Result of sentiment analysis. Values: `positive`, `negative`, or `mixed`. |

### 2.2. `dim_employee_situation`
This dimension table tracks the historical "snapshots" of an employee's professional situation. A new record is generated for each employee for every survey cycle or status change.

| Column | Description |
| :--- | :--- |
| **employee_scd_id** | Primary Key. Unique identifier for a specific version of an employee's status. |
| **employee_id** | Foreign Key. Unique identifier for the individual employee (consistent over time). |
| **year** | The year the situation record was created. |
| **status** | Management level (*Manager* or *Non-manager*). |
| **country** | Geographic location of the employee. |
| **department** | Business unit or department. |
| **date_situation** | The reference date for this snapshot (e.g., 2023-12-15). |
| **seniority_group** | Categorization of seniority (e.g., *1-2 years*, *15+ years*) based on hire date. |

### 2.3. `dim_employee`
The master table for employee identification. To ensure data privacy (GDPR), this table contains only the unique identifier.

| Column | Description |
| :--- | :--- |
| **employee_id** | Primary Key. Unique identifier for each employee. |

### 2.4. `dim_date`
A standard calendar table for time-based filtering and trend analysis.

| Column | Description |
| :--- | :--- |
| **date** | The full date (Primary Key). |
| **year / month / day** | Temporal attributes for granular reporting. |

---

## 3. Core Logic Summary
* **SCD Mapping:** `dim_employee` (1) → `dim_employee_situation` (N) → `FACT_survey_response` (1).

* **Sentiment Analysis:** The `mixed` value in the `sentiment` column identifies feedback where employees express both positive and negative sentiments simultaneously.



-- Question 2: Calculate the average number of transactions per customer per month and categorize them:
-- "High Frequency" (≥10 transactions/month)
-- "Medium Frequency" (3-9 transactions/month)
-- "Low Frequency" (≤2 transactions/month)

-- STEP 1: For each customer, I counted the total number of transactions they made 
-- and how many months they’ve been active based on their first and last transaction date.

WITH transaction_counts AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,

        -- I Calculated the number of months between first and last transaction
        -- E.g: If a user first transacted in Jan 2023 and last in Mar 2023, that's 3 months
        PERIOD_DIFF(
            DATE_FORMAT(MAX(s.transaction_date), '%Y%m'),  -- Latest transaction month
            DATE_FORMAT(MIN(s.transaction_date), '%Y%m')   -- Earliest transaction month
        ) + 1 AS active_months
    FROM 
        savings_savingsaccount s
    WHERE 
        s.confirmed_amount > 0  
        AND s.transaction_date IS NOT NULL
    GROUP BY 
        s.owner_id
),

-- STEP 2: For each customer, I calculated their average transactions per month.
-- Then, assign them a frequency category: High, Medium, or Low.

frequency_classification AS (
    SELECT 
        owner_id,
        total_transactions,
        active_months,
        ROUND(total_transactions / active_months, 2) AS avg_transactions_per_month,

        -- Assigning category based on average transactions/month
        CASE 
            WHEN (total_transactions / active_months) >= 10 THEN 'High Frequency'
            WHEN (total_transactions / active_months) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        transaction_counts
)

-- STEP 3: Grouped by frequency category and show:
-- - To show how many customers fall into each group
-- - and the average number of transactions per month for that group

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM 
    frequency_classification
GROUP BY 
    frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');

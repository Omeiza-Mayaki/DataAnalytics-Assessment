-- Creating a CTE to get monthly transaction counts per user
WITH monthly_transactions AS (
    SELECT 
        owner_id,
        EXTRACT(YEAR FROM created_on) AS year,
        EXTRACT(MONTH FROM created_on) AS month,
        COUNT(*) AS transactions_in_month
    FROM savings_savingsaccount
    GROUP BY owner_id, year, month
),

-- Creating a CTE to Calculate average transactions per user across all active months
user_monthly_avg AS (
    SELECT 
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),

-- Creating a CTE that Categorize users based on their transaction frequency
categorized_users AS (
    SELECT 
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM user_monthly_avg
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;
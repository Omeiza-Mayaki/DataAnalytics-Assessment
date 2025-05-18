-- Creating a CTE to get the latest transaction per account
WITH latest_transactions AS (
    SELECT 
        s.owner_id,
        s.plan_id,
        MAX(s.created_on) AS last_transaction_date
    FROM savings_savingsaccount AS s
    WHERE s.confirmed_amount > 0
		AND s.confirmed_amount IS NOT NULL
    GROUP BY s.owner_id, s.plan_id
),

-- Joining with plans table to get account type and calculate inactivity
inactivity_accounts AS (
    SELECT 
        l.plan_id,
        l.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Error'
        END AS type,
        l.last_transaction_date,
        -- Calculating the difference between the current date and the last transaction date
        DATEDIFF(CURRENT_DATE(), l.last_transaction_date) AS inactivity_days
    FROM latest_transactions AS l
    JOIN plans_plan AS p 
		ON l.plan_id = p.id
)

SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM inactivity_accounts
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;

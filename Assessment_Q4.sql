WITH transaction_stats AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) AS total_transaction_value
    FROM savings_savingsaccount AS s
    WHERE s.confirmed_amount > 0
		AND s.confirmed_amount
    GROUP BY s.owner_id
),

customer_tenure AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months
    FROM users_customuser AS u
)

SELECT 
    c.customer_id,
    c.name,
    c.tenure_months,
    t.total_transactions,
    ROUND(
        (t.total_transactions / NULLIF(c.tenure_months, 0)) * 12 * 
        (t.total_transaction_value / t.total_transactions * 0.001),
        2
    ) AS estimated_clv
FROM customer_tenure AS c
JOIN transaction_stats AS t 
	ON c.customer_id = t.owner_id
ORDER BY estimated_clv DESC;
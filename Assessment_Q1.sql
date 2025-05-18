-- Creating a CTE for savings accounts that are funded to get savings count and total savings deposit
WITH savings AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS savings_count,
		-- To get the total savings deposit;
        SUM(s.confirmed_amount) AS total_savings_deposit
    FROM savings_savingsaccount AS s
    JOIN plans_plan AS p 
		ON s.plan_id = p.id
		-- To filter out only rows with a regular savings plan;
    WHERE p.is_regular_savings = 1
    GROUP BY s.owner_id
),

-- Creating a CTE for investment accounts that are funded to get investment count and total investment deposit
investment AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS investment_count,
        -- To get the total investment deposit;
        SUM(s.confirmed_amount) AS total_investment_deposit
    FROM savings_savingsaccount AS s
    JOIN plans_plan AS p 
		ON s.plan_id = p.id
    WHERE p.is_a_fund = 1
    GROUP BY s.owner_id
)

SELECT 
    u.id AS owner_id,
    -- To get user's full name by combining the first name and the last name in the users_customer table;
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    s.savings_count,
    i.investment_count,
    (s.total_savings_deposit + i.total_investment_deposit) AS total_deposits
FROM savings  AS s
JOIN investment AS i 
	ON s.owner_id = i.owner_id
JOIN users_customuser AS u 
	ON u.id = s.owner_id
ORDER BY total_deposits DESC;
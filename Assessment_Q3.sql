-- Question 3: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)

SELECT 
    p.id AS plan_id,
    p.owner_id,
    
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    
    MAX(s.transaction_date) AS last_transaction_date,
    
    DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) AS inactivity_days

FROM 
    plans_plan p
JOIN 
    savings_savingsaccount s ON s.plan_id = p.id

WHERE 
    s.confirmed_amount > 0 

GROUP BY 
    p.id, p.owner_id, p.is_regular_savings, p.is_a_fund

HAVING 
    MAX(s.transaction_date) < DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)
    
ORDER BY 
    inactivity_days DESC;

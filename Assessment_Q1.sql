-- Question 1: Write a query to find customers with at least one funded savings plan AND 
-- one funded investment plan, sorted by total deposits

SELECT 
    u.id AS owner_id,
    -- I Concatenated first_name and last_name 
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- I Counted the funded savings plans for the customer
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    
    -- I Counted the funded investment plans for the customer
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    
    -- Total deposits (sum of confirmed_amount) for the customer, converted from Kobo to Naira
    COALESCE(SUM(s.confirmed_amount), 0) / 100 AS total_deposits
FROM 
    users_customuser u
    JOIN plans_plan p ON p.owner_id = u.id
    JOIN savings_savingsaccount s ON s.plan_id = p.id
WHERE 
    s.confirmed_amount > 0 
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    savings_count >= 1
    AND investment_count >= 1
ORDER BY 
    total_deposits DESC;

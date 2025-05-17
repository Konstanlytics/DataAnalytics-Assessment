-- Question 4:  For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
-- Account tenure (months since signup)
-- Total transactions
-- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
-- Order by estimated CLV from highest to lowest

SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- I calculated how many months the customer has been with us,
    -- starting from when they signed up until today.
    TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE()) AS tenure_months,

    -- I counted how many real (confirmed) transactions the customer has made.
    COUNT(s.id) AS total_transactions,

    -- I added up all the confirmed transaction amounts and converted from kobo to naira.
    COALESCE(SUM(s.confirmed_amount), 0) / 100 AS total_transaction_value,

    -- I estimated how much profit we earn on average per transaction,
    -- assuming we make 0.1% of each transaction amount.
    CASE 
        WHEN COUNT(s.id) > 0 THEN 
            (COALESCE(SUM(s.confirmed_amount), 0) / 100) * 0.001
        ELSE 0
    END AS avg_profit_per_transaction,



    -- I estimated the Customer Lifetime Value (CLV) using this logic:
    -- I figured out how many transactions the customer does per month,
    -- then projected that over a year (×12), and multiplied it by the profit we make per transaction.
    CASE 
        WHEN TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE()) > 0 THEN
            (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE())) * 12 *
            ((COALESCE(SUM(s.confirmed_amount), 0) / 100) * 0.001 / COUNT(s.id))
        ELSE 0
    END AS estimated_clv

FROM 
    users_customuser u
LEFT JOIN 
    savings_savingsaccount s ON s.owner_id = u.id AND s.confirmed_amount > 0

GROUP BY 
    u.id, u.first_name, u.last_name, u.created_on

ORDER BY 
    estimated_clv DESC;


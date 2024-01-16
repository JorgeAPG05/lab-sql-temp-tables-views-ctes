USE sakila;

CREATE VIEW rental_summary AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, COUNT(r.rental_id) 
AS rental_count FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name, c.email;

CREATE TEMPORARY TABLE payment_summary AS
SELECT rs.customer_id, SUM(p.amount) AS total_paid FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;

SELECT * FROM payment_summary;

WITH CustomerSummaryCTE AS (
    SELECT rs.customer_id, rs.customer_name, rs.email, rs.rental_count, ps.total_paid,ps.total_paid / rs.rental_count 
    AS average_payment_per_rental FROM rental_summary rs
	JOIN payment_summary ps ON rs.customer_id = ps.customer_id)
SELECT customer_name, email, rental_count, total_paid, average_payment_per_rental FROM CustomerSummaryCTE;
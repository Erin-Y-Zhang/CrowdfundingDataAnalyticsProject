CREATE TABLE summary (name VARCHAR(100), category VARCHAR(20), subcategory VARCHAR(20),
country VARCHAR(20), currency VARCHAR(20), deadline datetime,launched datetime,
length INT, goal FLOAT, pledged FLOAT, backers FLOAT, outcome VARCHAR(20)); 

INSERT INTO summary
SELECT campaign.name, category.name as category, sub_category.name AS subcategory, 
country.name AS country, currency.name AS currency, deadline, launched,
DATEDIFF(deadline,launched) AS length, 
goal, pledged, backers, outcome  
FROM campaign 
LEFT JOIN sub_category
ON campaign.sub_category_id=sub_category.id
left join category
on sub_category.category_id=category.id
LEFT JOIN country
ON campaign.country_id=country.id
LEFT JOIN currency
ON campaign.currency_id = currency.id;

SELECT * FROM summary;
DELETE FROM summary
WHERE outcome= 'undefined';

SELECT DISTINCT country, currency, sum(pledged) as total_pledged, AVG(pledged) as avg_pledged
from summary
group by country, currency;    #most of the money are raised in the US, hence let's focus on campaigns in USD

SELECT outcome, AVG(goal) AS avg_goal, AVG(pledged) AS avg_pledged, AVG(length) AS avg_length 
from summary
where currency='USD'
group by outcome; ##answer to question 1

SELECT distinct category, COUNT(backers), AVG(length) as avg_length, AVG(pledged) as avg_pledged
FROM summary
where currency="USD"
GROUP BY category
ORDER BY COUNT(backers) DESC;

SELECT * from summary
where currency="USD" and subcategory in ("Tabletop Games", "Playing Cards") and outcome="successful";

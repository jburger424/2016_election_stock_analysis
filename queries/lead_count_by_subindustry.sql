select sub_industry, lead, count(lead) as winning_counties
from
(
select distinct
sub_industry,symbol, cities.county, cities.state, lead
FROM
s_and_p
JOIN
cities
ON(s_and_p.city = cities.city and s_and_p.state = cities.state)
JOIN
pres_results
ON(cities.county = pres_results.county)
where pres_results.cand = pres_results.lead
GROUP BY symbol,s_and_p.city,s_and_p.state)
GROUP BY sub_industry, lead;
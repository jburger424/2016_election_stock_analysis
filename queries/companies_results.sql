SELECT companies.company_name, ROUND(companies.slope_diff,4) AS slope_diff, companies.city, cities.county, cities.state, results_clean.pct_lead, results_clean.winner, companies.sector, companies.sub_industry
FROM
companies
JOIN
cities
ON(companies.city = cities.city and companies.state = cities.state)
JOIN
results_clean
ON(cities.county = results_clean.county)
GROUP BY companies.symbol, companies.city, companies.state
ORDER BY winner,pct_lead
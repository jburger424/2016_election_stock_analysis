CREATE TABLE
results_clean
AS
SELECT
	county, 
	fips,
	st,
	trump_pct, 
	clinton_pct, 
	(ROUND(ABS(trump_pct - clinton_pct),4)) as pct_lead, 
	substr(lead, instr(lead, ' ') + 1) as "winner"
FROM(
SELECT 
	pres_results.county, 
	pres_results.fips,
	pres_results.st,
	ROUND(MAX(CASE WHEN pres_results.cand="Donald Trump" THEN pres_results.pct END),4) as "trump_pct",
	ROUND(MAX(CASE WHEN pres_results.cand="Hillary Clinton" THEN pres_results.pct END),4) as "clinton_pct",
	lead
FROM pres_results
GROUP BY fips)
ORDER BY fips DESC;
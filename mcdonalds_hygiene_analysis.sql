select *
from mcdonalds_clean;

#1. County Hygiene Leaderboard
#counties by average Hygiene score

select County,
	   avg_hygiene,
       rank() over (order by avg_hygiene desc ) as ranked
from(
select  County, avg(Hygiene) as avg_hygiene
from mcdonalds_clean
group by County) as t;



#2 — RiskScore and the  Riskiest Counties , whereas RiskScore = Hygiene + Structural + ConfidenceInManagement

select County,
	   avg_riskscore,
	   rank() over (order by avg_riskscore desc) as ranked
from(
select County, 
	avg(Hygiene + Structural + ConfidenceInManagement) as avg_riskscore
from mcdonalds_clean
group by County) as t;


#City vs County Performance Gap

select c.City,
	   c.County,
       avg(c.Hygiene) as city_avg_hygiene,
       county_stats.county_avg_hygiene,
       round(avg(c.Hygiene - county_stats.county_avg_hygiene),2) as performance_gap
from mcdonalds_clean as c
join(
select County,
       avg(Hygiene) as county_avg_hygiene
from mcdonalds_clean 
group by County) as county_stats
on c.County = county_stats.County
group by   c.City ,c.County
;

#Outlier stores :
# The stores whose hygiene score is so low that it’s statistically abnormal for their county.



SELECT
    c.full_address,
    c.City,
    c.County,
    c.BusinessType,
    c.Hygiene,
    county_stats.county_avg_hygiene,
    county_stats.county_std_hygiene,
    (c.Hygiene - county_stats.county_avg_hygiene) AS hygiene_gap
FROM mcdonalds_clean c
JOIN (
    SELECT 
        County,
        AVG(Hygiene) AS county_avg_hygiene,
        STDDEV(Hygiene) AS county_std_hygiene
    FROM mcdonalds_clean
    GROUP BY County
) AS county_stats
    ON c.County = county_stats.County
WHERE c.Hygiene < county_stats.county_avg_hygiene - 2 * county_stats.county_std_hygiene
ORDER BY c.Hygiene ASC;

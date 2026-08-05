select *
from orders;
## confirming if the total cost is correct
SELECT product_cost, platform_fee, shipping_cost, transaction_fee, total_costs,
(product_cost + platform_fee + shipping_cost + transaction_fee) as total_cost_check
from orders
where total_costs != round((product_cost + platform_fee + shipping_cost + transaction_fee), 2) ;

# the datasets are all clean so lets sart our analysis
#1. Category Profitability
#Group orders by product category.
#Calculate total revenue, total costs, total profit, and profit margin for each.
#Identify the top and bottom performers##

select primary_category, 
	   round(sum(total_costs),2) as costs, 
       round(sum(net_revenue), 2) as revenue,
       round(sum(profit), 2) as profit,
       round((sum(profit)/sum(net_revenue))*100) as profit_margin
from orders
group by primary_category;

##2. Channel Analysis
#Group by sales channel.
#Compare average order value, average profit, and return rate across channels.
#Factor in platform fees for Marketplace and Social Commerce.


select `channel`, 
	   round(avg(net_revenue), 2) as avg_order_value,
       round(avg(profit), 2) as avg_profit
from orders
group by `channel`;



### return rate across channels

select `channel`,
		count(*) as total_orders,
        sum(case when returned = 'Yes' then 1 else 0 end) as total_returned,
		round(sum(case when returned = 'Yes' then 1 else 0 end)/count(*), 3) as return_rate
from orders
group by `channel`;

#Factor in platform fees for Marketplace and Social Commerce.

select `channel`, 
	   round(avg(platform_fee), 2) as avg_platform_fee,
       round(avg(profit), 2) as avg_profit
from orders
group by `channel`;

##Marketplace and Social Commerce incur significant platform fees, which substantially reduce profit per order.
#Marketplace has the highest fees (£18.97), resulting in the lowest profit (£15.40) despite strong order values.
#Social Commerce also suffers from fees (£9.87) and returns, limiting profit to £17.11.
#In contrast, Website and Mobile App have no platform fees and therefore deliver the highest profit per order.



SELECT *
FROM marketing_spend;

## checking for any duplicates 
select spend, impressions, clicks, conversions, count(*)
from marketing_spend
group by spend, impressions, clicks, conversions ;

## no duplications found, then lets jump to its analysis


#. Marketing ROI
#Analyze the marketing spend dataset.
#Calculate ROAS, cost per acquisition, and cost per click by platform.
#Identify which platforms are underperforming.

select platform,
	   avg_roas,
       avg_cpa,
       avg_cpc,
       CASE 
        WHEN avg_roas > 3 THEN 'Excellent'
        WHEN avg_roas BETWEEN 2 AND 3 THEN 'Good'
        WHEN avg_roas BETWEEN 1 AND 2 THEN 'Weak'
        ELSE 'Bad'
    END AS roas_rating,

    CASE 
        WHEN avg_cpa < 10 THEN 'Excellent'
        WHEN avg_cpa BETWEEN 10 AND 20 THEN 'Good'
        WHEN avg_cpa BETWEEN 20 AND 30 THEN 'Weak'
        ELSE 'Bad'
    END AS cpa_rating,

    CASE 
        WHEN avg_cpc < 0.50 THEN 'Excellent'
        WHEN avg_cpc BETWEEN 0.50 AND 0.80 THEN 'Good'
        WHEN avg_cpc BETWEEN 0.80 AND 1.00 THEN 'Weak'
        ELSE 'Bad' 
	ENd as  cpc_rating
from(       
select platform ,
	   round(avg(roas), 2)as avg_roas,
       round(avg(cpa), 2)as avg_cpa,
       round(avg(cpc), 2)as avg_cpc
from marketing_spend
group by platform) as t;


##Email Marketing shows strong ROAS but extremely poor cost efficiency.
#CPA (£26.01) is significantly above acceptable levels, and CPC (£1.09) is the highest of all platforms.
#This indicates that although Email Marketing generates revenue, it does so at an unsustainable cost.
#All other platforms deliver excellent ROAS, low CPA, and low CPC, making them far more efficient and scalable.
#Recommendation: Reduce or eliminate spend on Email Marketing and reallocate budget to higher-performing channels 
#such as TikTok, Instagram, Google Ads, and Influencer campaigns


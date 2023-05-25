create database tourists;
show tables;
select * from domestic_visitors;

/* q1->list top 10 district with highest no. of domestic footfall overall?*/

select distinct district, sum(visitors) as total_visitors from domestic_visitors
group by district
order by total_visitors desc
limit 10;
/*list down top 3 district based on compounded annual growth rate of visitors between 2016-2019



WITH yearly_visitors AS (
  SELECT
    district,
    year,
    SUM(visitors) AS total_visitors
  FROM
    domestic_visitors
  /*WHERE
    year BETWEEN 2016 AND 2019
  GROUP BY
    district,
    year
),
district_growth_rates AS (
  SELECT
    district,
    POWER(SUM(CAST(total_visitors AS FLOAT) / initial_visitors), 1.0 / (MAX(year) - MIN(year) + 1)) - 1 AS growth_rate
  FROM
    yearly_visitors
    JOIN (
      SELECT
        district,
        year AS initial_year,
        SUM(visitors) AS initial_visitors
      FROM
        domestic_visitors
      WHERE
        year = 2016
      GROUP BY
        district,
        year
    ) AS initial_totals ON yearly_visitors.district = initial_totals.district
  GROUP BY
    district
)
SELECT
  district,
  growth_rate
FROM
  district_growth_rates
ORDER BY
  growth_rate DESC ///
/*LIMIT 3;




SELECT distinct district, 
  (POWER((MAX(total_visitors)/MIN(total_visitors)),(1.0/(MAX(year)-MIN(year)+1))) - 1) AS growth_rate
FROM (
  SELECT distinct yearly_visitors.district , 
    year, 
    SUM(visitors) AS total_visitors
  FROM domestic_visitors
  WHERE year BETWEEN 2016 AND 2019
  GROUP BY district, year
) AS yearly_visitors
JOIN (
  SELECT distinct initial_totals.district , SUM(visitors) AS initial_visitors
  FROM domestic_visitors
  WHERE year = 2016
  GROUP BY district
) AS initial_totals
ON yearly_visitors.district = initial_totals.district
GROUP BY district
ORDER BY growth_rate DESC
LIMIT 3;
*/
SELECT district,
  POWER(total_visitors_2019/total_visitors_2016, 1.0/3) - 1 AS growth_rate
FROM (
  SELECT district,
    SUM(CASE WHEN year = 2016 THEN visitors ELSE 0 END) AS total_visitors_2016,
    SUM(CASE WHEN year = 2019 THEN visitors ELSE 0 END) AS total_visitors_2019
  FROM domestic_visitors
  WHERE year BETWEEN 2016 AND 2019
  GROUP BY district
) AS district_totals
ORDER BY growth_rate desc
LIMIT 3;

/*q3. list down bottom 3 based on cagr*/


SELECT district,
  POWER(total_visitors_2019/total_visitors_2016, 1.0/3) - 1 AS growth_rate
FROM (
  SELECT district,
    SUM(CASE WHEN year = 2016 THEN visitors ELSE 0 END) AS total_visitors_2016,
    SUM(CASE WHEN year = 2019 THEN visitors ELSE 0 END) AS total_visitors_2019
  FROM domestic_visitors

  GROUP BY district
) AS district_totals
ORDER BY growth_rate asc
LIMIT 3;

/* write to find what are thepeak and low seasons month for hydersabad*/


select district,month,max(visitors) as visitor_max
from domestic_visitors
where district='Hyderabad'
group by month
order by visitor_max desc  limit 3;

select district,month,MIN(visitors) as visitor_min
from domestic_visitors
where district='Hyderabad'
group by month
order by visitor_min asc limit 3;


/* wrtie a query to show ratio of top and bottom 3 districts from domestic and foreign*/

select * from domestic_visitors;
select * from foreign_visitors;

(select distinct district, max(visitors) as maxi,min(visitors) as mini
from domestic_visitors
group by district
order by maxi desc ,mini asc limit 3)
union
(select distinct district, max(visitors) as mixi, min(visitors) as misi
from foreign_visitors
group by district
order by mixi desc ,misi asc limit 3);




select distinct d.district, max(d.visitors) as maxi, max(f.visitors) as mixi
from domestic_visitors d 
join foreign_visitors f on f.district=d.district
group by d.district,f.district
order by maxi desc ,mixi desc limit 3;


/*final approach*/
(SELECT 
    domestic_visitors.district,
    ROUND(SUM(domestic_visitors.visitors)/SUM(foreign_visitors.visitors), 2) AS ratio
FROM 
    domestic_visitors AS domestic
INNER JOIN 
    foreign_visitors AS foreign1 ON domestic.district = foreign1.district AND domestic.date = foreign1.date
GROUP BY 
    domestic.district
HAVING 
    SUM(foreign1.visitors) > 0
ORDER BY 
    ratio DESC
LIMIT 
    3)
UNION ALL
(SELECT 
    domestic.district,
    ROUND(SUM(domestic.visitors)/SUM(foreign1.visitors), 2) AS ratio
FROM 
    domestic_visitors AS domestic
INNER JOIN 
    foreign_visitors AS foreign1 ON domestic.district = foreign1.district AND domestic.date = foreign1.date
GROUP BY 
    domestic.district
HAVING 
    SUM(foreign1.visitors) > 0
ORDER BY 
    ratio ASC
LIMIT 
    3);


/* write a sql query to list the top and bottom 5 district based on population to tourist footfall ratio in 2019  */

(SELECT 
    district, 
    SUM(CASE WHEN year = 2019 THEN visitors END) / MAX(population) AS ratio 
FROM 
    (
        SELECT 
            district, 
            year, 
            SUM(visitors) AS visitors 
        FROM 
            domestic_visitors 
        GROUP BY 
            district, 
            year 
        UNION ALL 
        SELECT 
            district, 
            year, 
            SUM(visitors) AS visitors 
        FROM 
            foreign_visitors 
        GROUP BY 
            district, 
            year
    ) AS visitors_combined 
INNER JOIN 
    (
        SELECT 
            district, 
            MAX(population) AS population 
        FROM 
            (
                SELECT 
                    district, 
                    SUM(population) AS population 
                FROM 
                    domestic_visitors 
                GROUP BY 
                    district 
                UNION ALL 
                SELECT 
                    district, 
                    SUM(population) AS population 
                FROM 
                    foreign_visitors 
                GROUP BY 
                    district
            ) AS population_combined
        GROUP BY 
            district 
    ) AS population 
    ON visitors_combined.district = population.district
WHERE 
    visitors_combined.year = 2019 
    AND population.population > 0 
GROUP BY 
    district 
ORDER BY 
    ratio DESC 
LIMIT 
    5 )
UNION ALL 
(SELECT 
    district, 
    SUM(CASE WHEN year = 2019 THEN visitors END) / MAX(population) AS ratio 
FROM 
    (
        SELECT 
            district, 
            year, 
            SUM(visitors) AS visitors 
        FROM 
            domestic_visitors 
        GROUP BY 
            district, 
            year 
        UNION ALL 
        SELECT 
            district, 
            year, 
            SUM(visitors) AS visitors 
        FROM 
            foreign_visitors 
        GROUP BY 
            district, 
            year
    ) AS visitors_combined 
INNER JOIN 
    (
        SELECT 
            district, 
            MAX(population) AS population 
        FROM 
            (
                SELECT 
                    district, 
                    SUM(population) AS population 
                FROM 
                    domestic_visitors 
                GROUP BY 
                    district 
                UNION ALL 
                SELECT 
                    district, 
                    SUM(population) AS population 
                FROM 
                    foreign_visitors 
                GROUP BY 
                    district
            ) AS population_combined
        GROUP BY 
            district 
    ) AS population 
    ON visitors_combined.district = population.district
WHERE 
    visitors_combined.year = 2019 
    AND population.population > 0 
GROUP BY 
    district 
ORDER BY 
    ratio ASC 
LIMIT 
    5);

/*write a sql query to find the projected number of foreign and domestic tourist  in hyderabad based on growth rate from presvious years*/

WITH 
    domestic_growth_rates AS (
        SELECT 
            district, 
            year, 
            AVG(visitors) AS avg_visitors, 
            (AVG(visitors) - LAG(AVG(visitors)) OVER (PARTITION BY district ORDER BY year)) / LAG(AVG(visitors)) OVER (PARTITION BY district ORDER BY year) AS growth_rate
        FROM 
            domestic_visitors
        WHERE 
            district = 'Hyderabad'
        GROUP BY 
            district, year
    ),
    foreign_growth_rates AS (
        SELECT 
            district, 
            year, 
            AVG(visitors) AS avg_visitors, 
            (AVG(visitors) - LAG(AVG(visitors)) OVER (PARTITION BY district ORDER BY year)) / LAG(AVG(visitors)) OVER (PARTITION BY district ORDER BY year) AS growth_rate
        FROM 
            foreign_visitors
        WHERE 
            district = 'Hyderabad'
        GROUP BY 
            district, year
    )
SELECT 
    'Hyderabad' AS district,
    domestic.avg_visitors * POWER(1 + domestic.growth_rate, 1) AS projected_domestic_visitors,
    foreign_visitors.avg_visitors * POWER(1 + foreign_visitors.growth_rate, 1) AS projected_foreign_visitors
FROM 
    domestic_growth_rates AS domestic
    JOIN foreign_growth_rates AS foreign_visitors
        ON domestic.district = foreign_visitors.district
        AND domestic.year = foreign_visitors.year;
        
        
/* find which district has highest potential for tourism*/

SELECT 
    district, 
    AVG(visitors) AS avg_visitors 
FROM 
    (SELECT district, visitors FROM domestic_visitors 
     UNION ALL 
     SELECT district, visitors FROM foreign_visitors) AS all_visitors 
GROUP BY 
    district 
ORDER BY 
    avg_visitors DESC 
LIMIT 
    1;

/*what kind of cultural corporate events can be conducted to boost tourism in which month and which district */

select distinct d.district,max(d.visitors) as maxim , max(f.visitors) as faxim from domestic_visitors as d join foreign_visitors as f
on d.district=f.district
group by district 
order by maxim desc, faxim desc limit 3;

/*another approach*/
SELECT 
    district, month, 
    SUM(CASE WHEN visitors > AVG(visitors) THEN 1 ELSE 0 END) AS high_visitors, 
    SUM(CASE WHEN visitors < AVG(visitors) THEN 1 ELSE 0 END) AS low_visitors 
FROM 
    (SELECT district, month, visitors FROM domestic_visitors 
     UNION ALL 
     SELECT district, month, visitors FROM foreign_visitors) AS all_visitors 
WHERE 
    district = 'Hyderabad' 
    AND month = 'june' 
GROUP BY 
    district, month;


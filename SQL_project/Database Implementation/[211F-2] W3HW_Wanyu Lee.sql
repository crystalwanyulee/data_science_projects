DROP   DATABASE IF EXISTS db_countries;
CREATE DATABASE db_countries;
USE    db_countries;


# 1. What countries have a total GDP above the mean?
### Answer: 77 rows return

SELECT Country AS 'Countries (GDP>mean)', 
       GDP
FROM coUntries_of_the_world 
WHERE GDP > (SELECT AVG(GDP) 
             FROM coUntries_of_the_world)
ORDER BY GDP DESC;



# 2.  How  many  countries  are  above  the  mean  on  each  region  in  Area,  GDP  and  another  variable  decided by yourself? 
### Answer: 7 rows return (In addion to Area and GDP, I also choose Literacy variable)

SELECT countries_of_the_world.Region, 
       Count(countries_of_the_world.country)
  FROM countries_of_the_world
  LEFT JOIN (SELECT region, AVG(GDP)      AS avg_GDP      FROM countries_of_the_world  GROUP BY region) AS T1 ON countries_of_the_world.region = T1.region
  LEFT JOIN (SELECT region, AVG(area)     AS avg_area     FROM countries_of_the_world  GROUP BY region) AS T2 ON countries_of_the_world.region = T2.region
  LEFT JOIN (SELECT region, AVG(literacy) AS avg_literacy FROM countries_of_the_world  GROUP BY region) AS T3 ON countries_of_the_world.region = T3.region 
  WHERE countries_of_the_world.GDP > T1.avg_GDP 
  AND   countries_of_the_world.Area > T2.avg_area 
  AND   countries_of_the_world.Literacy > T3.avg_literacy
  GROUP BY countries_of_the_world.region;


SELECT countries_of_the_world.Region, 
       Count(countries_of_the_world.country)
  FROM countries_of_the_world
  LEFT JOIN (SELECT region, AVG(GDP)      AS avg_GDP      FROM countries_of_the_world  GROUP BY region) AS T1 ON countries_of_the_world.region = T1.region




# 3.  How many regions have more than 65% of their countries with a GDP per capita above 6000? 
### Answer: 4

-- Step1: Create a temporary table include region, the number of countreis with GDP more than 6000 and the total number of countries
DROP TABLE IF EXISTS no_3;
CREATE TEMPORARY TABLE no_3
   SELECT T1.Region, T1.GDP_more_than_6000, T2.Total_countries
   FROM(
	  SELECT Region, COUNT(Country) AS GDP_more_than_6000 FROM countries_of_the_world WHERE GDP > 6000 GROUP BY Region ORDER BY Region) AS T1
   RIGHT JOIN (
      SELECT Region, COUNT(Country) AS Total_countries    FROM countries_of_the_world GROUP BY Region  ORDER BY Region) AS T2 
   ON T1.Region = T2.Region;

-- Step2: Count the total number of regions with more than 65% of their countries with a GDP per capita above 6000
SELECT COUNT(Region) AS 'The number of regions (>65% countries with GDP above 6000)'
FROM no_3 
WHERE (GDP_more_than_6000/Total_countries) > 0.65;




# 4.  List all the countries with a GDP that is 40% below the mean or less. 
### Answer: 11 rows return
SELECT Country 
FROM countries_of_the_world 
WHERE GDP > 0.6*(SELECT AVG(GDP) 
				 FROM countries_of_the_world) 
				 GROUP BY Region;



#　5.  List all the countries with a GDP per capita that is between 40% and 60% the mean GDP per capita 
### Answer: 2 rows return
SELECT Country 
FROM countries_of_the_world 
WHERE GDP/POPULATION 
      BETWEEN 0.4*(SELECT AVG(GDP/POPULATION) FROM countries_of_the_world) 
      AND     0.6*(SELECT AVG(GDP/POPULATION) FROM countries_of_the_world) 
GROUP BY Region;




# 6.  Which letter is the most popular first letter among all the countries? (i.e. what is the letter that starts the largest number of countries?) 
### Answer: S

SELECT first_letter AS 'The most popular letter', COUNT(first_letter) AS frequency
FROM (SELECT SUBSTR(Country,1,1) AS first_letter FROM countries_of_the_world) AS T 
GROUP BY T.first_letter 
ORDER BY frequency DESC LIMIT 1;




# 7.  What are the countries with a coast to area ratio in the top 50?  
### Answer: 50 rows return
SELECT Country AS 'Top 50 country with high coast to area ratio', 
       round(Coastline/Area,2) AS 'Coast to area ratio' 
FROM countries_of_the_world 
ORDER BY Coastline/Area DESC LIMIT 50;




# 7-a. From these countries, how many of them belong to the bottom 30 countries by GDP per capita?
### Answer: 3
-- Step1: Create a temporary table
DROP TABLE IF EXISTS seven_a;
CREATE TEMPORARY TABLE seven_a
   SELECT Country,
          RANK() OVER (ORDER BY Coastline/Area DESC) Coast_Ratio_decreasing,
          RANK() OVER (ORDER BY GDP) GDP_increasing
   FROM countries_of_the_world;

-- Step2: Count the number
SELECT COUNT(Country) AS 'Poor countries with high coast to area ratio' 
FROM seven_a 
WHERE Coast_Ratio_decreasing <= 51 AND GDP_increasing <=21;




# 7-b. From these countries, how many of them belong to the top 30 countries by GDP per capita?   
### Answer: 4

-- Step1: Create a temporary table
DROP TABLE IF EXISTS seven_b;
CREATE TEMPORARY TABLE seven_b
   SELECT Country,
          RANK() OVER (ORDER BY Coastline/Area DESC) Coast_Ratio_decreasing,
          RANK() OVER (ORDER BY GDP DESC) GDP_decreasing
   FROM countries_of_the_world;

-- Step2: Count the number
SELECT COUNT(Country) AS 'Rich countries with high coast to area ratio' 
FROM seven_b 
WHERE Coast_Ratio_decreasing <= 51 AND GDP_decreasing <=21;




#8.  Is the average Agriculture, Industry, Service distribution of the top 20 richest countries different than the one of the lowest 20? j
### Answer: Yes, there are some difference:
-- (1) In the poorest countries, the ratio of agriculture is high but it is relatively low in the richest countries
-- (2) In the richest countries, the ratio of service is high but it is relatively low in the poorest countries
-- (3) The ratio of industry is similar in two kind of countries

-- Step1: Create a temporary table
DROP TABLE IF EXISTS new_tbl;
CREATE TEMPORARY TABLE new_tbl  
  SELECT Country, 
		 Agriculture, 
         Industry, 
         Service,
         RANK() OVER (ORDER BY GDP) rank_increasing,
         RANK() OVER (ORDER BY GDP DESC) rank_decreasing
  FROM countries_of_the_world;

-- Step2: Count the number
SELECT rank_group,
       round(avg(Agriculture),3) as 'mean_agriculture',
       round(avg(Industry),3) as 'mean_industry',
       round(avg(Service),3) as 'mean_service'
FROM(SELECT *,
            1*(rank_increasing<21) + 
            2*(rank_decreasing<21)
            AS rank_group
	  FROM new_tbl
) AS T1
WHERE rank_group IN (1,2)
GROUP BY rank_group ORDER BY rank_group;  


# 9.  How  much  higher  is  the  average  literacy  level  in  the  20%  percentile  of  the  richest  countries relative to the poorest 20% countries? 
### Answer: 38.65

-- Step1: Create a temporary table
DROP TABLE IF EXISTS no_9;
CREATE TEMPORARY TABLE no_9
   SELECT Country,
          Literacy,
          RANK() OVER (ORDER BY GDP DESC) GDP_decreasing,
          RANK() OVER (ORDER BY GDP) GDP_increasing
   FROM countries_of_the_world;

-- Step2: compare the average literacy between the richest countries and the poorest countries
SELECT GDP_group, 
       round(AVG(literacy),2) AS 'mean_literacy'
FROM(SELECT *,
	        1*(GDP_decreasing<(SELECT 0.2*(SELECT COUNT(country) FROM countries_of_the_world) AS twenty_percentile)) +
            2*(GDP_increasing<(SELECT 0.2*(SELECT COUNT(country) FROM countries_of_the_world) AS twenty_percentile)) 
     AS GDP_group FROM no_9
) AS T9 
WHERE T9.GDP_GROUP IN (1,2) GROUP BY T9.GDP_group ORDER BY GDP_GROUP;




# 10. From all the countries with a coast ratio at least 50% lower than the mean, which % of them stay in Africa?  
### Answer: 26.2673%
     SELECT 100*(
	   (SELECT COUNT(Country) 
        FROM countries_of_the_world 
        WHERE (Coastline/Area) 
         < (SELECT AVG(Coastline/Area) 
            FROM countries_of_the_world)
            AND Region REGEXP 'AFRICA') 
	  /(SELECT COUNT(Country) 
        FROM countries_of_the_world 
	    WHERE (Coastline/Area) 
		 < (SELECT AVG(Coastline/Area) 
            FROM countries_of_the_world))) 
     AS 'Countries with Low Coast Ratio in Africa(%)';



# 10-a.  How many of them start with the letter C? 
### Answer: 8
     SELECT COUNT(Country) 
     FROM countries_of_the_world 
     WHERE (Coastline/Area) < (SELECT AVG(Coastline/Area) 
                               FROM countries_of_the_world)
     AND Region REGEXP 'AFRICA' 
     AND Country REGEXP '^C';

-- driver with most completed races

select 

	d.surname,
    d.forename,
    count(r.RaceId) as Race_count
from results r 
join drivers d on r.driverId = d.driverId
group by d.surname,d.forename
order by race_count desc
limit 5;

-- fastest lap on circuit

select driver_name,Circuit_name,year,fastestlapTime from 
(select 
	concat(d.forename,' ',d.surname) as driver_name,
	c.name as Circuit_name,
    races.year,
	r.fastestlapTime,
    row_number() over(partition by c.name order by r.fastestlapTime) as rnum
from 
    results r
    join races on r.raceId = races.raceId
    join circuits c on races.circuitId = c.circuitId
    join drivers d on r.driverId = d.driverId
where 
    r.fastestLapTime>0 ) a where a.rnum = 1;
    
-- driver with most carrer points 

select 
	concat(d.forename,' ',d.surname) as driver_name,
	sum(r.points) as total_points
    from results r
    join drivers d on r.driverId = d.driverId
    group by driver_name
    order by total_points desc
    limit 10;
    
--  average points

select 
	concat(d.forename,' ',d.surname) as driver_name,
	avg(r.points) as average_points,
    count(r.raceId) as total_races
    from results r
    join drivers d on r.driverId = d.driverId
    group by driver_name
    order by average_points desc
    limit 10;


-- most no. of fastest laps from driver

select 
	concat(d.forename,' ',d.surname) as driver_name,
	(select count(*) from results r 
    where r.driverId = d.driverId and r.fastestLap is not null) as fastestlapcount
from drivers d 
order by fastestlapcount desc
limit 5;


select 
	c.name as Circuit_name,
    count(*) as no_of_wins
from 
    results ra
    join races r on ra.raceId = r.raceId
    join circuits c on r.circuitId = c.circuitId
    
where 
driverId = 1 and ra.position = 1
group by 
    c.name
    order by no_of_wins desc;

-- points scored by lewis every year

select 
	ra.year as race_year,
	sum(r.points) as total_points
from 
results r
join 
	races ra on r.raceId=ra.raceId
where 
	r.driverId = 1
group by year
order by total_points desc;
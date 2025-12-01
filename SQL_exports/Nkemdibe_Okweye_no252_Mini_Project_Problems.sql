-- Mini Project
-- 1) Find maximal departure delay in minutes for each airline. Sort results from smallest to largest maximum delay. Output airline names and values of the delay.
SELECT l_ai_d.Name,
       MAX(a.DepDelayMinutes) AS MaxDepDelay
FROM al_perf AS a
JOIN L_AIRLINE_ID AS l_ai_d
  ON a.DOT_ID_Reporting_Airline = l_ai_d.ID
GROUP BY l_ai_d.Name
ORDER BY MaxDepDelay ASC;
-- 17 row(s) returned

-- 2) Find maximal early departures in minutes for each airline. Sort results from largest to smallest. Output airline names.

-- SELECT l_ai_d.Name,
--        MIN(a.DepDelay) AS EarlyDep
-- FROM al_perf AS a
-- JOIN L_AIRLINE_ID AS l_ai_d
--   ON a.DOT_ID_Reporting_Airline = l_ai_d.ID
-- GROUP BY l_ai_d.Name
-- ORDER BY EarlyDep ASC;

SELECT l_ai_d.Name,
       -MIN(a.DepDelay) AS EarlyDep
FROM al_perf AS a
JOIN L_AIRLINE_ID AS l_ai_d
  ON a.DOT_ID_Reporting_Airline = l_ai_d.ID
GROUP BY l_ai_d.Name
ORDER BY EarlyDep DESC;
-- 17 row(s) returned

-- 3)Rank days of the week by the number of flights performed by all airlines on that day (1 is the busiest). Output the day of the week names, number of flights and ranks in the rank increasing order.
SELECT l_w.Day AS DayOfWeek, COUNT(*) AS NumFlights, RANK() OVER (ORDER BY COUNT(*) DESC) AS FlightRank
FROM al_perf AS a
JOIN L_WEEKDAYS AS l_w
  ON a.DayOfWeek = l_w.Code
GROUP BY l_w.Day
ORDER BY FlightRank ASC;
-- 7 row(s) returned

-- 4) Find the airport that has the highest average departure delay among all airports. Consider 0 minutes delay for flights that departed early. Output one line of results: the airport name, code, and average delay.

SELECT l_a.Name, l_a.Code AS Code, AVG(a.DepDelayMinutes) AS AverageDepDelay
FROM al_perf AS a
JOIN L_AIRPORT AS l_a
  ON a.Origin = l_a.Code
GROUP BY l_a.Name, l_a.Code
ORDER BY AverageDepDelay DESC
LIMIT 1;
-- 1 row(s) returned

-- 5) For each airline find an airport where it has the highest average departure delay. Output an airline name, a name of the airport that has the highest average delay, and the value of that average delay.

WITH avg_delays AS (SELECT a.DOT_ID_Reporting_Airline AS airline_id, a.OriginAirportID AS airport_id, AVG(a.DepDelayMinutes) AS avg_delay
					FROM al_perf AS a
                    GROUP BY airline_id, airport_id),
	 max_delays AS (SELECT airline_id, MAX(avg_delay) AS max_avg_delay
					FROM avg_delays
                    GROUP BY airline_id)
SELECT lairline.Name AS AirlineName, lairport.Name AS AirportName, md.max_avg_delay AS MaxAvgDepDelay
FROM max_delays AS md
JOIN avg_delays AS ad
  ON md.airline_id    = ad.airline_id
 AND md.max_avg_delay = ad.avg_delay
JOIN L_AIRLINE_ID AS lairline
  ON ad.airline_id = lairline.ID
JOIN L_AIRPORT_ID AS lairport
  ON ad.airport_id = lairport.ID
ORDER BY MaxAvgDepDelay DESC;
-- 17 row(s) returned

-- 6a) Check if your dataset has any canceled flights.

SELECT COUNT(*) AS NumCancelledFlights
FROM al_perf
WHERE Cancelled = 1;
-- '14488' canceled flights
-- 1 row(s) returned

-- SELECT *
-- FROM al_perf
-- WHERE Cancelled = 1;

-- 6b) If it does, what was the most frequent reason for each departure airport? Output airport name, the most frequent reason, and the number of cancelations for that reason.
WITH reason_counts AS (SELECT OriginAirportID AS airport_id, CancellationCode AS reason_code, COUNT(*) AS num_cancellations
						FROM al_perf
                        WHERE Cancelled = 1
                        GROUP BY airport_id, reason_code),
	max_counts AS (SELECT airport_id, MAX(num_cancellations) AS max_cancel
				   FROM reason_counts
                   GROUP BY airport_id)
SELECT lairport.Name AS AirportName, rc.reason_code AS CancellationCode, lcancel.Reason , rc.num_cancellations AS NumCancellations
FROM reason_counts rc
JOIN max_counts mc
    ON rc.airport_id = mc.airport_id
   AND rc.num_cancellations = mc.max_cancel
JOIN L_AIRPORT_ID lairport
    ON rc.airport_id = lairport.ID
JOIN L_CANCELATION lcancel
	ON rc.reason_code = lcancel.code
ORDER BY NumCancellations DESC;
-- 317 row(s) returned

-- 7) Build a report that for each day output average number of flights over the preceding 3 days.
WITH daily_flights AS ( SELECT FlightDate, COUNT(*) AS NumFlights
                        FROM al_perf
                        GROUP BY FlightDate)
SELECT FlightDate, NumFlights, AVG(NumFlights) 
OVER (ORDER BY FlightDate ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS AvgFlights_Preceding3Days
FROM daily_flights
ORDER BY FlightDate;
-- 31 row(s) returned

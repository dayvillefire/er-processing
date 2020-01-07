###
### TrainingSessions.sql
### @jbuchbinder
###

SELECT '2019-01-01 00:00:00' INTO @startPosition;
SELECT '2020-01-01 00:00:00' INTO @endPosition;

SELECT
  c.startDate,
  s.StationName,
  c.Notes
FROM Schedule c
  LEFT OUTER JOIN Stations s ON s.StationID = c.StationsID
WHERE c.Title = 'Training'
  AND ( c.startDate >= @startPosition AND c.startDate < @endPosition )
ORDER BY c.startDate
;


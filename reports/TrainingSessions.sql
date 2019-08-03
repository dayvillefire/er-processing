###
### TrainingSessions.sql
### @jbuchbinder
###

SELECT '2018-01-01 00:00:00' INTO @startPosition;

SELECT
  c.startDate,
  s.StationName,
  c.Notes
FROM Schedule c
  LEFT OUTER JOIN Stations s ON s.StationID = c.StationsID
WHERE c.Title = 'Training' AND c.startDate >= @startPosition
ORDER BY c.startDate
;


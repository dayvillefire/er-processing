###
### TrainingAttendance.sql
### @jbuchbinder
###

SELECT '2019-01-01 00:00:00' INTO @startPosition;
SELECT '2020-01-01 00:00:00' INTO @endPosition;

SELECT
  s.startDate, s.endDate,
  s.Notes,
  st.StationName,
  pi.Hours,
  u.LastName, u.FirstName
FROM Schedule s
  JOIN PayrollItems pi ON pi.ClassID = s.ClassID
  JOIN Stations st ON st.StationID = s.StationsID
  JOIN Users u ON u.UserID = pi.UID
WHERE s.Title = 'Training'
  AND ( s.startDate >= @startPosition AND s.startDate < @endPosition )
ORDER BY s.startDate, u.LastName, u.FirstName
;


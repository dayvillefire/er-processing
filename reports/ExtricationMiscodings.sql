###
### ExtricationMiscodings.sql
### @jbuchbinder
###
### Designed to look for mis-codings involving MVAs which should have been
### coded as 352s.
###

SELECT '2018-01-01 00:00:00' INTO @startPosition;
SELECT '2022-01-01 00:00:00' INTO @endPosition;

SELECT
  i.IncidentDateTime,
  i.RunNumber,
  i.IncidentType,
  REPLACE(i.Address,'<BR>', ' ') AS Address
FROM Incidents i
WHERE i.IncidentDateTime >= @startPosition AND i.IncidentDateTime < @endPosition AND
  LEFT(i.IncidentType,1) = '3' AND
  LEFT(i.IncidentType,3) > 321
ORDER BY i.RunNumber;

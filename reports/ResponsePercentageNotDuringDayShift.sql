###
### ResponsePercentageNotDuringDayShift.sql
### @jbuchbinder
###

SELECT '2020-01-01 00:00:00' INTO @startPosition;
SELECT '2021-01-01 00:00:00' INTO @endPosition;

SET sql_mode='';

DROP TABLE IF EXISTS ResponseAggregate;

CREATE TABLE ResponseAggregate
SELECT
  CONCAT(TRIM(eu.FirstName), ' ', TRIM(eu.LastName)) AS Name,
  i.IncidentDate,
  i.IncidentDateTime,
  LEFT(i.IncidentType,3) AS IncidentType,
  RIGHT(i.IncidentType,LENGTH(i.IncidentType)-5) AS IncidentDescription,
  i.RunNumber,
  eu.FirstName, eu.LastName,
  a.IDOfApparatusOrResource,
  CASE
    WHEN a.IDOfApparatusOrResource = 'POV' THEN 'POV'
    WHEN a.IDOfApparatusOrResource LIKE 'C%' THEN 'POV'
    WHEN a.IDOfApparatusOrResource IN ( 'NONE', NULL ) THEN NULL
    WHEN a.IDOfApparatusOrResource IS NULL THEN NULL
    ELSE 'APPARATUS'
  END AS ApparatusType
FROM Exposures e
  LEFT OUTER JOIN Incidents i ON i.IncidentID = e.IID
  LEFT OUTER JOIN Users u ON u.UserID = e.UID
  LEFT OUTER JOIN ExposureUser eu ON eu.ExposureId = e.ExposureID
  LEFT OUTER JOIN Apparatus a ON a.ApparatusID = eu.ApparatusID
WHERE WEEKDAY(i.IncidentDateTime) >= 5 OR HOUR(i.IncidentDateTime) < 10 OR HOUR(IncidentDateTime) > 16
;

SELECT COUNT(DISTINCT RunNumber) INTO @totalCalls
FROM ResponseAggregate
WHERE
  STR_TO_DATE(IncidentDate, '%Y%m%d') >= @startPosition AND
  STR_TO_DATE(IncidentDate, '%Y%m%d') < @endPosition
;

SELECT
  p1.Name AS Name,
  @totalCalls AS `TotalCalls`,
  COUNT(DISTINCT p1.RunNumber) AS `TotalResponses`,
  COUNT(DISTINCT p2.RunNumber) AS `OnScene`,
  COUNT(DISTINCT p3.RunNumber) AS `POV`,
  COUNT(DISTINCT p2.RunNumber) - COUNT(DISTINCT p3.RunNumber) AS `Apparatus`,
  COUNT(DISTINCT p1.RunNumber) - COUNT(DISTINCT p2.RunNumber) AS `Standby`,
  CONCAT(COUNT(DISTINCT p2.RunNumber) / COUNT(DISTINCT p1.RunNumber) * 100, '%') AS `ScenePct`,
  CONCAT((COUNT(DISTINCT p1.RunNumber) / @totalCalls ) * 100, '%') AS `TotalPct`
FROM ResponseAggregate AS p1
  LEFT JOIN ResponseAggregate AS p2 ON ( p1.Name = p2.Name AND p1.RunNumber = p2.RunNumber AND p2.ApparatusType IN ( 'POV', 'APPARATUS' ) )
  LEFT JOIN ResponseAggregate AS p3 ON ( p1.Name = p3.Name AND p1.RunNumber = p3.RunNumber AND p3.ApparatusType IN ( 'POV' ) )
WHERE
  STR_TO_DATE(p1.IncidentDate, '%Y%m%d') >= @startPosition AND
  STR_TO_DATE(p1.IncidentDate, '%Y%m%d') < @endPosition
GROUP BY p1.Name
ORDER BY REPLACE(TotalPct, '%', '')+0 DESC, REPLACE(ScenePct, '%', '')+0 DESC, p1.LastName, p1.FirstName DESC
;

DROP TABLE IF EXISTS ResponseAggregate;


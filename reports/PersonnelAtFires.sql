###
### PersonnelAtFires.sql
### @jbuchbinder
###

SELECT '2019-01-01 00:00:00' INTO @startPosition;
SELECT '2020-01-01 00:00:00' INTO @endPosition;

SELECT
  i.IncidentDateTime,
  LEFT(i.IncidentType,3) AS IncidentType,
  RIGHT(i.IncidentType,LENGTH(i.IncidentType)-5) AS IncidentDescription,
  i.RunNumber,
  eu.FirstName, eu.LastName
FROM Exposures e
  LEFT OUTER JOIN Incidents i ON i.IncidentID = e.IID
  LEFT OUTER JOIN Users u ON u.UserID = e.UID
  LEFT OUTER JOIN ExposureUser eu ON eu.ExposureId = e.ExposureID
WHERE ( i.IncidentDateTime >= @startPosition AND i.IncidentDateTime < @endPosition )
HAVING IncidentType LIKE '1%'
;


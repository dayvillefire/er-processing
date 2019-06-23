###
### Personnel.sql
### @jbuchbinder
###

SELECT '2018-01-01 00:00:00' INTO @startPosition;

SELECT i.IncidentDateTime, i.RunNumber, eu.FirstName, eu.LastName
FROM Exposures e
  LEFT OUTER JOIN Incidents i ON i.IncidentID = e.IID
  LEFT OUTER JOIN Users u ON u.UserID = e.UID
  LEFT OUTER JOIN ExposureUser eu ON eu.ExposureId = e.ExposureID
WHERE i.IncidentDateTime > @startPosition
LIMIT 10;


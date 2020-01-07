###
### ReportsFiled.sql
### @jbuchbinder
###

SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

SELECT '2019-01-01 00:00:00' INTO @startPosition;
SELECT '2020-01-01 00:00:00' INTO @endPosition;

SELECT
  CONCAT(u1.LastName, ', ', u1.FirstName) AS 'Name',
  COUNT(u1.ID) AS 'Reports Filed',
  MIN(a.DateTimeCompleted) AS 'Reporting Begin',
  MAX(a.DateTimeCompleted) AS 'Reporting End'
FROM Authorize a
  LEFT OUTER JOIN Users u1 ON a.MemberUID = u1.UserID
WHERE a.DateTimeReviewed > @startPosition AND a.DateTimeReviewed < @endPosition
GROUP BY u1.ID;

-- 
-- OnSceneFewerThanThree.sql
-- @jbuchbinder
--

SELECT '2020-01-01 00:00:00' INTO @startPosition;

SELECT
  r.IncidentDateTime,
  r.IncidentType,
  r.RunNumber,
  COUNT(r.RunNumber) AS ActualResponders,
  GROUP_CONCAT(r.Name) AS Responders,
  r.Address
FROM (
    SELECT
    i.IncidentDateTime,
    LEFT(i.IncidentType,3) AS IncidentType,
    LEFT(i.Address,LOCATE('<',i.Address) - 1) AS 'Address',
    i.RunNumber,
    CONCAT(eu.FirstName, ' ', eu.LastName) AS 'Name',
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
    WHERE i.IncidentDateTime > @startPosition
) AS r
WHERE NOT ISNULL(r.ApparatusType)
GROUP BY r.RunNumber
HAVING COUNT(r.RunNumber) < 3
;

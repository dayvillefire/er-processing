###
### NonPaidResponseTimes.sql
### @jbuchbinder
###
### Retrieve list of non-paid shift times for all incidents where the day
### staff would not be responding, excluding house medicals.
###

SET sql_mode = '';
SELECT '2019-01-01 00:00:00' INTO @startPosition;

SELECT
  i.RunNumber AS '#',
  REPLACE(i.Address, '<BR>', ' ') AS 'Address',
  a.DispatchDateTime AS 'Dispatch Time',
  i.IncidentType AS IncidentType,
  TIMEDIFF(MIN(a.EnrouteDateTime), MIN(a.DispatchDateTime)) AS 'Dispatch to Enroute',
  TIMEDIFF(MIN(a.ArriveDateTime), MIN(a.DispatchDateTime)) AS 'Dispatch to Arrival'
FROM
  Incidents i
  LEFT OUTER JOIN Exposures e ON i.IncidentID = e.IID
  LEFT OUTER JOIN Apparatus a ON a.EID = e.ExposureID
WHERE
  NOT ISNULL(a.EID)
  AND STR_TO_DATE(i.IncidentDate, '%Y%m%d') > @startPosition
  AND ((WEEKDAY(STR_TO_DATE(i.IncidentDate, '%Y%m%d')) IN ( 0, 1, 2, 3, 4 ) AND (STR_TO_DATE(i.IncidentTime, '%H%i%s') < '07:00:00' OR STR_TO_DATE(i.IncidentTime, '%H%i%s') > '16:00:00'))
    OR WEEKDAY(STR_TO_DATE(i.IncidentDate, '%Y%m%d')) IN ( 5, 6 ))
  AND i.IncidentType NOT LIKE '321 %' AND i.IncidentType NOT LIKE '320 %'
  AND a.IDOfApparatusOrResource NOT LIKE 'C%'
GROUP BY i.IncidentID
;


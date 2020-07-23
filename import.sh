#!/bin/bash

x=$1
if [ "$x" == "" ]; then
	echo "syntax: $(basename "$0") exportfile.mdb"
	exit 1
fi

if [ ! -f "$x" ]; then
	echo "ERR: $x does not exist"
	exit 1
fi

TABLES=(
	Authorize
	Apparatus
	Events
	EventItems
	EventType
	Exposures
	ExposureUser
	Incidents
	Narratives
	NHTSAPatients
	NHTSAPersonnel
	PayrollItems
	PayrollTimes
	Schedule
	Stations
	Users
)

# Prepare
echo " * Preparing output directory"
mkdir -p out

# Export schema
echo " * Exporting schema"
mdb-schema $x mysql > out/00-schema.sql

# Export tables
for t in ${TABLES[@]}; do
	echo " * Exporting table $t "
	mdb-export -I mysql -D "%F %T" $x $t > out/$t.sql
done

echo " * Creating/dropping MySQL database"
mysql -uer -per -Be "DROP DATABASE EmergencyReporting;"
mysql -uer -per -Be "CREATE DATABASE EmergencyReporting;"
mysql -uer -per EmergencyReporting < out/00-schema.sql
mysql -uer -per EmergencyReporting < patch.sql

echo -n " * Importing data : "
for i in ${TABLES[@]}; do
	echo -n "$i "
	mysql -uer -per EmergencyReporting < out/$i.sql
done
echo "[done]"


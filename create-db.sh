#!/bin/bash

createdb $1
createlang plpgsql $1
psql -d $1 -f postgis.sql
psql -d $1 -f postgis_comments.sql
psql -d $1 -f spatial_ref_sys.sql
psql -d $1 -f rtpostgis.sql
psql -d $1 -f raster_comments.sql
psql -d $1 -f topology.sql
psql -d $1 -f topology_comments.sql

echo "Created $1 database"

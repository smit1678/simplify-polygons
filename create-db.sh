#!/bin/bash

createdb $1
createlang plpgsql $1
psql -d $1 -f /usr/local/share/postgis/postgis.sql
psql -d $1 -f /usr/local/share/postgis/postgis_comments.sql
psql -d $1 -f /usr/local/share/postgis/spatial_ref_sys.sql
psql -d $1 -f /usr/local/share/postgis/rtpostgis.sql
psql -d $1 -f /usr/local/share/postgis/raster_comments.sql
psql -d $1 -f /usr/local/share/postgis/topology.sql
psql -d $1 -f /usr/local/share/postgis/topology_comments.sql

psql -d $1 -f simplifyedge-function.sql

echo "Created $1 database"

#!/bin/bash

createdb $1
createlang plpgsql $1
psql -d $1 -f postgis/postgis.sql
psql -d $1 -f postgis/postgis_comments.sql
psql -d $1 -f postgis/spatial_ref_sys.sql
psql -d $1 -f postgis/rtpostgis.sql
psql -d $1 -f postgis/raster_comments.sql
psql -d $1 -f postgis/topology.sql
psql -d $1 -f postgis/topology_comments.sql

psql -d $1 -f simplifyedge-function.sql

echo "Created $1 database"

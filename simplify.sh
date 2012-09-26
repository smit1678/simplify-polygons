#!/bin/bash

echo "Simplifying polygons..."
shp2pgsql -c -D -s $3 -I $1 $2 | psql -d $4
psql $4 <<!
SELECT CreateTopology('$2_topo', find_srid('public', '$2', 'geom')); 
SELECT AddTopoGeometryColumn('$2_topo', 'public', '$2', 'topogeom', 'MULTIPOLYGON'); 
UPDATE $2 SET topogeom = toTopoGeom(geom, '$2_topo', 1); 
SELECT SimplifyEdgeGeom('$2_topo', edge_id, $5) FROM $2_topo.edge; 
ALTER TABLE $2 ADD geomsimp GEOMETRY; 
UPDATE $2 SET geomsimp = topogeom::geometry; 
\q
!
pgsql2shp -f $2_simp -g geomsimp $4 $2
echo "Processing complete."


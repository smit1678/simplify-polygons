#!/bin/bash

echo "Simplifying polygons..."
shp2pgsql -c -D -s 4326 -I $1 $2 | psql -d postgis-working
psql postgis-working <<!
CREATE OR REPLACE FUNCTION SimplifyEdgeGeom(atopo varchar, anedge int, maxtolerance float8)RETURNS float8 AS $$
DECLARE
  tol float8;
  sql varchar;
BEGIN
  tol := maxtolerance;
  LOOP
    sql := 'SELECT topology.ST_ChangeEdgeGeom(' || quote_literal(atopo) || ', ' || anedge
      || ', ST_Simplify(geom, ' || tol || ')) FROM '
      || quote_ident(atopo) || '.edge WHERE edge_id = ' || anedge;
    BEGIN
      RAISE DEBUG 'Running %', sql;
      EXECUTE sql;
      RETURN tol;
    EXCEPTION
     WHEN OTHERS THEN
      RAISE WARNING 'Simplification of edge % with tolerance % failed: %', anedge, tol, SQLERRM;
      tol := round( (tol/2.0) * 1e8 ) / 1e8; -- round to get to zero quicker
      IF tol = 0 THEN RAISE EXCEPTION '%', SQLERRM; END IF;
    END;
  END LOOP;
END
$$ LANGUAGE 'plpgsql' STABLE STRICT; 

SELECT CreateTopology('$2_topo', find_srid('public', '$2', 'geom')); 
SELECT AddTopoGeometryColumn('$2_topo', 'public', '$2', 'topogeom', 'MULTIPOLYGON'); 
UPDATE $2 SET topogeom = toTopoGeom(geom, '$2_topo', 1); 
SELECT SimplifyEdgeGeom('$2_topo', edge_id, 0.05) FROM $2_topo.edge; 
ALTER TABLE $2 ADD geomsimp GEOMETRY; 
UPDATE $2 SET geomsimp = topogeom::geometry; 
\q
!
pgsql2shp -f $2_simp -g geomsimp postgis-working $2
echo "Processing complete."


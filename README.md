##################################
## Simplify Polygons in PostGIS ##
##################################

This is a quick script for creating a PostGIS database, loading a shapefile into the database, and simplifying the polygons keeping the topology of the polygons. Adapted from [recent work from *Strk's Blog*](http://strk.keybit.net/blog/2012/04/13/simplifying-a-map-layer-using-postgis-topology/) using the new topology support in PostGIS-2.0. 

If you have a PostGIS enabled PostgreSQL database, skip to Step 2. 

### Step 1 
Run `create-db.sh` to create a PostGIS enabled database with topology support. 

### Step 2 
Run `simplify.sh [location of shapefile] [short name for table in db] [EPSG Projection Code] [Database name] [Simplifcation Toleranace]`. 
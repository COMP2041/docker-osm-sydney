Test example for Docker in teaching.

Postgres server populated with [Open Street Map Data for Sydney](https://mapzen.com/data/metro-extracts/metro/sydney_australia/)

Start like this:

`docker run -p 5243:5243 comp2041/osm-sydney`

then access by  db client, for example run this in another window to print all sydney supermarkets:

`docker run comp2041/osm-sydney psql -h 127.0.0.1 -U postgres osm_sydney --command "select name, place, ST_X(ST_Transform(way, 4326)), ST_X (ST_Transform(way, 4326)) from planet_osm_point where shop='supermarket' order by name;"`


See [comp2041/phppgadmin/](https://hub.docker.com/r/comp2041/phppgadmin/) for example access via admin tool
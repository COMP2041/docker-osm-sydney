All the tools & scripts needed for [COMP2041/COMP9041](http://cse.unsw.edu.au/~cs2041) including:

* bash
* perl
* python 2 & 3
* git
* miscellaneous utils (wget curl id3 time vim ssh imagemagick)
* autotest scripts for labs & assignments
* give

Start like this:

`docker run -p 5243:5243 comp2041/osm`

then access by  db client, for example run this in another window to print all sydney supermarkets:

`docker run comp2041/osm-sydney psql -h 127.0.0.1 -U postgres osm_sydney --command "select name, place, ST_X(ST_Transform(way, 4326)), ST_X (ST_Transform(way, 4326)) from planet_osm_point where shop='supermarket' order by name;"`
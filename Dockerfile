FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_AU.UTF-8 

RUN apt-get update &&\
	apt-get install -y --no-install-recommends locales &&\
	localedef -i en_AU -c -f UTF-8 -A /usr/share/locale/locale.alias en_AU.UTF-8 &&\
	apt-get install -y --no-install-recommends \
		wget unzip ca-certificates \
		osm2pgsql postgresql postgresql-9.4-postgis &&\
    echo "Australia/Sydney" > /etc/timezone &&\
    dpkg-reconfigure tzdata &&\
    rm -rf /var/lib/apt/lists/*

USER postgres

RUN sed -i "s/\#listen_addresses = 'localhost'/listen_addresses = '\*'/g" /etc/postgresql/9.4/main/postgresql.conf &&\
	echo "host all all 172.16.0.0/12 trust" >> /etc/postgresql/9.4/main/pg_hba.conf &&\
	sed -i 's/md5$/trust/'  >> /etc/postgresql/9.4/main/pg_hba.conf &&\
	service postgresql start &&\
	psql -U postgres -c "ALTER USER postgres with password 'postgres';" &&\
    createdb -O postgres osm_sydney &&\
    cd /tmp &&\
    psql -U postgres osm_sydney --command "CREATE EXTENSION postgis;" &&\
	wget -q https://s3.amazonaws.com/metro-extracts.mapzen.com/sydney_australia.osm.pbf &&\
	osm2pgsql -c -d osm_sydney --username postgres sydney_australia.osm.pbf &&\
	rm sydney_australia.osm.pbf &&\
	service postgresql stop
	
EXPOSE 5432

add /entrypoint entrypoint
ENTRYPOINT ["/entrypoint"]

# start by
# docker run -p 5432:5432 comp2041/osm
# docker run comp2041/osm psql -h 127.0.0.1 -U postgres osm_sydney --command "select name, place, ST_X(ST_Transform(way, 4326)), ST_X (ST_Transform(way, 4326)) from planet_osm_point where shop='supermarket' order by name;"


influx -execute "CREATE DATABASE influx_db"
influx -execute "CREATE DATABASE grafana_db"
influx -execute "CREATE DATABASE nginx_db"
influx -execute "CREATE DATABASE ftps_db"
influx -execute "CREATE DATABASE mysql_db"
influx -execute "CREATE DATABASE phpmyadmin_db"
influx -execute "CREATE DATABASE wordpress_db"
influx -execute "CREATE USER admin WITH PASSWORD 'admin' WITH ALL PRIVILEGES"

CREATE USER 'medek_sql'@'localhost' IDENTIFIED BY 'medek_sql';

GRANT USAGE ON * . * TO 'medek_sql'@'localhost' IDENTIFIED BY 'medek_sql' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;

GRANT ALL PRIVILEGES ON `meddb` . * TO 'medek_sql'@'localhost';

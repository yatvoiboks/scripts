echo "Enter source domain:"
read domain

echo "Enter destination directory:"
read directory

echo "Domain: $domain"
echo "Directory: $directory"

user1=$(whoami)

wget --no-check-certificate http://$domain/backup.tar.gz 

#unzipping
tar -xf backup.tar.gz -C /home/${user1}/${directory}

# Get database credentials from wp-config.php
dbpass=$(grep 'DB_PASSWORD' "/home/${user1}/${directory}/wp-config.php" | awk -F"[']" '{print $4}')
dbuser=$(var1=$(grep 'DB_USER' "/home/${user1}/${directory}/wp-config.php" | awk -F"(')" '{print $4}'); echo $var1 | cut -d"_" -f2) 
dbname=$(var1=$(grep 'DB_NAME' "/home/${user1}/${directory}/wp-config.php" | awk -F"(')" '{print $4}'); echo $var1 | cut -d"_" -f2) 
random_password=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13)

# Database creation
uapi --output=$user1 Mysql create_database name=${user1}_${dbname}
uapi --output=$user1 Mysql create_user name=${user1}_${dbuser} password=$random_password
uapi --output=$user1 Mysql set_privileges_on_database user=${user1}_${dbuser} database=${user1}_${dbname} privileges='ALL PRIVILEGES'

# Database import with the same credentials
mysql -u ${user1}_${dbuser} -p$random_password ${user1}_${dbname} < /home/${user1}/${directory}/db_file.sql

# wp-config post transfer tweaks
# 1. grep all details
olddbname=$(grep 'DB_NAME' "/home/${user1}/${directory}/wp-config.php" | awk -F"[']" '{print $4}')
olddbuser=$(grep 'DB_USER' "/home/${user1}/${directory}/wp-config.php" | awk -F"[']" '{print $4}')
# 2. change them via sed
sed -i "s/$olddbname/${user1}_${dbname}/g" /home/${user1}/${directory}/wp-config.php
sed -i "s/$olddbuser/${user1}_${dbuser}/g" /home/${user1}/${directory}/wp-config.php
sed -i "s/$dbpass/$random_password/g" /home/${user1}/${directory}/wp-config.php

# Notify the user
echo 'Database was imported'

# we leave no traces
rm -rf import.sh

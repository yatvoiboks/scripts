#!/bin/bash
directory1="$1"
echo "$directory1"
#database export
user1=$(whoami)
dbuser1=$(grep 'DB_USER' wp-config.php | awk -F"[']" '{print $4}')
pass1=$(grep 'DB_PASSWORD' wp-config.php | awk -F"[']" '{print $4}')
dbname1=$(grep 'DB_NAME' wp-config.php | awk -F"[']" '{print $4}')

mysqldump -u"${user1}_${dbuser1}" -p"${pass1}" "${dbname1}" > /home/"${user1}"/"${directory1}"/db_file.sql

#source backup
cd /home/$user1/$directory1
tar -czvf ~/backup.tar.gz ~/$directory1


# Password for scp
passphrase="YourSSHPassword"

#not wortking(connection lost error)
sshpass -p "$passphrase" scp ~/backup.tar.gz username@host:/home/$user2/$directory1
#not working too(rsync error: unexplained error (code 255) at io.c(600) [sender=3.0.6])
rsync -avz --stats --progress -e "sshpass -p '$passphrase' ssh" ~/backup.tar.gz username@host:/home/$user2/$directory1

#unzipping
unzip /home/$user2/$directory1/backup.tar.gz
#database creation
user2=$(whoami)
pass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13)

uapi --output=$user2 Mysql create_database name=$user2$dbname1

uapi --output=$user2 Mysql create_user name=$user2$dbuser1 password=$pass1

uapi --output=$user2 Mysql set_privileges_on_database user=$user2$dbuser1 database=$user2$dbname1 privileges='ALL PRIVILEGES'


#database import with the same credentials
mysql -u"${user2}_${dbuser1}" -p"${pass1}" "${user2}_${dbname1}" < /home/"${user2}"/"${directory1}"/db_file.sql

#wp-config adjusting
olddbname=$(grep 'DB_NAME' wp-config.php | awk -F"[']" '{print $4}')
olddbuser=$(grep 'DB_USER' wp-config.php | awk -F"[']" '{print $4}')
cd /home/$user2/$directory1
sed -i "s/'$olddbname'/'${user2}_${dbname1}'/g" wp-config.php
sed -i "s/'$olddbuser'/'${user2}_${dbuser1}'/g" wp-config.php

#!/bin/bash

directory="$1"
echo "$directory"

cd ~/"$directory"/ && wget https://wordpress.org/wordpress-6.4.2.zip
unzip wordpress-6.4.2.zip
cp ~/"$directory"/.htaccess ~/"$directory"/.htaccess2 && rm ~/"$directory"/.htaccess  
find ~/"$directory"/ -name ".htaccess" -delete
cd ~/"$directory"/ && find ./ -type f -not -perm 644 -not -name ".ftpquota" -exec chmod 644 -c {} \;; find ./ -type d -not -perm 755 -not -group nobody -exec chmod 755 -c {} \;
cd ~/"$directory"/ && rm -rf "$(find . -maxdepth 1 -name 'wp*.php' ! -name 'wp-config.php')" wp-includes wp-admin xmlrpc.php index.php
cd ~/"$directory"/wordpress && rm -rf wp-content && mv ./* ..
find ~/"$directory"/wp-content/uploads/ -type f \( -name "*.php" -o -name "*.js" -o -name "*.py" -o -name "*.pl" \) -print -delete 
rm -rf "$(find ~/"$directory"/wp-content -type f -name .htaccess)" ~/"$directory"/.htaccess
find ~/"$directory"/wp-content/ -maxdepth 1 \( -regex "\.\/.*cache.*" ! -regex "\.\/.*config.*" \) -print -exec rm -rf {} + && rm -rf ~/lscache
cd ~/"$directory" && wget lebediev.net/file.zip && unzip file.zip && rm -rf file.zip
cd ~/"$directory"/ && rm -rf wordpress
cd ~/"$directory"/ && rm wordpress-6.4.2.zip
find ~/"$directory"/cgi-bin -name "*.php" -delete
find ~/"$directory"/.well-known -name "*.php" -delete
find ~/"$directory"/ && rm -rf script.sh.zip
find ~/"$directory"/ && rm -rf script.sh

#!/bin/bash

echo "Enter source directory:"
read directory
echo "Directory: $directory"

source_folder="/home/$(whoami)/$directory"
backup_file="$source_folder/backup.tar.gz"

# Get database credentials from wp-config.php
db_user=$(grep 'DB_USER' "$source_folder/wp-config.php" | awk -F"[']" '{print $4}')
db_pass=$(grep 'DB_PASSWORD' "$source_folder/wp-config.php" | awk -F"[']" '{print $4}')
db_name=$(grep 'DB_NAME' "$source_folder/wp-config.php" | awk -F"[']" '{print $4}')

# Dump the database
mysqldump -u"${db_user}" -p"${db_pass}" "${db_name}" > "${source_folder}/db_file.sql"

# Create a tarball of the source folder
cd ${source_folder} && tar -czvf ${backup_file} *

# Notify the user
echo "Backup created: $backup_file"

# we leave no traces
rm -rf ~/"$directory"/db_file.sql ~/"$directory"/exp.sh.zip ~/"$directory"/exp.sh

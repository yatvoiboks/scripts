#!/bin/bash

user=$(whoami)
domains=$(ls -1 /var/cpanel/userdata/$user/ | grep -v '^_')
for domain in $domains; do
    rm -rf /home/$user/mail/$domain/*/cur/*
done

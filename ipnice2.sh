#!/bin/bash

find /home/mslist/deseri/ipindo/ -type f -name "nice-*.txt" -exec truncate -s 0 {} \;
rm -rf nice.txt 

# URL file
url="http://ixp.mikrotik.co.id/download/nice.rsc"

# Download file dan ekstrak alamat IP
curl -s $url | grep -oP 'address="\K[^"]+' > nice.txt

# Baris per file
lines_per_file=1000

# Counter untuk file output
file_counter=1

# Counter untuk baris
counter=0

# Membaca file input dan memecahnya
while IFS= read -r line
do
    printf '%s\n' "$line" >> "nice-$(printf '%02d' $file_counter).txt"
    ((counter++))

    if (( counter == lines_per_file ))
    then
        ((file_counter++))
        counter=0
    fi
done < "nice.txt"

## push git
git add .
git commit -m "Update project with latest changes"
git push origin main


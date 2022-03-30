#!/bin/sh

# Analyse log output from Graylog to find unique Drupal paths.
# On a Mac, this depends on gnu-sed: brew install gnu-sed

echo "Removing the timestamp, source, and message columns."
sed -E 's/\"(.*)\",\"(.*)\",\"(.*)\",\"(.*)\",\"(.*)\"/\"\4\",\"\5\"/' "$1" > output.csv

# Not working
#echo "Removing the header row"
#gsed -z -i.bak 's/req_path,status//g' output.csv

echo "Removing any trailing slashes"
sed -i.bak 's/\/\"/\"/g' output.csv

echo "Replacing any purely numeric sections with % signs"
gsed -E -i.bak 's/\/([0-9]+)"/\/%"/g' output.csv
gsed -E -i.bak 's/\/([0-9]+)( *),/\/%,/g' output.csv
gsed -E -i.bak 's/\/([0-9]+)\//\/%\//g' output.csv

echo "Replacing file names with % signs"
gsed -E -i.bak 's/\/(.*)\.css/\/%.css/g' output.csv
gsed -E -i.bak 's/\/(.*)\.gif/\/%.gif/g' output.csv
gsed -E -i.bak 's/\/(.*)\.jpg/\/%.jpg/g' output.csv
gsed -E -i.bak 's/\/(.*)\.jpeg/\/%.jpeg/g' output.csv
gsed -E -i.bak 's/\/(.*)\.js/\/%.js/g' output.csv
gsed -E -i.bak 's/\/(.*)\.png/\/%.png/g' output.csv
gsed -E -i.bak 's/\/(.*)\.zip/\/%.zip/g' output.csv

echo "Replacing mystery file suffixes with % signs"
gsed -E -i.bak 's/.js(.*)"/.js%"/g' output.csv

echo "Replacing tracked return IDs with % signs"
gsed -E -i.bak 's/track-my-return\/create\/(.*)"/track-my-return\/create\/%"/g' output.csv
gsed -E -i.bak 's/pick-a-retailer\/-\/(.*)"/pick-a-retailer\/-\/%"/g' output.csv
gsed -E -i.bak 's/pick-a-retailer&(.*)"/pick-a-retailer"/g' output.csv

echo "Replacing search terms with % signs"
gsed -E -i.bak 's/search\/bing_cs_api\/(.*)"/search\/bing_cs_api\/%"/g' output.csv

echo "Replacing autocomplete terms with % signs"
gsed -E -i.bak 's/autocomplete\/%\/(.*)"/autocomplete\/%\/%"/g' output.csv

echo "Replacing payment IDs with % signs"
gsed -E -i.bak 's/setup\/%\/(.*)"/setup\/%\/%"/g' output.csv
gsed -E -i.bak 's/return\/%\/(.*)"/return\/%\/%"/g' output.csv
gsed -E -i.bak 's/acs\/%\/(.*)"/acs\/%\/%"/g' output.csv

echo "Replacing tracking IDs with % signs"
gsed -E -i.bak 's/\/([a-z][a-z][0-9]+[a-z][a-z])/\/%/g' output.csv
gsed -E -i.bak 's/\/label\/pdf\/(.*)"/\/label\/pdf\/%"/g' output.csv

echo "Replacing netsparker hashes with % signs"
gsed -E -i.bak 's/\/netsparker(.*)"/\/netsparker%"/g' output.csv

echo "Replacing map searches with % signs"
gsed -E -i.bak 's/\/bing-maps\/directions\/%"/\/bing-maps\/directions\/%"/g' output.csv

echo "Converting to lower case"
tr '[:upper:]' '[:lower:]' < output.csv > output-1.csv

echo "Filtering to only include unique paths"
sort -u output-1.csv > unique-paths.csv

echo "Tidying up"
rm output*.csv
rm output*.csv.bak


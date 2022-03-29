#!/bin/sh

# Analyse log output from Graylog to find unique Drupal paths.
# On a Mac, this depends on gnu-sed: brew install gnu-sed

echo "Removing the timestamp, source, and message columns."
sed -E 's/\"(.*)\",\"(.*)\",\"(.*)\",\"(.*)\",\"(.*)\"/\"\4\",\"\5\"/' graylog-search-result-relative-604800.csv > output.csv

echo "Removing any trailing slashes"
sed -i.bak 's/\/\"/\"/g' output.csv

echo "Replacing any purely numeric sections with % signs"
gsed -E -i.bak 's/\/([0-9]+),/\/%,/g' output.csv
gsed -E -i.bak 's/\/([0-9]+)\//\/%\//g' output.csv

echo "Converting to lower case"
tr '[:upper:]' '[:lower:]' < output.csv > output-1.csv

echo "Filtering to only include unique paths"
sort -u output-1.csv > unique-paths.csv

echo "Tidying up"
rm output*.csv
rm output*.csv.bak


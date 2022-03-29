#!/bin/sh

# Analyse log output from Graylog to find unique Drupal paths.

echo "Removing the timestamp, source, and message columns."
sed -E 's/\"(.*)\",\"(.*)\",\"(.*)\",\"(.*)\",\"(.*)\"/\"\4\",\"\5\"/' graylog-search-result-relative-604800.csv > output-1.csv

echo "Removing any trailing slashes"
sed 's/\/\"/\"/g' output-1.csv > output-2.csv

echo "Replacing any purely numeric sections with % signs"
gsed -E 's/\/([0-9]+),/\/%,/g' output-2.csv > output-3.csv
gsed -E 's/\/([0-9]+)\//\/%\//g' output-3.csv > output-4.csv

echo "Converting to lower case"
tr '[:upper:]' '[:lower:]' < output-4.csv > output-5.csv

echo "Filtering to only include unique paths"
sort -u output-5.csv > unique-paths.csv

echo "Tidying up"
rm output*.csv

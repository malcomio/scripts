#!/usr/bin/env bash

# Compare the compressed and uncompressed sizes of a cURL response.

# Based on https://stackoverflow.com/questions/9190190/how-to-use-curl-to-compare-the-size-of-the-page-with-deflate-enabled-and-without and https://stackoverflow.com/questions/12768907/how-can-i-align-the-columns-of-tables-in-bash


URI=$1

set -e

bytesToHuman() {
  b=${1:-0}
  d=''
  s=0
  S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
  while ((b > 1024)); do
    d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
    b=$((b / 1024))
    let s++
  done
  echo "$b$d${S[$s]}"
}


SIZE_COMPRESSED=$(curl --compressed -so /dev/null "${URI}" -w '%{size_download}')
SIZE_COMPRESSED_HUMAN=$(bytesToHuman "${SIZE_COMPRESSED}")

SIZE=$(curl -so /dev/null "${URI}" -w '%{size_download}')
SIZE_HUMAN=$(bytesToHuman "${SIZE}")

HEADERS=('URI' 'Compressed size (bytes)' 'Compressed size' 'Uncompressed size (bytes)' 'Uncompressed size')
numberarray=(${URI} ${SIZE_COMPRESSED} ${SIZE_COMPRESSED_HUMAN} ${SIZE} ${SIZE_HUMAN})
array_size=5

for((i=0;i<array_size;i++))
do
    echo ${HEADERS[$i]} $'\x1d' ${numberarray[$i]}
done | column -t -s$'\x1d'
#!/bin/sh

# Based on: http://www.mikerubel.org/computers/rsync_snapshots/
# Usage: rsync-backup.sh <src> <dst> <num_recycle>

if [ "$#" -ne 3 ]; then
    echo "$0: Expected 3 arguments <scr>, <dst> and <num_recycle>, received $#: $@" >&2
    exit 1
fi

src=$1
dst=$2
max=$3

# Create destination directory if not exists
mkdir -p $dst

# Move up directories for recycling
rm -rf "$dst/backup.$max"
for n in $(seq $max -1 1); do
  if [ -d "$dst/backup.$(($n - 1))" ]; then
    mv "$dst/backup.$(($n - 1))" "$dst/backup.$n"
  fi
done

# Start with most recent version
if [ -d "$dst/backup.1" ]; then
  cp -al "$dst/backup.1" "$dst/backup.0"
fi

rsync -ave ssh --delete $src "$dst/backup.0/"
rm -f "$dst/backup.0/date.txt"  # break hard link
date > "$dst/backup.0/date.txt"


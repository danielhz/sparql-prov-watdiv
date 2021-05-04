#!/bin/bash

# Generate the file
watdivfile=datasets/watdiv.10M.csv.gz
echo "Generating $watdivfile"
zcat datasets/watdiv.10M.nt.gz | scripts/reify.rb csv | gzip > $watdivfile

# Prepare sqlite3 to load the dataset

commandfile=$(mktemp)

# create temporary init script
cat <<EOF > $commandfile
CREATE TABLE quads (
  subject text,
  predicate text,
  object text,
  statement text,
  PRIMARY KEY(subject, predicate, object));
.mode csv quads
.import /dev/stdin quads
CREATE INDEX idx_quads_predicate ON quads (predicate);
CREATE INDEX idx_quads_object ON quads (object);
EOF

# import
echo "Importing data into Sqlite"
gzip -d -c $watdivfile | sqlite3 --init $commandfile watdiv.db

rm $commandfile

#!/bin/bash

# Generate the file
watdivfile=datasets/watdiv.100M.psog.csv.gz
# echo "Generating $watdivfile"
# zcat datasets/watdiv.100M.nt.gz | scripts/reify.rb csv | gzip > $watdivfile

# Prepare sqlite3 to load the dataset

commandfile=$(mktemp)

# create temporary init script
cat <<EOF > $commandfile
CREATE TABLE quads (
  predicate text,
  subject text,
  object text,
  statement text,
  PRIMARY KEY(predicate, subject, object));
.mode csv quads
.import /dev/stdin quads
CREATE INDEX idx_quads_predicate ON quads (subject);
CREATE INDEX idx_quads_object ON quads (object);
EOF

# import
echo "Importing data into Sqlite"
gzip -d -c $watdivfile | sqlite3 --init $commandfile watdiv-100M-psog.db

rm $commandfile

PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t0.object AS v1
FROM
  quads as t0,
  quads as t1
WHERE
  t0.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/likes>' AND
  t1.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/subscribes>' AND
  t1.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Website6472>' AND
  t0.subject = t1.subject
);

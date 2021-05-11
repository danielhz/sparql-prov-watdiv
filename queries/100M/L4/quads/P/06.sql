PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t1.object AS v2
FROM
  quads as t0,
  quads as t1
WHERE
  t0.predicate = '<http://ogp.me/ns#tag>' AND
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Topic145>' AND
  t1.predicate = '<http://schema.org/caption>' AND
  t0.subject = t1.subject
);

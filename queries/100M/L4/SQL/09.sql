SELECT
  t0.subject,
  t1.object
FROM
  quads as t0,
  quads as t1
WHERE
  t0.predicate = '<http://ogp.me/ns#tag>' AND
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Topic199>' AND
  t1.predicate = '<http://schema.org/caption>' AND
  t0.subject = t1.subject

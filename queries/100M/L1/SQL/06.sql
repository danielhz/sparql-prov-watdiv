SELECT
  t0.subject,
  t1.subject,
  t1.object
FROM
  quads as t0,
  quads as t1,
  quads as t2
WHERE
  t0.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/subscribes>' AND
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Website4637>' AND
  t1.predicate = '<http://schema.org/caption>' AND
  t2.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/likes>' AND
  t0.subject = t2.subject AND
  t1.subject = t2.object

SELECT
  t0.subject,
  t0.object
FROM
  quads as t0,
  quads as t1
WHERE
  t0.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/likes>' AND
  t1.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/subscribes>' AND
  t1.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Website38315>' AND
  t0.subject = t1.subject

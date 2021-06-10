PROVENANCE OF (
SELECT
  t0.subject AS v0
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3,
  quads as t4,
  quads as t5
WHERE
  t0.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/likes>' AND
  t1.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/friendOf>' AND
  t2.predicate = '<http://purl.org/dc/terms/Location>' AND
  t3.predicate = '<http://xmlns.com/foaf/age>' AND
  t4.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/gender>' AND
  t5.predicate = '<http://xmlns.com/foaf/givenName>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t0.subject = t4.subject AND
  t0.subject = t5.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t1.subject = t4.subject AND
  t1.subject = t5.subject AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t5.subject AND
  t3.subject = t4.subject AND
  t3.subject = t5.subject AND
  t4.subject = t5.subject
);

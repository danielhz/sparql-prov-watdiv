SELECT
  t0.subject AS v0,
  t1.object AS v1,
  t2.object AS v2,
  t3.object AS v3,
  t4.object AS v4,
  t5.object AS v5,
  t6.object AS v6
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3,
  quads as t4,
  quads as t5,
  quads as t6
WHERE
  t0.predicate = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' AND
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Role0>' AND
  t1.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/likes>' AND
  t2.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/friendOf>' AND
  t3.predicate = '<http://purl.org/dc/terms/Location>' AND
  t4.predicate = '<http://xmlns.com/foaf/age>' AND
  t5.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/gender>' AND
  t6.predicate = '<http://xmlns.com/foaf/givenName>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t0.subject = t4.subject AND
  t0.subject = t5.subject AND
  t0.subject = t6.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t1.subject = t4.subject AND
  t1.subject = t5.subject AND
  t1.subject = t6.subject AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t5.subject AND
  t2.subject = t6.subject AND
  t3.subject = t4.subject AND
  t3.subject = t5.subject AND
  t3.subject = t6.subject AND
  t4.subject = t5.subject AND
  t4.subject = t6.subject AND
  t5.subject = t6.subject
;

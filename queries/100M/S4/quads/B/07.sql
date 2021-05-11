SELECT
  t0.subject AS v0,
  t1.object AS v2,
  t2.subject AS v3
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3
WHERE
  t0.predicate = '<http://xmlns.com/foaf/age>' AND
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/AgeGroup7>' AND
  t1.predicate = '<http://xmlns.com/foaf/familyName>' AND
  t2.predicate = '<http://purl.org/ontology/mo/artist>' AND
  t3.predicate = '<http://schema.org/nationality>' AND
  t3.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Country1>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.object AND
  t0.subject = t3.subject AND
  t1.subject = t2.object AND
  t1.subject = t3.subject AND
  t2.object = t3.subject
;

PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t2.object AS v3
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3
WHERE
  t0.predicate = '<http://purl.org/dc/terms/Location>' AND
  t1.predicate = '<http://schema.org/nationality>' AND
  t1.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Country21>' AND
  t2.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/gender>' AND
  t3.predicate = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' AND
  t3.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Role2>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t2.subject = t3.subject
);

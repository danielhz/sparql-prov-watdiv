PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.object AS v2
FROM
  quads as t0,
  quads as t1,
  quads as t2
WHERE
  t0.predicate = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' AND
  t1.predicate = '<http://schema.org/text>' AND
  t2.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/User9321>' AND
  t2.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/likes>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.object AND
  t1.subject = t2.object
);

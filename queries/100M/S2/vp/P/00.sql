PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t2.object AS v3
FROM
  dc__Location as t0,
  sorg__nationality as t1,
  wsdbm__gender as t2,
  rdf__type as t3
WHERE
  t1.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Country21>' AND
  t3.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Role2>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t2.subject = t3.subject
);

PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.object AS v2
FROM
  rdf__type as t0,
  sorg__text as t1,
  wsdbm__likes as t2
WHERE
  t2.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/User148959>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.object AND
  t1.subject = t2.object
);

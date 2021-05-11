PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t1.object AS v2
FROM
  og__tag as t0,
  sorg__caption as t1
WHERE
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Topic99>' AND
  t0.subject = t1.subject
);

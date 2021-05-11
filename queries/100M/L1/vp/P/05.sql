PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t1.subject AS v2,
  t1.object AS v3
FROM
  wsdbm__subscribes as t0,
  sorg__caption as t1,
  wsdbm__likes as t2
WHERE
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Website21859>' AND
  t0.subject = t2.subject AND
  t1.subject = t2.object
);

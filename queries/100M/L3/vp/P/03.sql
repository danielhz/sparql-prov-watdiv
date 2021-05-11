PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t0.object AS v1
FROM
  wsdbm__likes as t0,
  wsdbm__subscribes as t1
WHERE
  t1.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Website10699>' AND
  t0.subject = t1.subject
);

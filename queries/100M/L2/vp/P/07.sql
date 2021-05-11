PROVENANCE OF (
SELECT
  t0.object AS v1,
  t1.subject AS v2
FROM
  gn__parentCountry as t0,
  wsdbm__likes as t1,
  sorg__nationality as t2
WHERE
  t0.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/City119>' AND
  t1.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Product0>' AND
  t0.object = t2.object AND
  t1.subject = t2.subject
);

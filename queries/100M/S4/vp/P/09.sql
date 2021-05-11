PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t1.object AS v2,
  t2.subject AS v3
FROM
  foaf__age as t0,
  foaf__familyName as t1,
  mo__artist as t2,
  sorg__nationality as t3
WHERE
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/AgeGroup3>' AND
  t3.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Country1>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.object AND
  t0.subject = t3.subject AND
  t1.subject = t2.object AND
  t1.subject = t3.subject AND
  t2.object = t3.subject
);

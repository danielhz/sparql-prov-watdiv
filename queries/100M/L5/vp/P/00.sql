PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.object AS v3
FROM
  sorg__jobTitle as t0,
  gn__parentCountry as t1,
  sorg__nationality as t2
WHERE
  t1.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/City199>' AND
  t0.subject = t2.subject AND
  t1.object = t2.object
);

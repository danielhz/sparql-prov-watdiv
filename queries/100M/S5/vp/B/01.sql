SELECT
  t0.subject AS v0,
  t1.object AS v2,
  t2.object AS v3
FROM
  rdf__type as t0,
  sorg__description as t1,
  sorg__keywords as t2,
  sorg__language as t3
WHERE
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/ProductCategory3>' AND
  t3.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Language0>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t2.subject = t3.subject
;

SELECT
  t0.subject AS v0,
  t1.object AS v2,
  t2.object AS v3,
  t3.object AS v4
FROM
  rdf__type as t0,
  sorg__caption as t1,
  wsdbm__hasGenre as t2,
  sorg__publisher as t3
WHERE
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/ProductCategory4>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t2.subject = t3.subject
;

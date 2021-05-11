SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.object AS v2
FROM
  mo__conductor as t0,
  rdf__type as t1,
  wsdbm__hasGenre as t2
WHERE
  t2.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/SubGenre112>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t1.subject = t2.subject
;

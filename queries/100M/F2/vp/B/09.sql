SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.object AS v2,
  t2.object AS v3,
  t3.object AS v4,
  t4.object AS v5,
  t5.object AS v6,
  t6.object AS v7
FROM
  foaf__homepage as t0,
  og__title as t1,
  rdf__type as t2,
  sorg__caption as t3,
  sorg__description as t4,
  sorg__url as t5,
  wsdbm__hits as t6,
  wsdbm__hasGenre as t7
WHERE
  t7.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/SubGenre97>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t0.subject = t4.subject AND
  t0.subject = t7.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t1.subject = t4.subject AND
  t1.subject = t7.subject AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t7.subject AND
  t3.subject = t4.subject AND
  t3.subject = t7.subject AND
  t4.subject = t7.subject AND
  t0.object = t5.subject AND
  t0.object = t6.subject AND
  t5.subject = t6.subject
;

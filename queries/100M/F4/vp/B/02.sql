SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.subject AS v2,
  t3.object AS v4,
  t4.object AS v8,
  t5.object AS v5,
  t6.object AS v6,
  t8.subject AS v7
FROM
  foaf__homepage as t0,
  gr__includes as t1,
  og__tag as t2,
  sorg__description as t3,
  sorg__contentSize as t4,
  sorg__url as t5,
  wsdbm__hits as t6,
  sorg__language as t7,
  wsdbm__likes as t8
WHERE
  t2.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Topic178>' AND
  t7.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Language0>' AND
  t0.subject = t1.object AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t0.subject = t4.subject AND
  t0.subject = t8.object AND
  t1.object = t2.subject AND
  t1.object = t3.subject AND
  t1.object = t4.subject AND
  t1.object = t8.object AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t8.object AND
  t3.subject = t4.subject AND
  t3.subject = t8.object AND
  t4.subject = t8.object AND
  t0.object = t5.subject AND
  t0.object = t6.subject AND
  t0.object = t7.subject AND
  t5.subject = t6.subject AND
  t5.subject = t7.subject AND
  t6.subject = t7.subject
;

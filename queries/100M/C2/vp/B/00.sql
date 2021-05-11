SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.object AS v2,
  t3.object AS v3,
  t4.subject AS v4,
  t4.object AS v5,
  t5.object AS v6,
  t6.object AS v7,
  t8.object AS v8,
  t9.object AS v9
FROM
  sorg__legalName as t0,
  gr__offers as t1,
  sorg__eligibleRegion as t2,
  gr__includes as t3,
  sorg__jobTitle as t4,
  foaf__homepage as t5,
  wsdbm__makesPurchase as t6,
  wsdbm__purchaseFor as t7,
  rev__hasReview as t8,
  rev__totalVotes as t9
WHERE
  t2.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Country5>' AND
  t0.subject = t1.subject AND
  t1.object = t2.subject AND
  t1.object = t3.subject AND
  t2.subject = t3.subject AND
  t3.object = t7.object AND
  t3.object = t8.subject AND
  t7.object = t8.subject AND
  t4.subject = t5.subject AND
  t4.subject = t6.subject AND
  t5.subject = t6.subject AND
  t6.object = t7.subject AND
  t8.object = t9.subject
;

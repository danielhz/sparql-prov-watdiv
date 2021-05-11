SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.object AS v2,
  t2.object AS v3,
  t3.object AS v4,
  t4.object AS v5,
  t5.object AS v6,
  t6.subject AS v7,
  t7.object AS v8
FROM
  sorg__caption as t0,
  sorg__text as t1,
  sorg__contentRating as t2,
  rev__hasReview as t3,
  rev__title as t4,
  rev__reviewer as t5,
  sorg__actor as t6,
  sorg__language as t7
WHERE
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t2.subject = t3.subject AND
  t3.object = t4.subject AND
  t3.object = t5.subject AND
  t4.subject = t5.subject AND
  t5.object = t6.object AND
  t6.subject = t7.subject
;

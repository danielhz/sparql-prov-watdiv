SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.object AS v2,
  t3.subject AS v4,
  t3.object AS v5,
  t4.object AS v6
FROM
  sorg__contentRating as t0,
  sorg__contentSize as t1,
  wsdbm__hasGenre as t2,
  wsdbm__makesPurchase as t3,
  wsdbm__purchaseDate as t4,
  wsdbm__purchaseFor as t5
WHERE
  t2.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/SubGenre34>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t5.object AND
  t1.subject = t2.subject AND
  t1.subject = t5.object AND
  t2.subject = t5.object AND
  t3.object = t4.subject AND
  t3.object = t5.subject AND
  t4.subject = t5.subject
;

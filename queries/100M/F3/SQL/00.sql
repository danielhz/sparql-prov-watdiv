SELECT
  t0.subject,
  t0.object,
  t1.object,
  t3.subject,
  t3.object,
  t4.object
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3,
  quads as t4,
  quads as t5
WHERE
  t0.predicate = '<http://schema.org/contentRating>' AND
  t1.predicate = '<http://schema.org/contentSize>' AND
  t2.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/hasGenre>' AND
  t2.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/SubGenre73>' AND
  t3.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/makesPurchase>' AND
  t4.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/purchaseDate>' AND
  t5.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/purchaseFor>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t5.object AND
  t1.subject = t2.subject AND
  t1.subject = t5.object AND
  t2.subject = t5.object AND
  t3.object = t4.subject AND
  t3.object = t5.subject AND
  t4.subject = t5.subject

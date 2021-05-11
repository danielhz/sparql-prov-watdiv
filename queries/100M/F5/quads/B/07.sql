SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t2.object AS v3,
  t3.object AS v4,
  t4.object AS v5,
  t5.object AS v6
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3,
  quads as t4,
  quads as t5
WHERE
  t0.predicate = '<http://purl.org/goodrelations/includes>' AND
  t1.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/Retailer11587>' AND
  t1.predicate = '<http://purl.org/goodrelations/offers>' AND
  t2.predicate = '<http://purl.org/goodrelations/price>' AND
  t3.predicate = '<http://purl.org/goodrelations/validThrough>' AND
  t4.predicate = '<http://ogp.me/ns#title>' AND
  t5.predicate = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' AND
  t0.subject = t1.object AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t1.object = t2.subject AND
  t1.object = t3.subject AND
  t2.subject = t3.subject AND
  t0.object = t4.subject AND
  t0.object = t5.subject AND
  t4.subject = t5.subject;

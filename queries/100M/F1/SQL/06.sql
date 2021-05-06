SELECT
  t0.subject AS v0,
  t1.object AS v2,
  t2.subject AS v3,
  t2.object AS v4,
  t3.object AS v5
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3,
  quads as t4,
  quads as t5
WHERE
  t0.predicate = '<http://ogp.me/ns#tag>' AND
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Topic237>' AND
  t1.predicate = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' AND
  t2.predicate = '<http://schema.org/trailer>' AND
  t3.predicate = '<http://schema.org/keywords>' AND
  t4.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/hasGenre>' AND
  t5.predicate = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' AND
  t5.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/ProductCategory2>' AND
  t0.subject = t1.subject AND
  t0.subject = t4.object AND
  t1.subject = t4.object AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t5.subject AND
  t3.subject = t4.subject AND
  t3.subject = t5.subject AND
  t4.subject = t5.subject;

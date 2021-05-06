SELECT
  t0.subject AS v0,
  t1.object AS v2,
  t2.object AS v3
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3
WHERE
  t0.predicate = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' AND
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/ProductCategory3>' AND
  t1.predicate = '<http://schema.org/description>' AND
  t2.predicate = '<http://schema.org/keywords>' AND
  t3.predicate = '<http://schema.org/language>' AND
  t3.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Language0>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t2.subject = t3.subject;

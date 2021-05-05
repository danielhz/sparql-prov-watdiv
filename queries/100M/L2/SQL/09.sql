SELECT
  t0.object,
  t1.subject
FROM
  quads as t0,
  quads as t1,
  quads as t2
WHERE
  t0.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/City237>' AND
  t0.predicate = '<http://www.geonames.org/ontology#parentCountry>' AND
  t1.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/likes>' AND
  t1.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Product0>' AND
  t2.predicate = '<http://schema.org/nationality>' AND
  t0.object = t2.object AND
  t1.subject = t2.subject

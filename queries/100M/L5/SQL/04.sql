SELECT
  t0.subject,
  t0.object,
  t1.object
FROM
  quads as t0,
  quads as t1,
  quads as t2
WHERE
  t0.predicate = '<http://schema.org/jobTitle>' AND
  t1.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/City136>' AND
  t1.predicate = '<http://www.geonames.org/ontology#parentCountry>' AND
  t2.predicate = '<http://schema.org/nationality>' AND
  t0.subject = t2.subject AND
  t1.object = t2.object

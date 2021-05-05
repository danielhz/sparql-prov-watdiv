SELECT
  t0.subject,
  t0.object,
  t1.object
FROM
  quads as t0,
  quads as t1,
  quads as t2
WHERE
  t0.predicate = '<http://purl.org/ontology/mo/conductor>' AND
  t1.predicate = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' AND
  t2.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/hasGenre>' AND
  t2.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/SubGenre102>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t1.subject = t2.subject

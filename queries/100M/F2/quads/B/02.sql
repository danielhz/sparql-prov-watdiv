SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t1.object AS v2,
  t2.object AS v3,
  t3.object AS v4,
  t4.object AS v5,
  t5.object AS v6,
  t6.object AS v7
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3,
  quads as t4,
  quads as t5,
  quads as t6,
  quads as t7
WHERE
  t0.predicate = '<http://xmlns.com/foaf/homepage>' AND
  t1.predicate = '<http://ogp.me/ns#title>' AND
  t2.predicate = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>' AND
  t3.predicate = '<http://schema.org/caption>' AND
  t4.predicate = '<http://schema.org/description>' AND
  t5.predicate = '<http://schema.org/url>' AND
  t6.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/hits>' AND
  t7.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/hasGenre>' AND
  t7.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/SubGenre98>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t0.subject = t4.subject AND
  t0.subject = t7.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t1.subject = t4.subject AND
  t1.subject = t7.subject AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t7.subject AND
  t3.subject = t4.subject AND
  t3.subject = t7.subject AND
  t4.subject = t7.subject AND
  t0.object = t5.subject AND
  t0.object = t6.subject AND
  t5.subject = t6.subject;

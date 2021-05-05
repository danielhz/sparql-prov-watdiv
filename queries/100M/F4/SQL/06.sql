SELECT
  t0.subject,
  t0.object,
  t1.subject,
  t3.object,
  t4.object,
  t5.object,
  t6.object,
  t8.subject
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3,
  quads as t4,
  quads as t5,
  quads as t6,
  quads as t7,
  quads as t8
WHERE
  t0.predicate = '<http://xmlns.com/foaf/homepage>' AND
  t1.predicate = '<http://purl.org/goodrelations/includes>' AND
  t2.predicate = '<http://ogp.me/ns#tag>' AND
  t2.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Topic102>' AND
  t3.predicate = '<http://schema.org/description>' AND
  t4.predicate = '<http://schema.org/contentSize>' AND
  t5.predicate = '<http://schema.org/url>' AND
  t6.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/hits>' AND
  t7.predicate = '<http://schema.org/language>' AND
  t7.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Language0>' AND
  t8.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/likes>' AND
  t0.subject = t1.object AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t0.subject = t4.subject AND
  t0.subject = t8.object AND
  t1.object = t2.subject AND
  t1.object = t3.subject AND
  t1.object = t4.subject AND
  t1.object = t8.object AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t8.object AND
  t3.subject = t4.subject AND
  t3.subject = t8.object AND
  t4.subject = t8.object AND
  t0.object = t5.subject AND
  t0.object = t6.subject AND
  t0.object = t7.subject AND
  t5.subject = t6.subject AND
  t5.subject = t7.subject AND
  t6.subject = t7.subject

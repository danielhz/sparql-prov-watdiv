SELECT
  t0.subject,
  t0.object,
  t1.object,
  t2.object,
  t3.object,
  t4.object,
  t5.object,
  t6.subject,
  t7.object
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
  t0.predicate = '<http://schema.org/caption>' AND
  t1.predicate = '<http://schema.org/text>' AND
  t2.predicate = '<http://schema.org/contentRating>' AND
  t3.predicate = '<http://purl.org/stuff/rev#hasReview>' AND
  t4.predicate = '<http://purl.org/stuff/rev#title>' AND
  t5.predicate = '<http://purl.org/stuff/rev#reviewer>' AND
  t6.predicate = '<http://schema.org/actor>' AND
  t7.predicate = '<http://schema.org/language>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t2.subject = t3.subject AND
  t3.object = t4.subject AND
  t3.object = t5.subject AND
  t4.subject = t5.subject AND
  t5.object = t6.object AND
  t6.subject = t7.subject

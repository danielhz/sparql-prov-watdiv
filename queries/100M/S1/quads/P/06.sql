PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t2.object AS v3,
  t3.object AS v4,
  t4.object AS v5,
  t5.object AS v6,
  t6.object AS v7,
  t7.object AS v8,
  t8.object AS v9
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
  t0.predicate = '<http://purl.org/goodrelations/includes>' AND
  t1.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/Retailer3630>' AND
  t1.predicate = '<http://purl.org/goodrelations/offers>' AND
  t2.predicate = '<http://purl.org/goodrelations/price>' AND
  t3.predicate = '<http://purl.org/goodrelations/serialNumber>' AND
  t4.predicate = '<http://purl.org/goodrelations/validFrom>' AND
  t5.predicate = '<http://purl.org/goodrelations/validThrough>' AND
  t6.predicate = '<http://schema.org/eligibleQuantity>' AND
  t7.predicate = '<http://schema.org/eligibleRegion>' AND
  t8.predicate = '<http://schema.org/priceValidUntil>' AND
  t0.subject = t1.object AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t0.subject = t4.subject AND
  t0.subject = t5.subject AND
  t0.subject = t6.subject AND
  t0.subject = t7.subject AND
  t0.subject = t8.subject AND
  t1.object = t2.subject AND
  t1.object = t3.subject AND
  t1.object = t4.subject AND
  t1.object = t5.subject AND
  t1.object = t6.subject AND
  t1.object = t7.subject AND
  t1.object = t8.subject AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t5.subject AND
  t2.subject = t6.subject AND
  t2.subject = t7.subject AND
  t2.subject = t8.subject AND
  t3.subject = t4.subject AND
  t3.subject = t5.subject AND
  t3.subject = t6.subject AND
  t3.subject = t7.subject AND
  t3.subject = t8.subject AND
  t4.subject = t5.subject AND
  t4.subject = t6.subject AND
  t4.subject = t7.subject AND
  t4.subject = t8.subject AND
  t5.subject = t6.subject AND
  t5.subject = t7.subject AND
  t5.subject = t8.subject AND
  t6.subject = t7.subject AND
  t6.subject = t8.subject AND
  t7.subject = t8.subject
);

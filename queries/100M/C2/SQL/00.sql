SELECT
  t0.subject,
  t0.object,
  t1.object,
  t3.object,
  t4.subject,
  t4.object,
  t5.object,
  t6.object,
  t8.object,
  t9.object
FROM
  quads as t0,
  quads as t1,
  quads as t2,
  quads as t3,
  quads as t4,
  quads as t5,
  quads as t6,
  quads as t7,
  quads as t8,
  quads as t9
WHERE
  t0.predicate = '<http://schema.org/legalName>' AND
  t1.predicate = '<http://purl.org/goodrelations/offers>' AND
  t2.predicate = '<http://schema.org/eligibleRegion>' AND
  t2.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Country5>' AND
  t3.predicate = '<http://purl.org/goodrelations/includes>' AND
  t4.predicate = '<http://schema.org/jobTitle>' AND
  t5.predicate = '<http://xmlns.com/foaf/homepage>' AND
  t6.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/makesPurchase>' AND
  t7.predicate = '<http://db.uwaterloo.ca/~galuc/wsdbm/purchaseFor>' AND
  t8.predicate = '<http://purl.org/stuff/rev#hasReview>' AND
  t9.predicate = '<http://purl.org/stuff/rev#totalVotes>' AND
  t0.subject = t1.subject AND
  t1.object = t2.subject AND
  t1.object = t3.subject AND
  t2.subject = t3.subject AND
  t3.object = t7.object AND
  t3.object = t8.subject AND
  t7.object = t8.subject AND
  t4.subject = t5.subject AND
  t4.subject = t6.subject AND
  t5.subject = t6.subject AND
  t6.object = t7.subject AND
  t8.object = t9.subject

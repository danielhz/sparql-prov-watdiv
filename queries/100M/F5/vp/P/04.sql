PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t0.object AS v1,
  t2.object AS v3,
  t3.object AS v4,
  t4.object AS v5,
  t5.object AS v6
FROM
  gr__includes as t0,
  gr__offers as t1,
  gr__price as t2,
  gr__validThrough as t3,
  og__title as t4,
  rdf__type as t5
WHERE
  t1.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/Retailer3716>' AND
  t0.subject = t1.object AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t1.object = t2.subject AND
  t1.object = t3.subject AND
  t2.subject = t3.subject AND
  t0.object = t4.subject AND
  t0.object = t5.subject AND
  t4.subject = t5.subject
);

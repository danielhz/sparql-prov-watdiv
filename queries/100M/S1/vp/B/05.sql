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
  gr__includes as t0,
  gr__offers as t1,
  gr__price as t2,
  gr__serialNumber as t3,
  gr__validFrom as t4,
  gr__validThrough as t5,
  sorg__eligibleQuantity as t6,
  sorg__eligibleRegion as t7,
  sorg__priceValidUntil as t8
WHERE
  t1.subject = '<http://db.uwaterloo.ca/~galuc/wsdbm/Retailer8580>' AND
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
;

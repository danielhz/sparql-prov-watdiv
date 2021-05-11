PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t1.object AS v2,
  t2.subject AS v3,
  t2.object AS v4,
  t3.object AS v5
FROM
  og__tag as t0,
  rdf__type as t1,
  sorg__trailer as t2,
  sorg__keywords as t3,
  wsdbm__hasGenre as t4,
  rdf__type as t5
WHERE
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Topic123>' AND
  t5.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/ProductCategory2>' AND
  t0.subject = t1.subject AND
  t0.subject = t4.object AND
  t1.subject = t4.object AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t5.subject AND
  t3.subject = t4.subject AND
  t3.subject = t5.subject AND
  t4.subject = t5.subject
);

PROVENANCE OF (
SELECT
  t0.subject AS v0,
  t1.object AS v1,
  t2.object AS v2,
  t3.object AS v3,
  t4.object AS v4,
  t5.object AS v5,
  t6.object AS v6
FROM
  rdf__type as t0,
  wsdbm__likes as t1,
  wsdbm__friendOf as t2,
  dc__Location as t3,
  foaf__age as t4,
  wsdbm__gender as t5,
  foaf__givenName as t6
WHERE
  t0.object = '<http://db.uwaterloo.ca/~galuc/wsdbm/Role0>' AND
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t0.subject = t4.subject AND
  t0.subject = t5.subject AND
  t0.subject = t6.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t1.subject = t4.subject AND
  t1.subject = t5.subject AND
  t1.subject = t6.subject AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t5.subject AND
  t2.subject = t6.subject AND
  t3.subject = t4.subject AND
  t3.subject = t5.subject AND
  t3.subject = t6.subject AND
  t4.subject = t5.subject AND
  t4.subject = t6.subject AND
  t5.subject = t6.subject
);

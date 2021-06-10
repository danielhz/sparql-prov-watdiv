SELECT
  t0.subject AS v0
FROM
  wsdbm__likes as t0,
  wsdbm__friendOf as t1,
  dc__Location as t2,
  foaf__age as t3,
  wsdbm__gender as t4,
  foaf__givenName as t5
WHERE
  t0.subject = t1.subject AND
  t0.subject = t2.subject AND
  t0.subject = t3.subject AND
  t0.subject = t4.subject AND
  t0.subject = t5.subject AND
  t1.subject = t2.subject AND
  t1.subject = t3.subject AND
  t1.subject = t4.subject AND
  t1.subject = t5.subject AND
  t2.subject = t3.subject AND
  t2.subject = t4.subject AND
  t2.subject = t5.subject AND
  t3.subject = t4.subject AND
  t3.subject = t5.subject AND
  t4.subject = t5.subject
;

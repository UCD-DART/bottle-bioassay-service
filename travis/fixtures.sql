SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET row_security = off;

CREATE SCHEMA resistance
  AUTHORIZATION postgres;

SET search_path = resistance, pg_catalog;

CREATE TABLE resistance.test_group
(
  id bigserial NOT NULL,
  test_method_id bigint,
  test_by character varying,
  login_id bigint NOT NULL,
  agency_id bigint NOT NULL,
  bio_class_id bigint,
  lifecycle_stage_id integer,
  test_date timestamp without time zone,
  add_date timestamp with time zone NOT NULL DEFAULT now(),
  delete_date timestamp with time zone,
  dpr_registration_num character varying, -- refers to product.mv_product.dpr_registration_num
  description character varying,
  mosquitoes_source character varying,
  colony_name character varying,
  lot character varying,
  technical_grade boolean,
  table_name character varying,
  material_id integer,
  synergist_id integer,
  control_mortality double precision,
  diagnostic_dose character varying,
  name character varying,
  synergist_lot character varying,
  synergist_dose character varying,
  CONSTRAINT id PRIMARY KEY (id),
)
WITH (
  OIDS=FALSE
);

CREATE INDEX fki_bio_class_fkey
  ON resistance.test_group
  USING btree
  (bio_class_id);

CREATE INDEX fki_lifecycle_fkey
  ON resistance.test_group
  USING btree
  (lifecycle_stage_id);

CREATE INDEX fki_test_group_agendy_id_fkey
  ON resistance.test_group
  USING btree
  (agency_id);

CREATE INDEX fki_test_group_login_id_fkey
  ON resistance.test_group
  USING btree
  (login_id);

CREATE INDEX fki_test_group_material_id
  ON resistance.test_group
  USING btree
  (material_id);

CREATE INDEX fki_test_group_synergist_id
  ON resistance.test_group
  USING btree
  (synergist_id);

CREATE INDEX fki_test_group_test_method_id_fkey
  ON resistance.test_group
  USING btree
  (test_method_id);

CREATE INDEX test_group_add_date_idx
  ON resistance.test_group
  USING btree
  (add_date);

CREATE INDEX test_group_delete_date_idx
  ON resistance.test_group
  USING btree
  (delete_date NULLS FIRST);

CREATE INDEX test_group_test_date_idx
  ON resistance.test_group
  USING btree
  (test_date);

CREATE TABLE resistance.test_group_member
(
  id bigserial NOT NULL,
  test_group_id bigint NOT NULL DEFAULT nextval('test_group_member_test_group_id_seq'::regclass),
  comments character varying,
  login_id bigint NOT NULL DEFAULT nextval('test_group_member_login_id_seq'::regclass),
  agency_id bigint NOT NULL DEFAULT nextval('test_group_member_agency_id_seq'::regclass),
  concentration numeric,
  num_tested integer,
  replicate_num integer,
  add_date timestamp with time zone NOT NULL DEFAULT now(),
  delete_date timestamp with time zone,
  solution real,
  dilution real,
  bio_class_id bigint,
  mosquitoes_source character varying,
  colony_name character varying,
  generation integer,
  CONSTRAINT test_group_member_pkey PRIMARY KEY (id),
  CONSTRAINT test_group_id_fkey FOREIGN KEY (test_group_id)
      REFERENCES resistance.test_group (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
)
WITH (
  OIDS=FALSE
);

CREATE INDEX fki_test_group_id_fkey
  ON resistance.test_group_member
  USING btree
  (test_group_id);

CREATE INDEX fki_test_group_member_agency_id_fkey
  ON resistance.test_group_member
  USING btree
  (agency_id);

CREATE INDEX fki_test_group_member_login_id
  ON resistance.test_group_member
  USING btree
  (login_id);

CREATE INDEX test_group_member_add_date_idx
  ON resistance.test_group_member
  USING btree
  (add_date);

CREATE INDEX test_group_member_delete_date_idx
  ON resistance.test_group_member
  USING btree
  (delete_date NULLS FIRST);

CREATE TABLE resistance.test_group_result
(
  id bigserial NOT NULL,
  test_group_member_id bigint,
  exposure_length numeric,
  survival_count integer,
  add_date timestamp with time zone NOT NULL DEFAULT now(),
  delete_date timestamp with time zone,
  CONSTRAINT test_group_result_pkey PRIMARY KEY (id),
  CONSTRAINT test_group_result_test_group_member_id_fkey FOREIGN KEY (test_group_member_id)
      REFERENCES resistance.test_group_member (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);

CREATE INDEX fki_test_group_result_test_group_member_id_fkey
  ON resistance.test_group_result
  USING btree
  (test_group_member_id);

CREATE INDEX test_group_result_add_date_idx
  ON resistance.test_group_result
  USING btree
  (add_date);

CREATE INDEX test_group_result_delete_date_idx
  ON resistance.test_group_result
  USING btree
  (delete_date NULLS FIRST);

INSERT INTO test_group VALUES (1, 2, 'Jake', 1, 0, NULL, NULL, '2016-08-21 00:00:00', '2017-11-07 12:10:00.112071-08', NULL, NULL, NULL, NULL, NULL, '123', NULL, NULL, 14, 3, 0, '20 μg/mL', 'Test', '7536800', '900 μg');
INSERT INTO test_group VALUES (2, 2, 'Jake', 1, 0, NULL, NULL, '2016-08-21 00:00:00', '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, NULL, NULL, '123', NULL, NULL, 15, NULL, 0, '300 μg/mL', 'Test2', NULL, NULL);

SELECT pg_catalog.setval('test_group_id_seq', 3, true);


INSERT INTO test_group_member VALUES (188, 2, NULL, 1, 0, NULL, 30, 0, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'colony', 'Toledo, Ohio', 0);
INSERT INTO test_group_member VALUES (189, 2, NULL, 1, 0, NULL, 22, 1, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'colony', 'Toledo, Ohio', 0);
INSERT INTO test_group_member VALUES (190, 2, NULL, 1, 0, NULL, 29, 2, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'colony', 'Toledo, Ohio', 0);
INSERT INTO test_group_member VALUES (191, 2, NULL, 1, 0, NULL, 21, 3, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'colony', 'Toledo, Ohio', 0);
INSERT INTO test_group_member VALUES (192, 2, NULL, 1, 0, NULL, 24, 4, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'colony', 'Toledo, Ohio', 0);
INSERT INTO test_group_member VALUES (193, 2, NULL, 1, 0, NULL, 22, 5, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'colony', 'Toledo, Ohio', 0);
INSERT INTO test_group_member VALUES (194, 1, NULL, 1, 0, NULL, 21, 0, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'field', NULL, 1);
INSERT INTO test_group_member VALUES (195, 1, NULL, 1, 0, NULL, 19, 1, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'field', NULL, 1);
INSERT INTO test_group_member VALUES (196, 1, NULL, 1, 0, NULL, 20, 2, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'field', NULL, 1);
INSERT INTO test_group_member VALUES (197, 1, NULL, 1, 0, NULL, 22, 3, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'field', NULL, 1);
INSERT INTO test_group_member VALUES (198, 1, NULL, 1, 0, NULL, 18, 4, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'field', NULL, 1);
INSERT INTO test_group_member VALUES (199, 1, NULL, 1, 0, NULL, 18, 5, '2017-11-07 15:20:00.003048-08', NULL, NULL, NULL, 22, 'field', NULL, 1);

SELECT pg_catalog.setval('test_group_member_id_seq', 223, true);


INSERT INTO test_group_result VALUES (1915, 188, 0, 25, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1916, 188, 15, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1917, 188, 30, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1918, 188, 35, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1919, 188, 40, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1920, 188, 45, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1921, 188, 60, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1922, 188, 75, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1923, 188, 90, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1924, 188, 105, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1925, 188, 120, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1926, 189, 0, 18, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1927, 189, 15, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1928, 189, 30, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1929, 189, 35, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1930, 189, 40, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1931, 189, 45, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1932, 189, 60, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1933, 189, 75, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1934, 189, 90, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1935, 189, 105, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1936, 189, 120, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1937, 190, 0, 21, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1938, 190, 15, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1939, 190, 30, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1940, 190, 35, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1941, 190, 40, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1942, 190, 45, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1943, 190, 60, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1944, 190, 75, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1945, 190, 90, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1946, 190, 105, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1947, 190, 120, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1948, 191, 0, 18, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1949, 191, 15, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1950, 191, 30, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1951, 191, 35, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1952, 191, 40, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1953, 191, 45, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1954, 191, 60, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1955, 191, 75, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1956, 191, 90, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1957, 191, 105, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1958, 191, 120, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1959, 192, 0, 18, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1960, 192, 15, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1961, 192, 30, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1962, 192, 35, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1963, 192, 40, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1964, 192, 45, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1965, 192, 60, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1966, 192, 75, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1967, 192, 90, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1968, 192, 105, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1969, 192, 120, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1970, 193, 0, 7, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1971, 193, 15, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1972, 193, 30, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1973, 193, 35, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1974, 193, 40, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1975, 193, 45, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1976, 193, 60, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1977, 193, 75, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1978, 193, 90, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1979, 193, 105, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1980, 193, 120, 0, '2016-12-10 10:01:11.917443-08', NULL);
INSERT INTO test_group_result VALUES (1981, 194, 0, 21, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1982, 194, 15, 7, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1983, 194, 30, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1984, 194, 35, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1985, 194, 40, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1986, 194, 45, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1987, 194, 60, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1988, 194, 75, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1989, 194, 90, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1990, 194, 105, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1991, 194, 120, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1992, 195, 0, 19, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1993, 195, 15, 4, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1994, 195, 30, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1995, 195, 35, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1996, 195, 40, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1997, 195, 45, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1998, 195, 60, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (1999, 195, 75, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2000, 195, 90, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2001, 195, 105, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2002, 195, 120, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2003, 196, 0, 20, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2004, 196, 15, 5, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2005, 196, 30, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2006, 196, 35, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2007, 196, 40, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2008, 196, 45, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2009, 196, 60, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2010, 196, 75, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2011, 196, 90, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2012, 196, 105, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2013, 196, 120, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2014, 197, 0, 22, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2015, 197, 15, 13, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2016, 197, 30, 1, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2017, 197, 35, 1, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2018, 197, 40, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2019, 197, 45, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2020, 197, 60, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2021, 197, 75, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2022, 197, 90, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2023, 197, 105, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2024, 197, 120, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2025, 198, 0, 18, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2026, 198, 15, 10, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2027, 198, 30, 2, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2028, 198, 35, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2029, 198, 40, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2030, 198, 45, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2031, 198, 60, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2032, 198, 75, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2033, 198, 90, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2034, 198, 105, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2035, 198, 120, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2036, 199, 0, 18, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2037, 199, 15, 6, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2038, 199, 30, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2039, 199, 35, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2040, 199, 40, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2041, 199, 45, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2042, 199, 60, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2043, 199, 75, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2044, 199, 90, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2045, 199, 105, 0, '2016-12-10 10:01:11.663599-08', NULL);
INSERT INTO test_group_result VALUES (2046, 199, 120, 0, '2016-12-10 10:01:11.663599-08', NULL);

SELECT pg_catalog.setval('test_group_result_id_seq', 2310, true);
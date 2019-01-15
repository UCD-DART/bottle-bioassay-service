CREATE SCHEMA resistance
  AUTHORIZATION postgres;

-- Table: resistance.test_group

-- DROP TABLE resistance.test_group;

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
  CONSTRAINT test_group_agendy_id_fkey FOREIGN KEY (agency_id)
      REFERENCES agency (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT test_group_bio_class_id_fkey FOREIGN KEY (bio_class_id)
      REFERENCES bio_class (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT test_group_lifecycle_stage_id_fkey FOREIGN KEY (lifecycle_stage_id)
      REFERENCES resistance.lifecycle_stage (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT test_group_login_id_fkey FOREIGN KEY (login_id)
      REFERENCES login (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT test_group_material_id FOREIGN KEY (material_id)
      REFERENCES resistance.material (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT test_group_synergist_id FOREIGN KEY (synergist_id)
      REFERENCES resistance.synergist (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT test_group_test_method_id_fkey FOREIGN KEY (test_method_id)
      REFERENCES resistance.test_method (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);


-- Index: resistance.fki_bio_class_fkey

-- DROP INDEX resistance.fki_bio_class_fkey;

CREATE INDEX fki_bio_class_fkey
  ON resistance.test_group
  USING btree
  (bio_class_id);

-- Index: resistance.fki_lifecycle_fkey

-- DROP INDEX resistance.fki_lifecycle_fkey;

CREATE INDEX fki_lifecycle_fkey
  ON resistance.test_group
  USING btree
  (lifecycle_stage_id);

-- Index: resistance.fki_test_group_agendy_id_fkey

-- DROP INDEX resistance.fki_test_group_agendy_id_fkey;

CREATE INDEX fki_test_group_agendy_id_fkey
  ON resistance.test_group
  USING btree
  (agency_id);

-- Index: resistance.fki_test_group_login_id_fkey

-- DROP INDEX resistance.fki_test_group_login_id_fkey;

CREATE INDEX fki_test_group_login_id_fkey
  ON resistance.test_group
  USING btree
  (login_id);

-- Index: resistance.fki_test_group_material_id

-- DROP INDEX resistance.fki_test_group_material_id;

CREATE INDEX fki_test_group_material_id
  ON resistance.test_group
  USING btree
  (material_id);

-- Index: resistance.fki_test_group_synergist_id

-- DROP INDEX resistance.fki_test_group_synergist_id;

CREATE INDEX fki_test_group_synergist_id
  ON resistance.test_group
  USING btree
  (synergist_id);

-- Index: resistance.fki_test_group_test_method_id_fkey

-- DROP INDEX resistance.fki_test_group_test_method_id_fkey;

CREATE INDEX fki_test_group_test_method_id_fkey
  ON resistance.test_group
  USING btree
  (test_method_id);

-- Index: resistance.test_group_add_date_idx

-- DROP INDEX resistance.test_group_add_date_idx;

CREATE INDEX test_group_add_date_idx
  ON resistance.test_group
  USING btree
  (add_date);

-- Index: resistance.test_group_delete_date_idx

-- DROP INDEX resistance.test_group_delete_date_idx;

CREATE INDEX test_group_delete_date_idx
  ON resistance.test_group
  USING btree
  (delete_date NULLS FIRST);

-- Index: resistance.test_group_test_date_idx

-- DROP INDEX resistance.test_group_test_date_idx;

CREATE INDEX test_group_test_date_idx
  ON resistance.test_group
  USING btree
  (test_date);

-- Table: resistance.test_group_member

-- DROP TABLE resistance.test_group_member;

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
  CONSTRAINT test_group_member_agency_id FOREIGN KEY (agency_id)
      REFERENCES agency (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT test_group_member_login_id FOREIGN KEY (login_id)
      REFERENCES login (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);


-- Index: resistance.fki_test_group_id_fkey

-- DROP INDEX resistance.fki_test_group_id_fkey;

CREATE INDEX fki_test_group_id_fkey
  ON resistance.test_group_member
  USING btree
  (test_group_id);

-- Index: resistance.fki_test_group_member_agency_id_fkey

-- DROP INDEX resistance.fki_test_group_member_agency_id_fkey;

CREATE INDEX fki_test_group_member_agency_id_fkey
  ON resistance.test_group_member
  USING btree
  (agency_id);

-- Index: resistance.fki_test_group_member_login_id

-- DROP INDEX resistance.fki_test_group_member_login_id;

CREATE INDEX fki_test_group_member_login_id
  ON resistance.test_group_member
  USING btree
  (login_id);

-- Index: resistance.test_group_member_add_date_idx

-- DROP INDEX resistance.test_group_member_add_date_idx;

CREATE INDEX test_group_member_add_date_idx
  ON resistance.test_group_member
  USING btree
  (add_date);

-- Index: resistance.test_group_member_delete_date_idx

-- DROP INDEX resistance.test_group_member_delete_date_idx;

CREATE INDEX test_group_member_delete_date_idx
  ON resistance.test_group_member
  USING btree
  (delete_date NULLS FIRST);

-- Table: resistance.test_group_result

-- DROP TABLE resistance.test_group_result;

CREATE TABLE resistance.test_group_result
(
  id bigint NOT NULL DEFAULT nextval('test_group_result_id_seq'::regclass),
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


-- Index: resistance.fki_test_group_result_test_group_member_id_fkey

-- DROP INDEX resistance.fki_test_group_result_test_group_member_id_fkey;

CREATE INDEX fki_test_group_result_test_group_member_id_fkey
  ON resistance.test_group_result
  USING btree
  (test_group_member_id);

-- Index: resistance.test_group_result_add_date_idx

-- DROP INDEX resistance.test_group_result_add_date_idx;

CREATE INDEX test_group_result_add_date_idx
  ON resistance.test_group_result
  USING btree
  (add_date);

-- Index: resistance.test_group_result_delete_date_idx

-- DROP INDEX resistance.test_group_result_delete_date_idx;

CREATE INDEX test_group_result_delete_date_idx
  ON resistance.test_group_result
  USING btree
  (delete_date NULLS FIRST);


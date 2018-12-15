CREATE TABLE todo_records%SUFFIX% (
    id serial NOT NULL,
    aggregate_id uuid NOT NULL,
    title character varying,
    completed boolean DEFAULT false NOT NULL,
    CONSTRAINT todo_records_pkey%SUFFIX% PRIMARY KEY (id)
);

CREATE UNIQUE INDEX todo_records_keys%SUFFIX% ON todo_records%SUFFIX% USING btree (aggregate_id);

CREATE USER smartmet_server_db WITH PASSWORD 'smartmet_server_db';

-- Database: names

-- DROP DATABASE IF EXISTS names;

CREATE DATABASE names
    WITH
    OWNER = smartmet_server_db
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

ALTER DATABASE names
    SET search_path TO "$user", public, topology;

-- Database: shapes

-- DROP DATABASE IF EXISTS shapes;

CREATE DATABASE shapes
    WITH
    OWNER = smartmet_server_db
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

ALTER DATABASE shapes
    SET search_path TO "$user", public, tiger;

\c names;

-- public.alternate_geonames definition

-- Drop table

-- DROP TABLE public.alternate_geonames;

CREATE TABLE public.alternate_geonames (
	id int4 NOT NULL,
	geonames_id int4 NOT NULL,
	"language" varchar(100) NOT NULL,
	name varchar(200) NOT NULL,
	preferred bool NOT NULL DEFAULT false,
	short bool NOT NULL DEFAULT false,
	colloquial bool NOT NULL DEFAULT false,
	historic bool NOT NULL DEFAULT false,
	priority int4 NOT NULL DEFAULT 50,
	"locked" bool NOT NULL DEFAULT false,
	last_modified timestamp NULL DEFAULT now()
);
CREATE INDEX idx_alternate_geonames_last_modified ON alternate_geonames USING btree (last_modified);
CREATE INDEX idx_alternategeoid ON alternate_geonames USING btree (geonames_id);
CREATE INDEX idx_alternatename ON alternate_geonames USING btree (name);
CREATE INDEX idx_loweralternatename ON alternate_geonames USING btree (lower((name)::text));


-- public.alternate_municipalities definition

-- Drop table

-- DROP TABLE public.alternate_municipalities;

CREATE TABLE public.alternate_municipalities (
	id int4 NOT NULL,
	municipalities_id int4 NOT NULL,
	"name" varchar(200) NOT NULL,
	"language" varchar(10) NULL,
	CONSTRAINT alternate_municipalities_pkey PRIMARY KEY (id)
);

-- public.countries definition

-- Drop table

-- DROP TABLE public.countries;

CREATE TABLE public.countries (
	iso2 bpchar(2) NOT NULL,
	iso3 bpchar(3) NOT NULL,
	iso_numeric int4 NULL,
	fips bpchar(2) NULL,
	"name" varchar(50) NOT NULL,
	capital varchar(100) NULL,
	areainsqkm float8 NULL,
	population int4 NULL,
	continent bpchar(2) NULL,
	tld bpchar(4) NULL,
	currency_code bpchar(3) NULL,
	currency_name varchar(20) NULL,
	phone varchar(20) NULL,
	postal_code_fmt varchar(60) NULL,
	postal_code_ngx varchar(200) NULL,
	languages varchar(100) NULL,
	geonames_id int4 NULL,
	neighbors varchar(75) NULL,
	CONSTRAINT countries_pkey PRIMARY KEY (iso2)
);


-- public.features definition

-- Drop table

-- DROP TABLE public.features;

CREATE TABLE public.features (
	code varchar(8) NOT NULL,
	shortdesc varchar(50) NOT NULL DEFAULT ''::character varying,
	longdesc varchar(255) NOT NULL DEFAULT ''::character varying,
	"class" bpchar(1) NULL,
	CONSTRAINT features_pkey PRIMARY KEY (code)
);

-- public.geonames definition

-- Drop table

-- DROP TABLE public.geonames;

CREATE TABLE public.geonames (
	id int4 NOT NULL,
	"name" varchar(200) NOT NULL,
	ansiname varchar(200) NULL DEFAULT ''::character varying,
	lat float8 NOT NULL,
	lon float8 NOT NULL,
	"class" bpchar(1) NULL DEFAULT NULL::bpchar,
	features_code varchar(10) NULL DEFAULT NULL::character varying,
	countries_iso2 varchar(2) NULL DEFAULT NULL::character varying,
	cc2 varchar(60) NULL,
	admin1 varchar(20) NULL DEFAULT NULL::character varying,
	admin2 varchar(80) NULL DEFAULT NULL::character varying,
	admin3 varchar(20) NULL DEFAULT NULL::character varying,
	admin4 varchar(20) NULL DEFAULT NULL::character varying,
	population int8 NULL DEFAULT 0,
	elevation int4 NULL,
	dem int4 NULL,
	timezone varchar(40) NULL DEFAULT NULL::character varying,
	modified date NOT NULL DEFAULT 'now'::text::date,
	municipalities_id int4 NOT NULL DEFAULT 0,
	priority int4 NOT NULL DEFAULT 50,
	"locked" bool NOT NULL DEFAULT false,
	last_modified timestamp NULL,
	landcover int4 NULL
);
CREATE INDEX idx_geonamecountry ON geonames USING btree (countries_iso2);
CREATE INDEX idx_geonamefeature ON geonames USING btree (features_code);
CREATE INDEX idx_last_modified ON geonames USING btree (last_modified);
CREATE INDEX idx_lowername ON geonames USING btree (lower((name)::text));
CREATE INDEX idx_name ON geonames USING btree (name);
CREATE INDEX idx_population ON geonames USING btree (population);

-- public.keywords definition

-- Drop table

-- DROP TABLE public.keywords;

CREATE TABLE public.keywords (
	keyword varchar(50) NOT NULL,
	"comment" varchar(200) NULL DEFAULT ''::character varying,
	languages varchar(200) NULL DEFAULT ''::character varying,
	autocomplete bool NOT NULL DEFAULT false,
	CONSTRAINT keywords_pkey PRIMARY KEY (keyword)
);

-- public.keywords_has_geonames definition

-- Drop table

-- DROP TABLE public.keywords_has_geonames;

CREATE TABLE public.keywords_has_geonames (
	keyword varchar(50) NOT NULL,
	geonames_id int4 NOT NULL,
	"comment" varchar(200) NULL DEFAULT ''::character varying,
	"name" varchar(200) NULL DEFAULT ''::character varying,
	last_modified timestamp NULL DEFAULT now(),
	CONSTRAINT keywords_has_geonames_pkey PRIMARY KEY (keyword, geonames_id),
	CONSTRAINT fk_keywords_has_geonames_keywords FOREIGN KEY (keyword) REFERENCES public.keywords(keyword)
);
CREATE INDEX idx_keywords_has_geonames_last_modified ON keywords_has_geonames USING btree (last_modified);

-- public.languages definition

-- Drop table

-- DROP TABLE public.languages;

CREATE TABLE public.languages (
	iso_639_3 bpchar(3) NOT NULL,
	iso_639_2 bpchar(3) NULL DEFAULT NULL::bpchar,
	iso_639_1 bpchar(2) NULL DEFAULT NULL::bpchar,
	"name" varchar(100) NOT NULL,
	CONSTRAINT languages_pkey PRIMARY KEY (iso_639_3)
);

-- public.municipalities definition

-- Drop table

-- DROP TABLE public.municipalities;

CREATE TABLE public.municipalities (
	id int4 NOT NULL,
	countries_iso2 bpchar(2) NOT NULL,
	"name" varchar(200) NOT NULL,
	code int4 NULL,
	CONSTRAINT municipalities_pkey PRIMARY KEY (id),
	CONSTRAINT fk_municipalities_iso2 FOREIGN KEY (countries_iso2) REFERENCES public.countries(iso2)
);

-- public.spatial_ref_sys definition

-- Drop table

-- DROP TABLE public.spatial_ref_sys;

CREATE TABLE public.spatial_ref_sys (
	srid int4 NOT NULL,
	auth_name varchar(256) NULL,
	auth_srid int4 NULL,
	srtext varchar(2048) NULL,
	proj4text varchar(2048) NULL,
	CONSTRAINT spatial_ref_sys_pkey PRIMARY KEY (srid),
	CONSTRAINT spatial_ref_sys_srid_check CHECK (((srid > 0) AND (srid <= 998999)))
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO smartmet_server_db;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO smartmet_server_db;


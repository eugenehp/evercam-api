--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: access_rights; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE access_rights (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    token_id integer NOT NULL,
    "right" text NOT NULL,
    camera_id integer,
    grantor_id integer,
    status integer DEFAULT 1 NOT NULL,
    snapshot_id integer,
    account_id integer,
    scope character varying(100)
);


ALTER TABLE public.access_rights OWNER TO vagrant;

--
-- Name: access_rights_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE access_rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_rights_id_seq OWNER TO vagrant;

--
-- Name: access_rights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE access_rights_id_seq OWNED BY access_rights.id;


--
-- Name: sq_access_tokens; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE sq_access_tokens
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sq_access_tokens OWNER TO vagrant;

--
-- Name: access_tokens; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE access_tokens (
    id integer DEFAULT nextval('sq_access_tokens'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    is_revoked boolean NOT NULL,
    user_id integer,
    client_id integer,
    request text NOT NULL,
    refresh text,
    grantor_id integer
);


ALTER TABLE public.access_tokens OWNER TO vagrant;

--
-- Name: add_ons; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE add_ons (
    id integer NOT NULL,
    user_id integer NOT NULL,
    add_ons_name text NOT NULL,
    period text NOT NULL,
    add_ons_start_date timestamp with time zone NOT NULL,
    add_ons_end_date timestamp with time zone NOT NULL,
    status boolean NOT NULL,
    price double precision NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.add_ons OWNER TO vagrant;

--
-- Name: add_ons_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE add_ons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.add_ons_id_seq OWNER TO vagrant;

--
-- Name: add_ons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE add_ons_id_seq OWNED BY add_ons.id;


--
-- Name: apps; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE apps (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    local_recording boolean DEFAULT false NOT NULL,
    cloud_recording boolean DEFAULT false NOT NULL,
    motion_detection boolean DEFAULT false NOT NULL,
    watermark boolean DEFAULT false NOT NULL
);


ALTER TABLE public.apps OWNER TO vagrant;

--
-- Name: apps_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE apps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.apps_id_seq OWNER TO vagrant;

--
-- Name: apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE apps_id_seq OWNED BY apps.id;


--
-- Name: archives; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE archives (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    requested_by integer NOT NULL,
    exid text NOT NULL,
    title text NOT NULL,
    from_date timestamp with time zone NOT NULL,
    to_date timestamp with time zone NOT NULL,
    status integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    embed_time boolean,
    public boolean
);


ALTER TABLE public.archives OWNER TO vagrant;

--
-- Name: archives_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE archives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.archives_id_seq OWNER TO vagrant;

--
-- Name: archives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE archives_id_seq OWNED BY archives.id;


--
-- Name: camera_activities; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE camera_activities (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    access_token_id integer,
    action text NOT NULL,
    done_at timestamp with time zone NOT NULL,
    ip inet,
    extra json
);


ALTER TABLE public.camera_activities OWNER TO vagrant;

--
-- Name: camera_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE camera_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.camera_activities_id_seq OWNER TO vagrant;

--
-- Name: camera_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE camera_activities_id_seq OWNED BY camera_activities.id;


--
-- Name: camera_endpoints; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE camera_endpoints (
    id integer NOT NULL,
    camera_id integer,
    scheme text NOT NULL,
    host text NOT NULL,
    port integer NOT NULL
);


ALTER TABLE public.camera_endpoints OWNER TO vagrant;

--
-- Name: camera_endpoints_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE camera_endpoints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.camera_endpoints_id_seq OWNER TO vagrant;

--
-- Name: camera_endpoints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE camera_endpoints_id_seq OWNED BY camera_endpoints.id;


--
-- Name: camera_share_requests; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE camera_share_requests (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    user_id integer NOT NULL,
    key character varying(100) NOT NULL,
    email character varying(250) NOT NULL,
    status integer NOT NULL,
    rights character varying(1000) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    message text
);


ALTER TABLE public.camera_share_requests OWNER TO vagrant;

--
-- Name: camera_share_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE camera_share_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.camera_share_requests_id_seq OWNER TO vagrant;

--
-- Name: camera_share_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE camera_share_requests_id_seq OWNED BY camera_share_requests.id;


--
-- Name: camera_shares; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE camera_shares (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    user_id integer NOT NULL,
    sharer_id integer,
    kind character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    message text
);


ALTER TABLE public.camera_shares OWNER TO vagrant;

--
-- Name: camera_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE camera_shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.camera_shares_id_seq OWNER TO vagrant;

--
-- Name: camera_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE camera_shares_id_seq OWNED BY camera_shares.id;


--
-- Name: sq_streams; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE sq_streams
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sq_streams OWNER TO vagrant;

--
-- Name: cameras; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE cameras (
    id integer DEFAULT nextval('sq_streams'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    exid text NOT NULL,
    owner_id integer NOT NULL,
    is_public boolean NOT NULL,
    config json NOT NULL,
    name text NOT NULL,
    last_polled_at timestamp with time zone,
    is_online boolean,
    timezone text,
    last_online_at timestamp with time zone,
    location geography(Point,4326),
    mac_address macaddr,
    model_id integer,
    discoverable boolean DEFAULT false NOT NULL,
    preview bytea,
    thumbnail_url text
);


ALTER TABLE public.cameras OWNER TO vagrant;

--
-- Name: sq_clients; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE sq_clients
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sq_clients OWNER TO vagrant;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE clients (
    id integer DEFAULT nextval('sq_clients'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    api_id text NOT NULL,
    callback_uris text[],
    api_key text,
    name text,
    settings text
);


ALTER TABLE public.clients OWNER TO vagrant;

--
-- Name: sq_countries; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE sq_countries
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sq_countries OWNER TO vagrant;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE countries (
    id integer DEFAULT nextval('sq_countries'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    iso3166_a2 text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.countries OWNER TO vagrant;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE schema_migrations (
    filename text NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO vagrant;

--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE snapshots (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    notes text,
    data bytea NOT NULL,
    is_public boolean DEFAULT false NOT NULL
);


ALTER TABLE public.snapshots OWNER TO vagrant;

--
-- Name: snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.snapshots_id_seq OWNER TO vagrant;

--
-- Name: snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE snapshots_id_seq OWNED BY snapshots.id;


--
-- Name: sq_access_tokens_streams_rights; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE sq_access_tokens_streams_rights
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sq_access_tokens_streams_rights OWNER TO vagrant;

--
-- Name: sq_devices; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE sq_devices
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sq_devices OWNER TO vagrant;

--
-- Name: sq_firmwares; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE sq_firmwares
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sq_firmwares OWNER TO vagrant;

--
-- Name: sq_users; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE sq_users
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sq_users OWNER TO vagrant;

--
-- Name: sq_vendors; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE sq_vendors
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sq_vendors OWNER TO vagrant;

--
-- Name: users; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE users (
    id integer DEFAULT nextval('sq_users'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    country_id integer NOT NULL,
    confirmed_at timestamp with time zone,
    email text NOT NULL,
    reset_token text,
    token_expires_at timestamp without time zone,
    api_id text,
    api_key text,
    is_admin boolean DEFAULT false NOT NULL,
    billing_id text,
    stripe_customer_id text
);


ALTER TABLE public.users OWNER TO vagrant;

--
-- Name: vendor_models; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE vendor_models (
    id integer DEFAULT nextval('sq_firmwares'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    vendor_id integer NOT NULL,
    name text NOT NULL,
    config json NOT NULL,
    exid text DEFAULT ''::text NOT NULL,
    jpg_url text DEFAULT ''::text NOT NULL,
    h264_url text DEFAULT ''::text NOT NULL,
    mjpg_url text DEFAULT ''::text NOT NULL,
    shape text DEFAULT ''::text,
    resolution text DEFAULT ''::text,
    official_url text DEFAULT ''::text,
    audio_url text DEFAULT ''::text,
    more_info text DEFAULT ''::text,
    poe boolean DEFAULT false NOT NULL,
    wifi boolean DEFAULT false NOT NULL,
    onvif boolean DEFAULT false NOT NULL,
    psia boolean DEFAULT false NOT NULL,
    ptz boolean DEFAULT false NOT NULL,
    infrared boolean DEFAULT false NOT NULL,
    varifocal boolean DEFAULT false NOT NULL,
    sd_card boolean DEFAULT false NOT NULL,
    upnp boolean DEFAULT false NOT NULL,
    audio_io boolean DEFAULT false NOT NULL,
    discontinued boolean DEFAULT false NOT NULL,
    username text,
    password text
);


ALTER TABLE public.vendor_models OWNER TO vagrant;

--
-- Name: vendors; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE vendors (
    id integer DEFAULT nextval('sq_vendors'::regclass) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    exid text NOT NULL,
    known_macs text[] NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.vendors OWNER TO vagrant;

--
-- Name: webhooks; Type: TABLE; Schema: public; Owner: vagrant; Tablespace:
--

CREATE TABLE webhooks (
    id integer NOT NULL,
    camera_id integer NOT NULL,
    user_id integer NOT NULL,
    url text NOT NULL,
    exid text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.webhooks OWNER TO vagrant;

--
-- Name: webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: vagrant
--

CREATE SEQUENCE webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.webhooks_id_seq OWNER TO vagrant;

--
-- Name: webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vagrant
--

ALTER SEQUENCE webhooks_id_seq OWNED BY webhooks.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY access_rights ALTER COLUMN id SET DEFAULT nextval('access_rights_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY add_ons ALTER COLUMN id SET DEFAULT nextval('add_ons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY apps ALTER COLUMN id SET DEFAULT nextval('apps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY archives ALTER COLUMN id SET DEFAULT nextval('archives_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_activities ALTER COLUMN id SET DEFAULT nextval('camera_activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_endpoints ALTER COLUMN id SET DEFAULT nextval('camera_endpoints_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_share_requests ALTER COLUMN id SET DEFAULT nextval('camera_share_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_shares ALTER COLUMN id SET DEFAULT nextval('camera_shares_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY snapshots ALTER COLUMN id SET DEFAULT nextval('snapshots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY webhooks ALTER COLUMN id SET DEFAULT nextval('webhooks_id_seq'::regclass);


--
-- Data for Name: access_rights; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY access_rights (id, created_at, updated_at, token_id, "right", camera_id, grantor_id, status, snapshot_id, account_id, scope) FROM stdin;
\.


--
-- Name: access_rights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('access_rights_id_seq', 1, false);


--
-- Data for Name: access_tokens; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY access_tokens (id, created_at, updated_at, expires_at, is_revoked, user_id, client_id, request, refresh, grantor_id) FROM stdin;
\.


--
-- Data for Name: add_ons; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY add_ons (id, user_id, add_ons_name, period, add_ons_start_date, add_ons_end_date, status, price, created_at, updated_at) FROM stdin;
\.


--
-- Name: add_ons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('add_ons_id_seq', 1, false);


--
-- Data for Name: apps; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY apps (id, camera_id, local_recording, cloud_recording, motion_detection, watermark) FROM stdin;
\.


--
-- Name: apps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('apps_id_seq', 1, false);


--
-- Data for Name: archives; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY archives (id, camera_id, requested_by, exid, title, from_date, to_date, status, created_at, embed_time, public) FROM stdin;
\.


--
-- Name: archives_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('archives_id_seq', 1, false);


--
-- Data for Name: camera_activities; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY camera_activities (id, camera_id, access_token_id, action, done_at, ip, extra) FROM stdin;
\.


--
-- Name: camera_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('camera_activities_id_seq', 1, false);


--
-- Data for Name: camera_endpoints; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY camera_endpoints (id, camera_id, scheme, host, port) FROM stdin;
\.


--
-- Name: camera_endpoints_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('camera_endpoints_id_seq', 1, false);


--
-- Data for Name: camera_share_requests; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY camera_share_requests (id, camera_id, user_id, key, email, status, rights, created_at, updated_at, message) FROM stdin;
\.


--
-- Name: camera_share_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('camera_share_requests_id_seq', 1, false);


--
-- Data for Name: camera_shares; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY camera_shares (id, camera_id, user_id, sharer_id, kind, created_at, updated_at, message) FROM stdin;
\.


--
-- Name: camera_shares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('camera_shares_id_seq', 1, false);


--
-- Data for Name: cameras; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY cameras (id, created_at, updated_at, exid, owner_id, is_public, config, name, last_polled_at, is_online, timezone, last_online_at, location, mac_address, model_id, discoverable, preview, thumbnail_url) FROM stdin;
1	2015-07-29 09:19:16.415265+00	2015-07-29 09:19:16.415268+00	evercam-remembrance-camera	1	t	{"snapshots":{"jpg":"/Streaming/channels/1/picture"},"auth":{"basic":{"username":"admin","password":"12345"}}}	Evercam Remembrance Camera	\N	\N	Europe/Dublin	\N	\N	8c:e7:48:bd:bd:f5	\N	f	\N	\N
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY clients (id, created_at, updated_at, api_id, callback_uris, api_key, name, settings) FROM stdin;
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY countries (id, created_at, updated_at, iso3166_a2, name) FROM stdin;
1	2015-07-29 09:18:21.990984+00	2015-07-29 09:18:21.990984+00	ie	Ireland
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY schema_migrations (filename) FROM stdin;
20140117140553_rename_streams_cameras.rb
20140117152744_extract_camera_endpoints.rb
20140117161713_add_camera_name_and_online.rb
20140120122055_add_timezones_to_camera.rb
20140121103201_access_rights.rb
20140124095400_add_last_online_to_camera.rb
20140124111900_create_camera_activity_table.rb
20140127114642_make_token_grantee_nullable.rb
20140127162159_create_access_rights_table.rb
20140131114730_new_camera_columns_inc_postgis.rb
20140131154907_split_access_right_scopes.rb
20140204122900_password_reset_token_expiry.rb
20140204172800_change_token_expiry_type.rb
20140211094100_add_index_to_camera_mac_address.rb
20140218105700_rework_access_tokens.rb
20140218143100_rework_access_rights.rb
20140219141000_create_snapshots_table.rb
20140225111600_add_camera_shares.rb
20140225150200_add_evercam_user.rb
20140225150900_create_remembrance_camera.rb
20140226164200_fix_access_right_foreign_key.rb
20140227145500_simplify_clients_table.rb
20140304104600_add_api_id_and_api_key_to_user.rb
20140306112300_fix_snapshot_delete.rb
20140310104400_add_is_public_to_snapshots.rb
20140310104900_add_snapshot_foreign_key_to_access_rights.rb
20140310105600_remove_not_null_for_camera_id_on_access_rights.rb
20140310122800_add_account_capabilities_to_access_rights.rb
20140311091900_add_grantor_id_to_access_tokens.rb
20140314094200_rename_firmware_to_vendor_model.rb
20140321123100_move_endpoints_back_to_camera_config.rb
20140328110700_add_settings_to_clients_table.rb
20140401092700_change_client_api_field_names.rb
20140410121200_add_unique_index_for_api_key.rb
20140416085500_move_discoverable_on_cameras.rb
20140425115800_add_camera_share_requests.rb
20140428155200_foreign_key_changes.rb
20140506153000_drop_access_rights_unique_key.rb
20140515114800_add_extra_field_to_camera_activities.rb
20140519134100_remove_unique_index_from_camera_share_requests.rb
20140619121800_change_forename_to_firstname.rb
20140623151800_add_preview_to_camera.rb
20140715094603_add_admin_to_users.rb
20140813090207_add_webhooks.rb
20140819123000_add_model_exid.rb
20150205000707_billing_id.rb
20150223152949_add_thumbnail_url_to_camera.rb
20150506112500_create_add_ons.rb
20150506150500_change_billing_id_to_stripe_custome_id.rb
20150617150500_add_specs_vendor_models.rb
20150617150501_add_specs_vendor_models2.rb
20150619120000_add_shape_vendor_models.rb
20150619130000_add_specs_columns_vendor_models.rb
20150619140000_add_config_columns_vendor_models.rb
20150624150500_add_message_in_camera_share.rb
20150624150500_add_message_in_camera_share_requests.rb
20150708110000_create_archive_table.rb
20150722062320_add_apps.rb
\.


--
-- Data for Name: snapshots; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY snapshots (id, camera_id, created_at, notes, data, is_public) FROM stdin;
\.


--
-- Name: snapshots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('snapshots_id_seq', 1, false);


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Name: sq_access_tokens; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('sq_access_tokens', 1, false);


--
-- Name: sq_access_tokens_streams_rights; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('sq_access_tokens_streams_rights', 1, false);


--
-- Name: sq_clients; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('sq_clients', 1, false);


--
-- Name: sq_countries; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('sq_countries', 1, true);


--
-- Name: sq_devices; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('sq_devices', 1, false);


--
-- Name: sq_firmwares; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('sq_firmwares', 1, false);


--
-- Name: sq_streams; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('sq_streams', 1, true);


--
-- Name: sq_users; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('sq_users', 1, true);


--
-- Name: sq_vendors; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('sq_vendors', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY users (id, created_at, updated_at, firstname, lastname, username, password, country_id, confirmed_at, email, reset_token, token_expires_at, api_id, api_key, is_admin, billing_id, stripe_customer_id) FROM stdin;
1	2015-07-29 09:19:16.409397+00	2015-07-29 09:19:16.409399+00	Evercam	Admin	evercam	$2a$10$aBOPvVDuCIEDvROx0oXF7uTtZR035d8xDEAm3.GA72f1wGc.vLj4W	1	2015-07-29 09:19:16.409395+00	howrya@evercam.io	\N	\N	\N	\N	f	\N	\N
\.


--
-- Data for Name: vendor_models; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY vendor_models (id, created_at, updated_at, vendor_id, name, config, exid, jpg_url, h264_url, mjpg_url, shape, resolution, official_url, audio_url, more_info, poe, wifi, onvif, psia, ptz, infrared, varifocal, sd_card, upnp, audio_io, discontinued, username, password) FROM stdin;
\.


--
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY vendors (id, created_at, updated_at, exid, known_macs, name) FROM stdin;
\.


--
-- Data for Name: webhooks; Type: TABLE DATA; Schema: public; Owner: vagrant
--

COPY webhooks (id, camera_id, user_id, url, exid, created_at, updated_at) FROM stdin;
\.


--
-- Name: webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: vagrant
--

SELECT pg_catalog.setval('webhooks_id_seq', 1, false);


--
-- Name: access_rights_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY access_rights
    ADD CONSTRAINT access_rights_pkey PRIMARY KEY (id);


--
-- Name: add_ons_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY add_ons
    ADD CONSTRAINT add_ons_pkey PRIMARY KEY (id);


--
-- Name: apps_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (id);


--
-- Name: archives_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY archives
    ADD CONSTRAINT archives_pkey PRIMARY KEY (id);


--
-- Name: camera_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY camera_activities
    ADD CONSTRAINT camera_activities_pkey PRIMARY KEY (id);


--
-- Name: camera_endpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY camera_endpoints
    ADD CONSTRAINT camera_endpoints_pkey PRIMARY KEY (id);


--
-- Name: camera_share_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY camera_share_requests
    ADD CONSTRAINT camera_share_requests_pkey PRIMARY KEY (id);


--
-- Name: camera_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY camera_shares
    ADD CONSTRAINT camera_shares_pkey PRIMARY KEY (id);


--
-- Name: pk_access_tokens; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT pk_access_tokens PRIMARY KEY (id);


--
-- Name: pk_clients; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT pk_clients PRIMARY KEY (id);


--
-- Name: pk_countries; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT pk_countries PRIMARY KEY (id);


--
-- Name: pk_firmwares; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY vendor_models
    ADD CONSTRAINT pk_firmwares PRIMARY KEY (id);


--
-- Name: pk_streams; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY cameras
    ADD CONSTRAINT pk_streams PRIMARY KEY (id);


--
-- Name: pk_users; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: pk_vendors; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY vendors
    ADD CONSTRAINT pk_vendors PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (id);


--
-- Name: webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: vagrant; Tablespace:
--

ALTER TABLE ONLY webhooks
    ADD CONSTRAINT webhooks_pkey PRIMARY KEY (id);


--
-- Name: access_rights_camera_id_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX access_rights_camera_id_index ON access_rights USING btree (camera_id);


--
-- Name: access_rights_token_id_camera_id_right_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX access_rights_token_id_camera_id_right_index ON access_rights USING btree (token_id, camera_id, "right");


--
-- Name: access_rights_token_id_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX access_rights_token_id_index ON access_rights USING btree (token_id);


--
-- Name: camera_activities_camera_id_done_at_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX camera_activities_camera_id_done_at_index ON camera_activities USING btree (camera_id, done_at);


--
-- Name: camera_endpoints_camera_id_scheme_host_port_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX camera_endpoints_camera_id_scheme_host_port_index ON camera_endpoints USING btree (camera_id, scheme, host, port);


--
-- Name: camera_share_requests_camera_id_email_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX camera_share_requests_camera_id_email_index ON camera_share_requests USING btree (camera_id, email);


--
-- Name: camera_share_requests_key_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX camera_share_requests_key_index ON camera_share_requests USING btree (key);


--
-- Name: camera_shares_camera_id_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX camera_shares_camera_id_index ON camera_shares USING btree (camera_id);


--
-- Name: camera_shares_camera_id_user_id_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX camera_shares_camera_id_user_id_index ON camera_shares USING btree (camera_id, user_id);


--
-- Name: camera_shares_user_id_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX camera_shares_user_id_index ON camera_shares USING btree (user_id);


--
-- Name: cameras_mac_address_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX cameras_mac_address_index ON cameras USING btree (mac_address);


--
-- Name: ix_access_tokens_grantee_id; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX ix_access_tokens_grantee_id ON access_tokens USING btree (client_id);


--
-- Name: ix_access_tokens_grantor_id; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX ix_access_tokens_grantor_id ON access_tokens USING btree (user_id);


--
-- Name: ix_firmwares_vendor_id; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX ix_firmwares_vendor_id ON vendor_models USING btree (vendor_id);


--
-- Name: ix_streams_owner_id; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX ix_streams_owner_id ON cameras USING btree (owner_id);


--
-- Name: ix_users_country_id; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX ix_users_country_id ON users USING btree (country_id);


--
-- Name: snapshots_created_at_camera_id_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX snapshots_created_at_camera_id_index ON snapshots USING btree (created_at, camera_id);


--
-- Name: users_api_id_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX users_api_id_index ON users USING btree (api_id);


--
-- Name: ux_access_tokens_request; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX ux_access_tokens_request ON access_tokens USING btree (request);


--
-- Name: ux_clients_exid; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX ux_clients_exid ON clients USING btree (api_id);


--
-- Name: ux_countries_iso3166_a2; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX ux_countries_iso3166_a2 ON countries USING btree (iso3166_a2);


--
-- Name: ux_streams_name; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX ux_streams_name ON cameras USING btree (exid);


--
-- Name: ux_users_email; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX ux_users_email ON users USING btree (email);


--
-- Name: ux_users_username; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX ux_users_username ON users USING btree (username);


--
-- Name: ux_vendors_exid; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX ux_vendors_exid ON vendors USING btree (exid);


--
-- Name: vendor_models_exid_index; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE UNIQUE INDEX vendor_models_exid_index ON vendor_models USING btree (exid);


--
-- Name: vx_vendors_known_macs; Type: INDEX; Schema: public; Owner: vagrant; Tablespace:
--

CREATE INDEX vx_vendors_known_macs ON vendors USING gin (known_macs);


--
-- Name: access_rights_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY access_rights
    ADD CONSTRAINT access_rights_account_id_fkey FOREIGN KEY (account_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: access_rights_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY access_rights
    ADD CONSTRAINT access_rights_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id) ON DELETE CASCADE;


--
-- Name: access_rights_grantor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY access_rights
    ADD CONSTRAINT access_rights_grantor_id_fkey FOREIGN KEY (grantor_id) REFERENCES users(id);


--
-- Name: access_rights_snapshot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY access_rights
    ADD CONSTRAINT access_rights_snapshot_id_fkey FOREIGN KEY (snapshot_id) REFERENCES snapshots(id) ON DELETE CASCADE;


--
-- Name: access_rights_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY access_rights
    ADD CONSTRAINT access_rights_token_id_fkey FOREIGN KEY (token_id) REFERENCES access_tokens(id) ON DELETE CASCADE;


--
-- Name: access_tokens_grantor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT access_tokens_grantor_id_fkey FOREIGN KEY (grantor_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: add_ons_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY add_ons
    ADD CONSTRAINT add_ons_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: apps_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY apps
    ADD CONSTRAINT apps_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id) ON DELETE CASCADE;


--
-- Name: archives_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY archives
    ADD CONSTRAINT archives_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id) ON DELETE CASCADE;


--
-- Name: archives_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY archives
    ADD CONSTRAINT archives_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: camera_activities_access_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_activities
    ADD CONSTRAINT camera_activities_access_token_id_fkey FOREIGN KEY (access_token_id) REFERENCES access_tokens(id) ON DELETE CASCADE;


--
-- Name: camera_activities_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_activities
    ADD CONSTRAINT camera_activities_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id) ON DELETE CASCADE;


--
-- Name: camera_endpoints_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_endpoints
    ADD CONSTRAINT camera_endpoints_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id) ON DELETE CASCADE;


--
-- Name: camera_share_requests_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_share_requests
    ADD CONSTRAINT camera_share_requests_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id) ON DELETE CASCADE;


--
-- Name: camera_share_requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_share_requests
    ADD CONSTRAINT camera_share_requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: camera_shares_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_shares
    ADD CONSTRAINT camera_shares_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id) ON DELETE CASCADE;


--
-- Name: camera_shares_sharer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_shares
    ADD CONSTRAINT camera_shares_sharer_id_fkey FOREIGN KEY (sharer_id) REFERENCES users(id) ON DELETE SET NULL;


--
-- Name: camera_shares_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY camera_shares
    ADD CONSTRAINT camera_shares_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: cameras_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY cameras
    ADD CONSTRAINT cameras_model_id_fkey FOREIGN KEY (model_id) REFERENCES vendor_models(id);


--
-- Name: fk_access_tokens_grantee_id; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT fk_access_tokens_grantee_id FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE;


--
-- Name: fk_access_tokens_grantor_id; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY access_tokens
    ADD CONSTRAINT fk_access_tokens_grantor_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_firmwares_vendor_id; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY vendor_models
    ADD CONSTRAINT fk_firmwares_vendor_id FOREIGN KEY (vendor_id) REFERENCES vendors(id) ON DELETE CASCADE;


--
-- Name: fk_streams_owner_id; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY cameras
    ADD CONSTRAINT fk_streams_owner_id FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: fk_users_country_id; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_users_country_id FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE RESTRICT;


--
-- Name: snapshots_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY snapshots
    ADD CONSTRAINT snapshots_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id) ON DELETE CASCADE;


--
-- Name: webhooks_camera_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY webhooks
    ADD CONSTRAINT webhooks_camera_id_fkey FOREIGN KEY (camera_id) REFERENCES cameras(id) ON DELETE CASCADE;


--
-- Name: webhooks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vagrant
--

ALTER TABLE ONLY webhooks
    ADD CONSTRAINT webhooks_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

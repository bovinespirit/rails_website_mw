--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: beam_angles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE beam_angles (
    id integer NOT NULL,
    lantern_id integer NOT NULL,
    minangle double precision NOT NULL,
    maxangle double precision NOT NULL,
    optional boolean
);


--
-- Name: beam_angles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE beam_angles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: beam_angles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE beam_angles_id_seq OWNED BY beam_angles.id;


--
-- Name: comatose_pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comatose_pages (
    id integer NOT NULL,
    parent_id integer,
    full_path text,
    title character varying(255),
    slug character varying(255),
    keywords character varying(255),
    body text,
    filter_type character varying(25) DEFAULT 'Textile'::character varying,
    author character varying(255),
    "position" integer DEFAULT 0,
    updated_on timestamp without time zone,
    created_on timestamp without time zone,
    menu_title character varying(255),
    version integer
);


--
-- Name: comatose_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comatose_pages_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: comatose_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comatose_pages_id_seq OWNED BY comatose_pages.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contacts (
    id integer NOT NULL,
    updated_at timestamp without time zone,
    method_name character varying(255),
    fn character varying(255),
    organisation boolean DEFAULT false,
    xfn character varying(255),
    href character varying(255)
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: currents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE currents (
    id integer NOT NULL,
    lantern_id integer NOT NULL,
    voltage integer DEFAULT 230 NOT NULL,
    current double precision NOT NULL,
    frequency integer DEFAULT 50 NOT NULL
);


--
-- Name: currents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE currents_id_seq
    START WITH 78
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: currents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE currents_id_seq OWNED BY currents.id;


--
-- Name: dmx_channels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dmx_channels (
    id integer NOT NULL,
    lantern_id integer NOT NULL,
    "mode" character varying(255) DEFAULT 'DMX'::character varying NOT NULL,
    channels integer DEFAULT 0 NOT NULL,
    description character varying(255)
);


--
-- Name: dmx_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dmx_channels_id_seq
    START WITH 52
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: dmx_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dmx_channels_id_seq OWNED BY dmx_channels.id;


--
-- Name: error_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE error_messages (
    id integer NOT NULL,
    error character varying(16) DEFAULT 'ERROR'::character varying NOT NULL,
    name character varying(255) DEFAULT 'name'::character varying NOT NULL,
    short_description character varying(255) DEFAULT 'No Description'::character varying NOT NULL,
    long_description text
);


--
-- Name: error_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE error_messages_id_seq
    START WITH 113
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: error_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE error_messages_id_seq OWNED BY error_messages.id;


--
-- Name: error_messages_lanterns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE error_messages_lanterns (
    lantern_id integer NOT NULL,
    error_message_id integer NOT NULL
);


--
-- Name: gobo_sizes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gobo_sizes (
    id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL
);


--
-- Name: gobo_sizes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gobo_sizes_id_seq
    START WITH 8
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gobo_sizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gobo_sizes_id_seq OWNED BY gobo_sizes.id;


--
-- Name: gobo_wheel_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gobo_wheel_types (
    id integer NOT NULL,
    name character varying(255) DEFAULT 'New Wheel'::character varying NOT NULL
);


--
-- Name: gobo_wheel_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gobo_wheel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gobo_wheel_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gobo_wheel_types_id_seq OWNED BY gobo_wheel_types.id;


--
-- Name: gobo_wheel_types_lanterns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gobo_wheel_types_lanterns (
    lantern_id integer NOT NULL,
    gobo_wheel_type_id integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL
);


--
-- Name: gobo_wheels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gobo_wheels (
    id integer NOT NULL,
    gobo_wheel_type_id integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    gobo_size_id integer NOT NULL,
    "comment" text
);


--
-- Name: gobo_wheels_gobos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gobo_wheels_gobos (
    id integer NOT NULL,
    gobo_id integer NOT NULL,
    gobo_wheel_id integer NOT NULL,
    "position" integer NOT NULL
);


--
-- Name: gobo_wheels_gobos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gobo_wheels_gobos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gobo_wheels_gobos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gobo_wheels_gobos_id_seq OWNED BY gobo_wheels_gobos.id;


--
-- Name: gobo_wheels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gobo_wheels_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gobo_wheels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gobo_wheels_id_seq OWNED BY gobo_wheels.id;


--
-- Name: gobo_wheels_lanterns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gobo_wheels_lanterns (
    gobo_wheel_id integer NOT NULL,
    lantern_id integer NOT NULL
);


--
-- Name: gobos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gobos (
    id integer NOT NULL,
    number character varying(10),
    description character varying(255) DEFAULT '- none -'::character varying NOT NULL,
    manufacturer_id integer
);


--
-- Name: gobos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gobos_id_seq
    START WITH 163
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gobos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gobos_id_seq OWNED BY gobos.id;


--
-- Name: lamps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lamps (
    id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    power integer DEFAULT 0 NOT NULL,
    life integer,
    "temp" integer,
    manufacturer_id integer
);


--
-- Name: lamps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lamps_id_seq
    START WITH 15
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: lamps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lamps_id_seq OWNED BY lamps.id;


--
-- Name: lamps_lanterns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lamps_lanterns (
    lantern_id integer NOT NULL,
    lamp_id integer NOT NULL
);


--
-- Name: lantern_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lantern_types (
    id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL
);


--
-- Name: lantern_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lantern_types_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: lantern_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lantern_types_id_seq OWNED BY lantern_types.id;


--
-- Name: lanterns; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lanterns (
    id integer NOT NULL,
    name character varying(255) DEFAULT 'NEW LANTERN'::character varying NOT NULL,
    weight double precision,
    lantern_type_id integer DEFAULT 1 NOT NULL,
    manufacturer_id integer
);


--
-- Name: lanterns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lanterns_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: lanterns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lanterns_id_seq OWNED BY lanterns.id;


--
-- Name: lanterns_notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lanterns_notes (
    lantern_id integer NOT NULL,
    note_id integer NOT NULL
);


--
-- Name: lastfm_charts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lastfm_charts (
    id integer NOT NULL,
    "from" timestamp without time zone,
    overall boolean,
    most_recent boolean
);


--
-- Name: lastfm_charts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lastfm_charts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: lastfm_charts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lastfm_charts_id_seq OWNED BY lastfm_charts.id;


--
-- Name: lastfm_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lastfm_items (
    id integer NOT NULL,
    lastfm_chart_id integer NOT NULL,
    "position" integer NOT NULL,
    name character varying(255)
);


--
-- Name: lastfm_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE lastfm_items_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: lastfm_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE lastfm_items_id_seq OWNED BY lastfm_items.id;


--
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE manufacturers (
    id integer NOT NULL,
    www character varying(255),
    name character varying(255) NOT NULL
);


--
-- Name: manufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE manufacturers_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: manufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE manufacturers_id_seq OWNED BY manufacturers.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notes (
    id integer NOT NULL,
    title character varying(255) DEFAULT 'Title'::character varying NOT NULL,
    note text NOT NULL
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: page_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE page_versions (
    id integer NOT NULL,
    page_id integer,
    version integer,
    parent_id integer,
    full_path text,
    title character varying(255),
    slug character varying(255),
    keywords character varying(255),
    body text,
    filter_type character varying(25) DEFAULT 'Textile'::character varying,
    author character varying(255),
    "position" integer DEFAULT 0,
    updated_on timestamp without time zone,
    created_on timestamp without time zone,
    menu_title character varying(255)
);


--
-- Name: page_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE page_versions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: page_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE page_versions_id_seq OWNED BY page_versions.id;


--
-- Name: photo_data; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE photo_data (
    id integer NOT NULL,
    data bytea,
    photo_id integer
);


--
-- Name: photo_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE photo_data_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: photo_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE photo_data_id_seq OWNED BY photo_data.id;


--
-- Name: photo_sets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE photo_sets (
    id integer NOT NULL,
    page_id integer DEFAULT 0,
    page_type character varying(255),
    contents_photo_id integer,
    title character varying(255)
);


--
-- Name: photo_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE photo_sets_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: photo_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE photo_sets_id_seq OWNED BY photo_sets.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE photos (
    id integer NOT NULL,
    title character varying(255),
    slug character varying(255),
    description character varying(255),
    updated_on timestamp without time zone,
    created_on timestamp without time zone,
    text text,
    thumb_x integer DEFAULT 0,
    thumb_y integer DEFAULT 0,
    thumb_l integer DEFAULT 0,
    thumb_vertical boolean DEFAULT false,
    width integer DEFAULT 0,
    height integer DEFAULT 0,
    camera_model character varying(255) DEFAULT 'No data'::character varying,
    aperture double precision DEFAULT 0.0,
    exposure character varying(255) DEFAULT 'No data'::character varying,
    focal_length double precision DEFAULT 0.0,
    metering character varying(255) DEFAULT 'No data'::character varying,
    processed_with_gimp boolean DEFAULT false,
    vague_created_date boolean DEFAULT false
);


--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE photos_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: photos_photo_sets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE photos_photo_sets (
    id integer NOT NULL,
    photo_id integer,
    photo_set_id integer,
    "position" integer
);


--
-- Name: photos_photo_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE photos_photo_sets_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: photos_photo_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE photos_photo_sets_id_seq OWNED BY photos_photo_sets.id;


--
-- Name: post_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE post_versions (
    id integer NOT NULL,
    post_id integer,
    version integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying(255),
    body text,
    staging boolean DEFAULT true
);


--
-- Name: post_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_versions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: post_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_versions_id_seq OWNED BY post_versions.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying(255),
    body text,
    staging boolean DEFAULT true,
    version integer
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: redirections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE redirections (
    id integer NOT NULL,
    uri character varying(255),
    targetable_id integer,
    targetable_type character varying(255)
);


--
-- Name: redirections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE redirections_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: redirections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE redirections_id_seq OWNED BY redirections.id;


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_info (
    version integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying(255),
    data text,
    updated_at timestamp without time zone
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE beam_angles ALTER COLUMN id SET DEFAULT nextval('beam_angles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE comatose_pages ALTER COLUMN id SET DEFAULT nextval('comatose_pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE currents ALTER COLUMN id SET DEFAULT nextval('currents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE dmx_channels ALTER COLUMN id SET DEFAULT nextval('dmx_channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE error_messages ALTER COLUMN id SET DEFAULT nextval('error_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE gobo_sizes ALTER COLUMN id SET DEFAULT nextval('gobo_sizes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE gobo_wheel_types ALTER COLUMN id SET DEFAULT nextval('gobo_wheel_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE gobo_wheels ALTER COLUMN id SET DEFAULT nextval('gobo_wheels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE gobo_wheels_gobos ALTER COLUMN id SET DEFAULT nextval('gobo_wheels_gobos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE gobos ALTER COLUMN id SET DEFAULT nextval('gobos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE lamps ALTER COLUMN id SET DEFAULT nextval('lamps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE lantern_types ALTER COLUMN id SET DEFAULT nextval('lantern_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE lanterns ALTER COLUMN id SET DEFAULT nextval('lanterns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE lastfm_charts ALTER COLUMN id SET DEFAULT nextval('lastfm_charts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE lastfm_items ALTER COLUMN id SET DEFAULT nextval('lastfm_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE manufacturers ALTER COLUMN id SET DEFAULT nextval('manufacturers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE page_versions ALTER COLUMN id SET DEFAULT nextval('page_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE photo_data ALTER COLUMN id SET DEFAULT nextval('photo_data_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE photo_sets ALTER COLUMN id SET DEFAULT nextval('photo_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE photos_photo_sets ALTER COLUMN id SET DEFAULT nextval('photos_photo_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE post_versions ALTER COLUMN id SET DEFAULT nextval('post_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE redirections ALTER COLUMN id SET DEFAULT nextval('redirections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: beam_angles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY beam_angles
    ADD CONSTRAINT beam_angles_pkey PRIMARY KEY (id);


--
-- Name: comatose_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comatose_pages
    ADD CONSTRAINT comatose_pages_pkey PRIMARY KEY (id);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: currents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY currents
    ADD CONSTRAINT currents_pkey PRIMARY KEY (id);


--
-- Name: dmx_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dmx_channels
    ADD CONSTRAINT dmx_channels_pkey PRIMARY KEY (id);


--
-- Name: error_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY error_messages
    ADD CONSTRAINT error_messages_pkey PRIMARY KEY (id);


--
-- Name: gobo_sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gobo_sizes
    ADD CONSTRAINT gobo_sizes_pkey PRIMARY KEY (id);


--
-- Name: gobo_wheel_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gobo_wheel_types
    ADD CONSTRAINT gobo_wheel_types_pkey PRIMARY KEY (id);


--
-- Name: gobo_wheels_gobos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gobo_wheels_gobos
    ADD CONSTRAINT gobo_wheels_gobos_pkey PRIMARY KEY (id);


--
-- Name: gobo_wheels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gobo_wheels
    ADD CONSTRAINT gobo_wheels_pkey PRIMARY KEY (id);


--
-- Name: gobos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gobos
    ADD CONSTRAINT gobos_pkey PRIMARY KEY (id);


--
-- Name: lamps_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lamps
    ADD CONSTRAINT lamps_pkey PRIMARY KEY (id);


--
-- Name: lantern_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lantern_types
    ADD CONSTRAINT lantern_types_pkey PRIMARY KEY (id);


--
-- Name: lanterns_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lanterns
    ADD CONSTRAINT lanterns_pkey PRIMARY KEY (id);


--
-- Name: lastfm_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lastfm_charts
    ADD CONSTRAINT lastfm_charts_pkey PRIMARY KEY (id);


--
-- Name: lastfm_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lastfm_items
    ADD CONSTRAINT lastfm_items_pkey PRIMARY KEY (id);


--
-- Name: manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: page_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY page_versions
    ADD CONSTRAINT page_versions_pkey PRIMARY KEY (id);


--
-- Name: photo_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY photo_data
    ADD CONSTRAINT photo_data_pkey PRIMARY KEY (id);


--
-- Name: photo_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY photo_sets
    ADD CONSTRAINT photo_sets_pkey PRIMARY KEY (id);


--
-- Name: photos_photo_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY photos_photo_sets
    ADD CONSTRAINT photos_photo_sets_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: post_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY post_versions
    ADD CONSTRAINT post_versions_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: redirections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY redirections
    ADD CONSTRAINT redirections_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: beam_angles_lantern_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX beam_angles_lantern_id_key ON beam_angles USING btree (lantern_id, minangle, maxangle);


--
-- Name: currents_lantern_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX currents_lantern_id_key ON currents USING btree (lantern_id, voltage, frequency);


--
-- Name: dmx_channels_lantern_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dmx_channels_lantern_id_key ON dmx_channels USING btree (lantern_id, "mode");


--
-- Name: gobo_sizes_name_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX gobo_sizes_name_key ON gobo_sizes USING btree (name);


--
-- Name: gobo_wheels_name_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX gobo_wheels_name_key ON gobo_wheel_types USING btree (name);


--
-- Name: gobos_gobo_wheels_gobo_wheel_position_ukey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX gobos_gobo_wheels_gobo_wheel_position_ukey ON gobo_wheels_gobos USING btree (gobo_wheel_id, "position");


--
-- Name: index_photo_data_on_photo_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photo_data_on_photo_id ON photo_data USING btree (photo_id);


--
-- Name: index_photo_sets_on_page_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photo_sets_on_page_type ON photo_sets USING btree (page_type);


--
-- Name: index_taggings_on_tag_id_and_taggable_id_and_taggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id_and_taggable_id_and_taggable_type ON taggings USING btree (tag_id, taggable_id, taggable_type);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tags_on_name ON tags USING btree (name);


--
-- Name: lantern_types_name_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX lantern_types_name_key ON lantern_types USING btree (name);


--
-- Name: manufacturers_name_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX manufacturers_name_key ON manufacturers USING btree (name);


--
-- Name: sessions_session_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX sessions_session_id_index ON sessions USING btree (session_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('37');

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('15');

INSERT INTO schema_migrations (version) VALUES ('16');

INSERT INTO schema_migrations (version) VALUES ('17');

INSERT INTO schema_migrations (version) VALUES ('18');

INSERT INTO schema_migrations (version) VALUES ('19');

INSERT INTO schema_migrations (version) VALUES ('20');

INSERT INTO schema_migrations (version) VALUES ('21');

INSERT INTO schema_migrations (version) VALUES ('22');

INSERT INTO schema_migrations (version) VALUES ('23');

INSERT INTO schema_migrations (version) VALUES ('24');

INSERT INTO schema_migrations (version) VALUES ('25');

INSERT INTO schema_migrations (version) VALUES ('26');

INSERT INTO schema_migrations (version) VALUES ('27');

INSERT INTO schema_migrations (version) VALUES ('28');

INSERT INTO schema_migrations (version) VALUES ('29');

INSERT INTO schema_migrations (version) VALUES ('30');

INSERT INTO schema_migrations (version) VALUES ('31');

INSERT INTO schema_migrations (version) VALUES ('32');

INSERT INTO schema_migrations (version) VALUES ('33');

INSERT INTO schema_migrations (version) VALUES ('34');

INSERT INTO schema_migrations (version) VALUES ('35');

INSERT INTO schema_migrations (version) VALUES ('36');

INSERT INTO schema_migrations (version) VALUES ('20081212001455');
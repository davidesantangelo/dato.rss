SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: callbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.callbacks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    url character varying NOT NULL,
    events character varying[] NOT NULL,
    token_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    feed_id uuid,
    title character varying,
    body text,
    url character varying,
    external_id character varying,
    categories character varying[],
    annotations jsonb,
    sentiment jsonb,
    published_at timestamp without time zone,
    enriched_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    searchable tsvector GENERATED ALWAYS AS (((setweight(to_tsvector('simple'::regconfig, (COALESCE(title, ''::character varying))::text), 'A'::"char") || setweight(to_tsvector('simple'::regconfig, COALESCE(body, ''::text)), 'B'::"char")) || setweight(to_tsvector('simple'::regconfig, (COALESCE(url, ''::character varying))::text), 'C'::"char"))) STORED
);


--
-- Name: feeds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feeds (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying,
    description text,
    image jsonb,
    url character varying,
    categories character varying[],
    rank double precision DEFAULT 0.0,
    status integer DEFAULT 0,
    entries_count integer DEFAULT 0,
    language character varying,
    last_import_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    feed_id uuid,
    start_import_at timestamp without time zone,
    end_import_at timestamp without time zone,
    entries_count integer,
    metadata jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key character varying,
    expires_at timestamp without time zone,
    active boolean DEFAULT true,
    permissions character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: callbacks callbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callbacks
    ADD CONSTRAINT callbacks_pkey PRIMARY KEY (id);


--
-- Name: entries entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: feeds feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feeds
    ADD CONSTRAINT feeds_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: index_callbacks_on_events; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_callbacks_on_events ON public.callbacks USING gin (events);


--
-- Name: index_callbacks_on_token_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_callbacks_on_token_id ON public.callbacks USING btree (token_id);


--
-- Name: index_callbacks_on_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_callbacks_on_url ON public.callbacks USING btree (url);


--
-- Name: index_callbacks_on_url_and_token_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_callbacks_on_url_and_token_id ON public.callbacks USING btree (url, token_id);


--
-- Name: index_entries_on_annotations; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entries_on_annotations ON public.entries USING gin (annotations);


--
-- Name: index_entries_on_categories; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entries_on_categories ON public.entries USING gin (categories);


--
-- Name: index_entries_on_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entries_on_external_id ON public.entries USING btree (external_id);


--
-- Name: index_entries_on_feed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entries_on_feed_id ON public.entries USING btree (feed_id);


--
-- Name: index_entries_on_feed_id_and_url; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_entries_on_feed_id_and_url ON public.entries USING btree (feed_id, url);


--
-- Name: index_entries_on_searchable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entries_on_searchable ON public.entries USING gin (searchable);


--
-- Name: index_entries_on_sentiment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entries_on_sentiment ON public.entries USING gin (sentiment);


--
-- Name: index_entries_on_url; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_entries_on_url ON public.entries USING btree (url);


--
-- Name: index_feeds_on_categories; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feeds_on_categories ON public.feeds USING gin (categories);


--
-- Name: index_feeds_on_language; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feeds_on_language ON public.feeds USING btree (language);


--
-- Name: index_feeds_on_url; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_feeds_on_url ON public.feeds USING btree (url);


--
-- Name: index_logs_on_feed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_logs_on_feed_id ON public.logs USING btree (feed_id);


--
-- Name: index_logs_on_metadata; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_logs_on_metadata ON public.logs USING gin (metadata);


--
-- Name: index_tokens_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tokens_on_key ON public.tokens USING btree (key);


--
-- Name: entries fk_rails_05dc0aaac4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_rails_05dc0aaac4 FOREIGN KEY (feed_id) REFERENCES public.feeds(id);


--
-- Name: logs fk_rails_566328d60e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT fk_rails_566328d60e FOREIGN KEY (feed_id) REFERENCES public.feeds(id);


--
-- Name: callbacks fk_rails_ad03a58b2c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.callbacks
    ADD CONSTRAINT fk_rails_ad03a58b2c FOREIGN KEY (token_id) REFERENCES public.tokens(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190319140432'),
('20190319140459'),
('20190319140556'),
('20190326082517'),
('20190326135943'),
('20190429122649'),
('20210129080659'),
('20210129085830'),
('20210203105050'),
('20210511100138');



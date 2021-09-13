SET check_function_bodies = false;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.channels (
    id integer NOT NULL,
    external_id text NOT NULL,
    name text NOT NULL,
    is_premium boolean NOT NULL
);
CREATE SEQUENCE public.channels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.channels_id_seq OWNED BY public.channels.id;
CREATE TABLE public.movies (
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    imdb_id text NOT NULL,
    title text NOT NULL,
    year text NOT NULL,
    runtime text NOT NULL,
    genre text NOT NULL,
    director text NOT NULL,
    writer text NOT NULL,
    actors text NOT NULL,
    plot text NOT NULL,
    language text NOT NULL,
    country text NOT NULL,
    poster text NOT NULL,
    rating_imdb text,
    rating_rotten_tomatoes text,
    rating_metascore text,
    original_response json NOT NULL,
    id integer NOT NULL
);
CREATE SEQUENCE public.movie_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.movie_details_id_seq OWNED BY public.movies.id;
CREATE TABLE public.schedules (
    title text NOT NULL,
    plot text NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    duration integer NOT NULL,
    imdb_id text,
    id integer NOT NULL,
    channel_id integer NOT NULL,
    movie_id integer
);
CREATE SEQUENCE public.movies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.movies_id_seq OWNED BY public.schedules.id;
CREATE TABLE public.queued_channels (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    channel_id integer NOT NULL,
    is_complete boolean DEFAULT false NOT NULL,
    day date DEFAULT CURRENT_DATE NOT NULL,
    day_offset integer DEFAULT '-1'::integer NOT NULL
);
CREATE SEQUENCE public.queued_channels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.queued_channels_id_seq OWNED BY public.queued_channels.id;
ALTER TABLE ONLY public.channels ALTER COLUMN id SET DEFAULT nextval('public.channels_id_seq'::regclass);
ALTER TABLE ONLY public.movies ALTER COLUMN id SET DEFAULT nextval('public.movie_details_id_seq'::regclass);
ALTER TABLE ONLY public.queued_channels ALTER COLUMN id SET DEFAULT nextval('public.queued_channels_id_seq'::regclass);
ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.movies_id_seq'::regclass);
ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_external_id_key UNIQUE (external_id);
ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_id_key UNIQUE (id);
ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_imdb_id_key UNIQUE (imdb_id);
ALTER TABLE ONLY public.movies
    ADD CONSTRAINT movies_pkey PRIMARY KEY (imdb_id);
ALTER TABLE ONLY public.queued_channels
    ADD CONSTRAINT queued_channels_day_channel_id_day_offset_key UNIQUE (day, channel_id, day_offset);
ALTER TABLE ONLY public.queued_channels
    ADD CONSTRAINT queued_channels_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_id_key UNIQUE (id);
ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_start_time_channel_id_key UNIQUE (start_time, channel_id);
CREATE TRIGGER set_public_movies_updated_at BEFORE UPDATE ON public.movies FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_movies_updated_at ON public.movies IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_queued_channels_updated_at BEFORE UPDATE ON public.queued_channels FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_queued_channels_updated_at ON public.queued_channels IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.queued_channels
    ADD CONSTRAINT queued_channels_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_channel_id_fkey FOREIGN KEY (channel_id) REFERENCES public.channels(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_movie_id_fkey FOREIGN KEY (movie_id) REFERENCES public.movies(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

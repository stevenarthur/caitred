--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: customer_order_count_by_date(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION customer_order_count_by_date(start_date timestamp without time zone, end_date timestamp without time zone) RETURNS TABLE(customer_id uuid, order_count bigint)
    LANGUAGE plpgsql
    AS $$
      BEGIN
        return query
        select c.id as customer_id, COUNT(e.*) AS order_count
        from Customers c inner join Enquiries e
        on e.customer_id = c.id
        where e.status in ('Confirmed', 'Delivered', 'Completed')
        and e.created_at >= start_date
        and e.created_at <= end_date
        group by c.id;
      END;
      $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE addresses (
    id integer NOT NULL,
    line_1 character varying(255),
    line_2 character varying(255),
    suburb character varying(255),
    postcode character varying(255),
    parking_information text,
    "default" boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    customer_id uuid,
    company character varying(255)
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email_address character varying(255) NOT NULL,
    crypted_password character varying(255) NOT NULL,
    password_salt character varying(255) NOT NULL,
    persistence_token character varying(255) NOT NULL,
    mobile_number character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    is_power_user boolean NOT NULL
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: caitredette_service_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE caitredette_service_requests (
    id integer NOT NULL,
    name character varying,
    company_name character varying,
    email character varying,
    phone character varying,
    postcode character varying,
    preferred_communication_method character varying,
    message text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: caitredette_service_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE caitredette_service_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: caitredette_service_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE caitredette_service_requests_id_seq OWNED BY caitredette_service_requests.id;


--
-- Name: status_audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE status_audits (
    id integer NOT NULL,
    enquiry_id integer,
    old_status character varying(255),
    new_status character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: completed_enquiries; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW completed_enquiries AS
 SELECT DISTINCT ON (status_audits.enquiry_id) status_audits.id,
    status_audits.enquiry_id,
    status_audits.old_status,
    status_audits.new_status,
    status_audits.created_at,
    status_audits.updated_at
   FROM status_audits
  WHERE ((status_audits.new_status)::text = 'Completed'::text)
  ORDER BY status_audits.enquiry_id, status_audits.created_at DESC;


--
-- Name: enquiries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE enquiries (
    id integer NOT NULL,
    food_partner_id integer,
    logistics json,
    event json,
    status character varying(255),
    additional_messages text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    source character varying(255),
    menu json,
    terms_accepted boolean,
    menu_extras_old character varying(255)[],
    dietary_requirements json,
    menu_content text,
    menu_extras json,
    address_id integer,
    price_per_head numeric(8,2),
    delivery_cost numeric(8,2),
    total_cost numeric(8,2),
    total_cost_to_us numeric(8,2),
    customer_id uuid,
    confirmation_token character varying(255),
    confirmation_token_created timestamp without time zone,
    menu_title character varying(255),
    customer_menu_content character varying(255),
    total_amount_paid numeric(8,2),
    payment_fee_paid numeric(8,2),
    payment_method character varying(255) DEFAULT 'Credit Card'::character varying,
    paid boolean,
    food_cost_to_us numeric(8,2),
    delivery_cost_to_us numeric(8,2),
    stripe_customer_token character varying(255),
    stripe_payment_id character varying(255),
    extras_cost numeric(8,2),
    gst_paid numeric(8,2),
    xero_invoice_id character varying(255),
    event_time time without time zone,
    event_date date,
    number_of_attendees integer,
    partner_reminder_sent boolean DEFAULT false NOT NULL,
    feedback_email_sent boolean DEFAULT false NOT NULL,
    supplier_xero_invoice_id character varying
);


--
-- Name: confirmed_enquiries; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW confirmed_enquiries AS
 SELECT DISTINCT ON (s.enquiry_id) e.id,
    e.food_partner_id AS food_artisan_id,
    e.logistics,
    e.event,
    e.status,
    e.additional_messages,
    e.created_at,
    e.updated_at,
    e.source,
    e.menu,
    e.terms_accepted,
    e.menu_extras_old,
    e.dietary_requirements,
    e.menu_content,
    e.menu_extras,
    e.address_id,
    e.price_per_head,
    e.delivery_cost,
    e.total_cost,
    e.total_cost_to_us,
    e.customer_id,
    e.confirmation_token,
    e.confirmation_token_created,
    e.menu_title,
    e.customer_menu_content,
    e.total_amount_paid,
    e.payment_fee_paid,
    e.payment_method,
    e.paid,
    e.food_cost_to_us,
    e.delivery_cost_to_us,
    s.created_at AS confirmed_at
   FROM (status_audits s
     JOIN enquiries e ON ((s.enquiry_id = e.id)))
  WHERE (((s.new_status)::text = 'Confirmed'::text) AND ((e.status)::text = ANY (ARRAY[('Confirmed'::character varying)::text, ('Delivered'::character varying)::text, ('Completed'::character varying)::text])))
  ORDER BY s.enquiry_id, s.created_at;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE contacts (
    id integer NOT NULL,
    company character varying(255),
    name character varying(255),
    email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE customers (
    id_number integer NOT NULL,
    first_name character varying(255),
    company_name character varying(255),
    telephone character varying(255),
    email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    preferences json,
    last_name character varying(255),
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    crypted_password character varying(255),
    password_salt character varying(255),
    persistence_token character varying(255),
    login_count integer DEFAULT 0 NOT NULL,
    failed_login_count integer DEFAULT 0 NOT NULL,
    last_request_at timestamp without time zone,
    current_login_at timestamp without time zone,
    last_login_at timestamp without time zone,
    current_login_ip character varying(255),
    last_login_ip character varying(255),
    created_account boolean DEFAULT false NOT NULL,
    password_reset_token character varying(255),
    reset_token_created timestamp without time zone,
    provider character varying(255),
    additional_first_name character varying,
    additional_last_name character varying,
    additional_email character varying,
    additional_telephone character varying
);


--
-- Name: customer_order_count; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW customer_order_count AS
 SELECT c.id,
    c.first_name,
    c.last_name,
    c.email,
    c.created_at,
    count(e.*) AS count
   FROM (customers c
     JOIN enquiries e ON ((e.customer_id = c.id)))
  WHERE (((e.status)::text = ANY (ARRAY[('Confirmed'::character varying)::text, ('Delivered'::character varying)::text, ('Completed'::character varying)::text])) AND (e.created_at > (now() - '1 year'::interval)))
  GROUP BY c.id, c.first_name, c.last_name, c.email, c.created_at;


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id_number;


--
-- Name: delivery_areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE delivery_areas (
    id integer NOT NULL,
    title character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delivery_areas_food_partners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE delivery_areas_food_partners (
    id integer NOT NULL,
    food_partner_id integer,
    delivery_area_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delivery_areas_food_partners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delivery_areas_food_partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_areas_food_partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delivery_areas_food_partners_id_seq OWNED BY delivery_areas_food_partners.id;


--
-- Name: delivery_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delivery_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delivery_areas_id_seq OWNED BY delivery_areas.id;


--
-- Name: delivery_hours; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE delivery_hours (
    id integer NOT NULL,
    hour_start time without time zone,
    hour_end time without time zone,
    food_partner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    day integer,
    start_time integer,
    end_time integer
);


--
-- Name: delivery_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delivery_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delivery_hours_id_seq OWNED BY delivery_hours.id;


--
-- Name: enquiries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE enquiries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: enquiries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE enquiries_id_seq OWNED BY enquiries.id;


--
-- Name: enquiry_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE enquiry_codes (
    id integer NOT NULL,
    enquiry_id integer NOT NULL,
    code character varying(255) NOT NULL,
    code_type character varying(255) NOT NULL
);


--
-- Name: enquiry_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE enquiry_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: enquiry_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE enquiry_codes_id_seq OWNED BY enquiry_codes.id;


--
-- Name: enquiry_event_date_and_attendees; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW enquiry_event_date_and_attendees AS
 SELECT enquiries.id,
    (enquiries.event -> 'attendees'::text) AS attendees,
    (enquiries.event -> 'event_date'::text) AS event_date,
    to_date((enquiries.event ->> 'event_date'::text), 'DD Month YYYY'::text) AS to_date
   FROM enquiries
  WHERE ((enquiries.status)::text = ANY (ARRAY[('Confirmed'::character varying)::text, ('Delivered'::character varying)::text, ('Completed'::character varying)::text]))
  ORDER BY enquiries.id;


--
-- Name: enquiry_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE enquiry_items (
    id integer NOT NULL,
    enquiry_id integer,
    packageable_item_id integer,
    unit_price numeric(8,2),
    quantity integer,
    total_price numeric(8,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_instructions text
);


--
-- Name: enquiry_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE enquiry_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: enquiry_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE enquiry_items_id_seq OWNED BY enquiry_items.id;


--
-- Name: food_partner_delivery_postcodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE food_partner_delivery_postcodes (
    id integer NOT NULL,
    food_partner_id integer NOT NULL,
    postcode_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: food_partner_delivery_postcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE food_partner_delivery_postcodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: food_partner_delivery_postcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE food_partner_delivery_postcodes_id_seq OWNED BY food_partner_delivery_postcodes.id;


--
-- Name: food_partners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE food_partners (
    id integer NOT NULL,
    company_name character varying(255),
    email character varying(255),
    location character varying(255),
    quick_description character varying(255),
    catering_options character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    contact_first_name character varying(255),
    contact_last_name character varying(255),
    image_file_name character varying(255),
    delivery_cost numeric(8,2),
    delivery_text character varying(255),
    availability_text character varying(255),
    minimum_spend numeric(8,2),
    minimum_attendees integer,
    maximum_attendees integer,
    url_slug character varying(255) DEFAULT ''::character varying,
    lead_time_hours integer,
    lowest_price_dish numeric(8,2),
    orders_per_week integer DEFAULT 0,
    phone_number character varying(255),
    bio text,
    category character varying(255),
    active boolean DEFAULT false,
    delivery_days character varying(255),
    delivery_hours json,
    price_low boolean DEFAULT false,
    price_medium boolean DEFAULT false,
    price_high boolean DEFAULT false,
    featured_image_file_name character varying,
    secondary_contact_first_name character varying,
    secondary_contact_last_name character varying,
    secondary_phone_number character varying,
    priority_order integer DEFAULT 999,
    address_line_1 character varying,
    address_line_2 character varying,
    suburb character varying,
    postcode character varying,
    need_to_know text,
    event_type text[] DEFAULT '{}'::text[],
    secondary_email character varying
);


--
-- Name: food_partners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE food_partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: food_partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE food_partners_id_seq OWNED BY food_partners.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: investment_leads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE investment_leads (
    id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone character varying,
    location character varying,
    invested_in_a_startup_previously boolean NOT NULL,
    typical_investment_size character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: investment_leads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE investment_leads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: investment_leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE investment_leads_id_seq OWNED BY investment_leads.id;


--
-- Name: menu_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE menu_categories (
    id integer NOT NULL,
    food_partner_id integer,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    sort_order integer DEFAULT 99,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: menu_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE menu_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: menu_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE menu_categories_id_seq OWNED BY menu_categories.id;


--
-- Name: menu_packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE menu_packages (
    id integer NOT NULL,
    menu_id integer,
    packageable_item_id integer,
    item_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_add_on boolean,
    is_alternative boolean DEFAULT false NOT NULL
);


--
-- Name: menu_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE menu_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: menu_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE menu_packages_id_seq OWNED BY menu_packages.id;


--
-- Name: menu_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE menu_tags (
    id integer NOT NULL,
    tag character varying(255),
    badge_url character varying(255),
    is_filter boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: menu_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE menu_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: menu_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE menu_tags_id_seq OWNED BY menu_tags.id;


--
-- Name: menus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE menus (
    id integer NOT NULL,
    food_partner_id integer,
    title character varying(255),
    price numeric(8,2),
    properties json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    menu_image_file_name character varying(255),
    active boolean,
    event_type character varying(255)[] DEFAULT '{}'::character varying[],
    description character varying(500),
    long_description character varying(1000),
    package_conditions character varying(500),
    minimum_attendees integer DEFAULT 1,
    tags character varying(255)[] DEFAULT '{}'::character varying[],
    url_slug character varying(255),
    priority_order integer DEFAULT 999 NOT NULL,
    dietary_properties character varying(255)[] DEFAULT '{}'::character varying[],
    how_to_serve character varying(255),
    meta_title character varying(255),
    meta_description character varying(255),
    info_sheet character varying(255),
    xero_item_id character varying(255)
);


--
-- Name: menus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE menus_id_seq OWNED BY menus.id;


--
-- Name: old_enquiry_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE old_enquiry_records (
    id integer NOT NULL,
    enquiry_id integer,
    logistics json,
    food json,
    extras json,
    budget json,
    event json
);


--
-- Name: old_enquiry_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_enquiry_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_enquiry_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_enquiry_records_id_seq OWNED BY old_enquiry_records.id;


--
-- Name: packageable_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE packageable_items (
    id integer NOT NULL,
    food_partner_id integer,
    title character varying(255),
    description character varying(500),
    cost numeric(8,2),
    properties json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    event_type character varying(255)[] DEFAULT '{}'::character varying[],
    item_type character varying(255),
    vegetarian boolean,
    vegan boolean,
    gluten_free boolean,
    active boolean DEFAULT false,
    halal boolean DEFAULT false,
    contains_nuts boolean DEFAULT false,
    minimum_order integer DEFAULT 1,
    maximum_order integer DEFAULT 200,
    xero_item_id character varying,
    what_you_get text,
    presentation character varying,
    package_conditions character varying,
    cost_to_youchews numeric(8,2),
    parent_id character varying,
    menu_category_id integer,
    sort_order integer DEFAULT 99 NOT NULL,
    vegetarian_options_available boolean DEFAULT false,
    gluten_free_options_available boolean DEFAULT false,
    is_package boolean DEFAULT false
);


--
-- Name: packageable_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE packageable_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: packageable_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE packageable_items_id_seq OWNED BY packageable_items.id;


--
-- Name: pictures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pictures (
    id integer NOT NULL,
    name character varying(255),
    cover boolean,
    alt_text character varying(255),
    imageable_id integer,
    imageable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pictures_id_seq OWNED BY pictures.id;


--
-- Name: poll_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE poll_answers (
    id uuid NOT NULL,
    poll_id uuid,
    answer_text character varying(255),
    "order" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: poll_votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE poll_votes (
    id uuid NOT NULL,
    poll_answer_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_identifier character varying(255)
);


--
-- Name: polls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE polls (
    id uuid NOT NULL,
    title character varying(255),
    description_html character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tag character varying(255)
);


--
-- Name: poll_votes_per_answer; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW poll_votes_per_answer AS
 SELECT polls.id AS poll_id,
    poll_answers.id AS poll_answer_id,
    poll_answers.answer_text,
    count(poll_votes.id) AS votes
   FROM ((polls
     JOIN poll_answers ON ((polls.id = poll_answers.poll_id)))
     LEFT JOIN poll_votes ON ((poll_answers.id = poll_votes.poll_answer_id)))
  GROUP BY polls.id, poll_answers.id, poll_answers.answer_text, poll_answers."order"
  ORDER BY poll_answers."order";


--
-- Name: postcode_leads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE postcode_leads (
    id integer NOT NULL,
    email character varying NOT NULL,
    postcode character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: postcode_leads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE postcode_leads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: postcode_leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE postcode_leads_id_seq OWNED BY postcode_leads.id;


--
-- Name: postcodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE postcodes (
    id integer NOT NULL,
    zipcode character varying(255),
    title character varying(255),
    state character varying(255),
    country character varying(255),
    delivery_area_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying
);


--
-- Name: postcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE postcodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: postcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE postcodes_id_seq OWNED BY postcodes.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE quotes (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    phone character varying(255),
    message text,
    food_partner_id integer,
    status character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    date date,
    postcode integer,
    spam boolean DEFAULT false,
    company character varying,
    number_of_people character varying,
    contact_method character varying
);


--
-- Name: quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quotes_id_seq OWNED BY quotes.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE requests (
    id integer NOT NULL,
    name character varying(255),
    company_name character varying(255),
    telephone character varying(255),
    email character varying(255),
    event_date timestamp without time zone,
    delivery_location character varying(255),
    type_of_event character varying(255),
    food_requests character varying(255),
    additional_messages character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    food_partner_id integer,
    unprocessable_info json,
    dietary_requirements json,
    extras json,
    budget character varying(255),
    amount_of_food character varying(255),
    status character varying(255),
    attendees json,
    event_format text
);


--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE requests_id_seq OWNED BY requests.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: status_audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE status_audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: status_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE status_audits_id_seq OWNED BY status_audits.id;


--
-- Name: supplier_communications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE supplier_communications (
    id integer NOT NULL,
    food_partner_id integer,
    enquiry_id integer,
    email_html text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    from_name character varying(255) NOT NULL,
    from_email character varying(255) NOT NULL,
    to_name character varying(255) NOT NULL,
    to_email character varying(255) NOT NULL,
    email_subject character varying(255),
    email_text text
);


--
-- Name: supplier_communications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE supplier_communications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_communications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE supplier_communications_id_seq OWNED BY supplier_communications.id;


--
-- Name: testimonials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE testimonials (
    id integer NOT NULL,
    text text,
    author character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    food_partner_id integer
);


--
-- Name: testimonials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE testimonials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: testimonials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE testimonials_id_seq OWNED BY testimonials.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: caitredette_service_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY caitredette_service_requests ALTER COLUMN id SET DEFAULT nextval('caitredette_service_requests_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: customers id_number; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers ALTER COLUMN id_number SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- Name: delivery_areas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delivery_areas ALTER COLUMN id SET DEFAULT nextval('delivery_areas_id_seq'::regclass);


--
-- Name: delivery_areas_food_partners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delivery_areas_food_partners ALTER COLUMN id SET DEFAULT nextval('delivery_areas_food_partners_id_seq'::regclass);


--
-- Name: delivery_hours id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delivery_hours ALTER COLUMN id SET DEFAULT nextval('delivery_hours_id_seq'::regclass);


--
-- Name: enquiries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiries ALTER COLUMN id SET DEFAULT nextval('enquiries_id_seq'::regclass);


--
-- Name: enquiry_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiry_codes ALTER COLUMN id SET DEFAULT nextval('enquiry_codes_id_seq'::regclass);


--
-- Name: enquiry_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiry_items ALTER COLUMN id SET DEFAULT nextval('enquiry_items_id_seq'::regclass);


--
-- Name: food_partner_delivery_postcodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY food_partner_delivery_postcodes ALTER COLUMN id SET DEFAULT nextval('food_partner_delivery_postcodes_id_seq'::regclass);


--
-- Name: food_partners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY food_partners ALTER COLUMN id SET DEFAULT nextval('food_partners_id_seq'::regclass);


--
-- Name: friendly_id_slugs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: investment_leads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY investment_leads ALTER COLUMN id SET DEFAULT nextval('investment_leads_id_seq'::regclass);


--
-- Name: menu_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_categories ALTER COLUMN id SET DEFAULT nextval('menu_categories_id_seq'::regclass);


--
-- Name: menu_packages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_packages ALTER COLUMN id SET DEFAULT nextval('menu_packages_id_seq'::regclass);


--
-- Name: menu_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_tags ALTER COLUMN id SET DEFAULT nextval('menu_tags_id_seq'::regclass);


--
-- Name: menus id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY menus ALTER COLUMN id SET DEFAULT nextval('menus_id_seq'::regclass);


--
-- Name: old_enquiry_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_enquiry_records ALTER COLUMN id SET DEFAULT nextval('old_enquiry_records_id_seq'::regclass);


--
-- Name: packageable_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY packageable_items ALTER COLUMN id SET DEFAULT nextval('packageable_items_id_seq'::regclass);


--
-- Name: pictures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pictures ALTER COLUMN id SET DEFAULT nextval('pictures_id_seq'::regclass);


--
-- Name: postcode_leads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY postcode_leads ALTER COLUMN id SET DEFAULT nextval('postcode_leads_id_seq'::regclass);


--
-- Name: postcodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY postcodes ALTER COLUMN id SET DEFAULT nextval('postcodes_id_seq'::regclass);


--
-- Name: quotes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes ALTER COLUMN id SET DEFAULT nextval('quotes_id_seq'::regclass);


--
-- Name: requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY requests ALTER COLUMN id SET DEFAULT nextval('requests_id_seq'::regclass);


--
-- Name: status_audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY status_audits ALTER COLUMN id SET DEFAULT nextval('status_audits_id_seq'::regclass);


--
-- Name: supplier_communications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_communications ALTER COLUMN id SET DEFAULT nextval('supplier_communications_id_seq'::regclass);


--
-- Name: testimonials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY testimonials ALTER COLUMN id SET DEFAULT nextval('testimonials_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: caitredette_service_requests caitredette_service_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY caitredette_service_requests
    ADD CONSTRAINT caitredette_service_requests_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: delivery_areas_food_partners delivery_areas_food_partners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY delivery_areas_food_partners
    ADD CONSTRAINT delivery_areas_food_partners_pkey PRIMARY KEY (id);


--
-- Name: delivery_areas delivery_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY delivery_areas
    ADD CONSTRAINT delivery_areas_pkey PRIMARY KEY (id);


--
-- Name: delivery_hours delivery_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY delivery_hours
    ADD CONSTRAINT delivery_hours_pkey PRIMARY KEY (id);


--
-- Name: enquiries enquiries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiries
    ADD CONSTRAINT enquiries_pkey PRIMARY KEY (id);


--
-- Name: enquiry_codes enquiry_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiry_codes
    ADD CONSTRAINT enquiry_codes_pkey PRIMARY KEY (id);


--
-- Name: enquiry_items enquiry_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiry_items
    ADD CONSTRAINT enquiry_items_pkey PRIMARY KEY (id);


--
-- Name: food_partner_delivery_postcodes food_partner_delivery_postcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY food_partner_delivery_postcodes
    ADD CONSTRAINT food_partner_delivery_postcodes_pkey PRIMARY KEY (id);


--
-- Name: food_partners food_partners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY food_partners
    ADD CONSTRAINT food_partners_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: investment_leads investment_leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY investment_leads
    ADD CONSTRAINT investment_leads_pkey PRIMARY KEY (id);


--
-- Name: menu_categories menu_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_categories
    ADD CONSTRAINT menu_categories_pkey PRIMARY KEY (id);


--
-- Name: menu_packages menu_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_packages
    ADD CONSTRAINT menu_packages_pkey PRIMARY KEY (id);


--
-- Name: menu_tags menu_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_tags
    ADD CONSTRAINT menu_tags_pkey PRIMARY KEY (id);


--
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- Name: old_enquiry_records old_enquiry_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_enquiry_records
    ADD CONSTRAINT old_enquiry_records_pkey PRIMARY KEY (id);


--
-- Name: requests orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: packageable_items packageable_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY packageable_items
    ADD CONSTRAINT packageable_items_pkey PRIMARY KEY (id);


--
-- Name: pictures pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pictures
    ADD CONSTRAINT pictures_pkey PRIMARY KEY (id);


--
-- Name: poll_answers poll_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_answers
    ADD CONSTRAINT poll_answers_pkey PRIMARY KEY (id);


--
-- Name: poll_votes poll_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_votes
    ADD CONSTRAINT poll_votes_pkey PRIMARY KEY (id);


--
-- Name: polls polls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY polls
    ADD CONSTRAINT polls_pkey PRIMARY KEY (id);


--
-- Name: postcode_leads postcode_leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY postcode_leads
    ADD CONSTRAINT postcode_leads_pkey PRIMARY KEY (id);


--
-- Name: postcodes postcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY postcodes
    ADD CONSTRAINT postcodes_pkey PRIMARY KEY (id);


--
-- Name: quotes quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);


--
-- Name: status_audits status_audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY status_audits
    ADD CONSTRAINT status_audits_pkey PRIMARY KEY (id);


--
-- Name: supplier_communications supplier_enquiries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_communications
    ADD CONSTRAINT supplier_enquiries_pkey PRIMARY KEY (id);


--
-- Name: testimonials testimonials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY testimonials
    ADD CONSTRAINT testimonials_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_customers_on_email_and_created_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_email_and_created_account ON customers USING btree (email, created_account);


--
-- Name: index_delivery_hours_on_food_partner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_delivery_hours_on_food_partner_id ON delivery_hours USING btree (food_partner_id);


--
-- Name: index_enquiry_codes_on_code_and_code_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_enquiry_codes_on_code_and_code_type ON enquiry_codes USING btree (code, code_type);


--
-- Name: index_enquiry_items_on_enquiry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_enquiry_items_on_enquiry_id ON enquiry_items USING btree (enquiry_id);


--
-- Name: index_enquiry_items_on_packageable_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_enquiry_items_on_packageable_item_id ON enquiry_items USING btree (packageable_item_id);


--
-- Name: index_food_partner_delivery_postcodes_on_food_partner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_food_partner_delivery_postcodes_on_food_partner_id ON food_partner_delivery_postcodes USING btree (food_partner_id);


--
-- Name: index_food_partner_delivery_postcodes_on_postcode_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_food_partner_delivery_postcodes_on_postcode_id ON food_partner_delivery_postcodes USING btree (postcode_id);


--
-- Name: index_food_partners_on_url_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_food_partners_on_url_slug ON food_partners USING btree (url_slug);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_menu_categories_on_food_partner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_menu_categories_on_food_partner_id ON menu_categories USING btree (food_partner_id);


--
-- Name: index_pictures_on_imageable_id_and_imageable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pictures_on_imageable_id_and_imageable_type ON pictures USING btree (imageable_id, imageable_type);


--
-- Name: index_postcodes_on_delivery_area_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_postcodes_on_delivery_area_id ON postcodes USING btree (delivery_area_id);


--
-- Name: index_quotes_on_food_partner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_quotes_on_food_partner_id ON quotes USING btree (food_partner_id);


--
-- Name: index_status_audits_on_enquiry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_status_audits_on_enquiry_id ON status_audits USING btree (enquiry_id);


--
-- Name: index_status_audits_on_enquiry_id_and_new_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_status_audits_on_enquiry_id_and_new_status ON status_audits USING btree (enquiry_id, new_status);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: addresses addresses_customer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: enquiries enquiries_address_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiries
    ADD CONSTRAINT enquiries_address_id_fk FOREIGN KEY (address_id) REFERENCES addresses(id);


--
-- Name: enquiries enquiries_customer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiries
    ADD CONSTRAINT enquiries_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: enquiry_codes enquiry_codes_enquiry_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiry_codes
    ADD CONSTRAINT enquiry_codes_enquiry_id_fk FOREIGN KEY (enquiry_id) REFERENCES enquiries(id);


--
-- Name: requests fk_rails_24805f7fa6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT fk_rails_24805f7fa6 FOREIGN KEY (food_partner_id) REFERENCES food_partners(id);


--
-- Name: packageable_items fk_rails_3b5b3273aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY packageable_items
    ADD CONSTRAINT fk_rails_3b5b3273aa FOREIGN KEY (food_partner_id) REFERENCES food_partners(id);


--
-- Name: food_partner_delivery_postcodes fk_rails_3bd0929871; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY food_partner_delivery_postcodes
    ADD CONSTRAINT fk_rails_3bd0929871 FOREIGN KEY (food_partner_id) REFERENCES food_partners(id);


--
-- Name: enquiries fk_rails_50a1b403ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiries
    ADD CONSTRAINT fk_rails_50a1b403ec FOREIGN KEY (food_partner_id) REFERENCES food_partners(id);


--
-- Name: food_partner_delivery_postcodes fk_rails_8985e56c80; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY food_partner_delivery_postcodes
    ADD CONSTRAINT fk_rails_8985e56c80 FOREIGN KEY (postcode_id) REFERENCES postcodes(id);


--
-- Name: supplier_communications fk_rails_a00c94f6e4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_communications
    ADD CONSTRAINT fk_rails_a00c94f6e4 FOREIGN KEY (food_partner_id) REFERENCES food_partners(id);


--
-- Name: enquiry_items fk_rails_a2c884121f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiry_items
    ADD CONSTRAINT fk_rails_a2c884121f FOREIGN KEY (packageable_item_id) REFERENCES packageable_items(id);


--
-- Name: menu_categories fk_rails_dc1af18ba5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_categories
    ADD CONSTRAINT fk_rails_dc1af18ba5 FOREIGN KEY (food_partner_id) REFERENCES food_partners(id);


--
-- Name: enquiry_items fk_rails_fd05cf36c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY enquiry_items
    ADD CONSTRAINT fk_rails_fd05cf36c5 FOREIGN KEY (enquiry_id) REFERENCES enquiries(id);


--
-- Name: menu_packages menu_packages_menu_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY menu_packages
    ADD CONSTRAINT menu_packages_menu_id_fk FOREIGN KEY (menu_id) REFERENCES menus(id);


--
-- Name: poll_answers poll_answers_poll_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_answers
    ADD CONSTRAINT poll_answers_poll_id_fk FOREIGN KEY (poll_id) REFERENCES polls(id);


--
-- Name: poll_votes poll_votes_poll_answer_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY poll_votes
    ADD CONSTRAINT poll_votes_poll_answer_id_fk FOREIGN KEY (poll_answer_id) REFERENCES poll_answers(id);


--
-- Name: status_audits status_audits_enquiry_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY status_audits
    ADD CONSTRAINT status_audits_enquiry_id_fk FOREIGN KEY (enquiry_id) REFERENCES enquiries(id);


--
-- Name: supplier_communications supplier_enquiries_enquiry_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY supplier_communications
    ADD CONSTRAINT supplier_enquiries_enquiry_id_fk FOREIGN KEY (enquiry_id) REFERENCES enquiries(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20140225110847');

INSERT INTO schema_migrations (version) VALUES ('20140225110859');

INSERT INTO schema_migrations (version) VALUES ('20140228104227');

INSERT INTO schema_migrations (version) VALUES ('20140228222340');

INSERT INTO schema_migrations (version) VALUES ('20140302064642');

INSERT INTO schema_migrations (version) VALUES ('20140302064652');

INSERT INTO schema_migrations (version) VALUES ('20140302065958');

INSERT INTO schema_migrations (version) VALUES ('20140302070626');

INSERT INTO schema_migrations (version) VALUES ('20140305082308');

INSERT INTO schema_migrations (version) VALUES ('20140316061050');

INSERT INTO schema_migrations (version) VALUES ('20140316062811');

INSERT INTO schema_migrations (version) VALUES ('20140316074122');

INSERT INTO schema_migrations (version) VALUES ('20140317084229');

INSERT INTO schema_migrations (version) VALUES ('20140317090944');

INSERT INTO schema_migrations (version) VALUES ('20140325080438');

INSERT INTO schema_migrations (version) VALUES ('20140406001353');

INSERT INTO schema_migrations (version) VALUES ('20140406002156');

INSERT INTO schema_migrations (version) VALUES ('20140410024824');

INSERT INTO schema_migrations (version) VALUES ('20140410041355');

INSERT INTO schema_migrations (version) VALUES ('20140410044818');

INSERT INTO schema_migrations (version) VALUES ('20140410062655');

INSERT INTO schema_migrations (version) VALUES ('20140501032253');

INSERT INTO schema_migrations (version) VALUES ('20140505120355');

INSERT INTO schema_migrations (version) VALUES ('20140511085556');

INSERT INTO schema_migrations (version) VALUES ('20140516092239');

INSERT INTO schema_migrations (version) VALUES ('20140517094554');

INSERT INTO schema_migrations (version) VALUES ('20140524082906');

INSERT INTO schema_migrations (version) VALUES ('20140527120135');

INSERT INTO schema_migrations (version) VALUES ('20140601084912');

INSERT INTO schema_migrations (version) VALUES ('20140604080613');

INSERT INTO schema_migrations (version) VALUES ('20140607045003');

INSERT INTO schema_migrations (version) VALUES ('20140607061515');

INSERT INTO schema_migrations (version) VALUES ('20140705230331');

INSERT INTO schema_migrations (version) VALUES ('20140721085852');

INSERT INTO schema_migrations (version) VALUES ('20140721092335');

INSERT INTO schema_migrations (version) VALUES ('20140726003030');

INSERT INTO schema_migrations (version) VALUES ('20140809060343');

INSERT INTO schema_migrations (version) VALUES ('20140811160627');

INSERT INTO schema_migrations (version) VALUES ('20140813161148');

INSERT INTO schema_migrations (version) VALUES ('20140814090853');

INSERT INTO schema_migrations (version) VALUES ('20140814155213');

INSERT INTO schema_migrations (version) VALUES ('20140815132042');

INSERT INTO schema_migrations (version) VALUES ('20140815184259');

INSERT INTO schema_migrations (version) VALUES ('20140817111540');

INSERT INTO schema_migrations (version) VALUES ('20140824064221');

INSERT INTO schema_migrations (version) VALUES ('20140928074832');

INSERT INTO schema_migrations (version) VALUES ('20141004234814');

INSERT INTO schema_migrations (version) VALUES ('20141004235617');

INSERT INTO schema_migrations (version) VALUES ('20141005001918');

INSERT INTO schema_migrations (version) VALUES ('20141005051649');

INSERT INTO schema_migrations (version) VALUES ('20141005054410');

INSERT INTO schema_migrations (version) VALUES ('20141005060017');

INSERT INTO schema_migrations (version) VALUES ('20141005060127');

INSERT INTO schema_migrations (version) VALUES ('20141006090020');

INSERT INTO schema_migrations (version) VALUES ('20141006090211');

INSERT INTO schema_migrations (version) VALUES ('20141028223956');

INSERT INTO schema_migrations (version) VALUES ('20141029024817');

INSERT INTO schema_migrations (version) VALUES ('20141029054443');

INSERT INTO schema_migrations (version) VALUES ('20141103050806');

INSERT INTO schema_migrations (version) VALUES ('20141105033130');

INSERT INTO schema_migrations (version) VALUES ('20141107042548');

INSERT INTO schema_migrations (version) VALUES ('20141109202135');

INSERT INTO schema_migrations (version) VALUES ('20141110082629');

INSERT INTO schema_migrations (version) VALUES ('20141111062518');

INSERT INTO schema_migrations (version) VALUES ('20141111062802');

INSERT INTO schema_migrations (version) VALUES ('20141111063614');

INSERT INTO schema_migrations (version) VALUES ('20141111063949');

INSERT INTO schema_migrations (version) VALUES ('20141111203927');

INSERT INTO schema_migrations (version) VALUES ('20141113210607');

INSERT INTO schema_migrations (version) VALUES ('20141114033940');

INSERT INTO schema_migrations (version) VALUES ('20141116231628');

INSERT INTO schema_migrations (version) VALUES ('20141117225321');

INSERT INTO schema_migrations (version) VALUES ('20141120205105');

INSERT INTO schema_migrations (version) VALUES ('20141123234051');

INSERT INTO schema_migrations (version) VALUES ('20141124204922');

INSERT INTO schema_migrations (version) VALUES ('20141124210852');

INSERT INTO schema_migrations (version) VALUES ('20141125022153');

INSERT INTO schema_migrations (version) VALUES ('20141125030924');

INSERT INTO schema_migrations (version) VALUES ('20141125224113');

INSERT INTO schema_migrations (version) VALUES ('20141126003324');

INSERT INTO schema_migrations (version) VALUES ('20141127053040');

INSERT INTO schema_migrations (version) VALUES ('20141127080645');

INSERT INTO schema_migrations (version) VALUES ('20141129001223');

INSERT INTO schema_migrations (version) VALUES ('20141202202440');

INSERT INTO schema_migrations (version) VALUES ('20141203083233');

INSERT INTO schema_migrations (version) VALUES ('20141203094443');

INSERT INTO schema_migrations (version) VALUES ('20141205033013');

INSERT INTO schema_migrations (version) VALUES ('20141205051614');

INSERT INTO schema_migrations (version) VALUES ('20141207204125');

INSERT INTO schema_migrations (version) VALUES ('20141209000909');

INSERT INTO schema_migrations (version) VALUES ('20141213000724');

INSERT INTO schema_migrations (version) VALUES ('20141214064452');

INSERT INTO schema_migrations (version) VALUES ('20141214071650');

INSERT INTO schema_migrations (version) VALUES ('20141220083405');

INSERT INTO schema_migrations (version) VALUES ('20141221215609');

INSERT INTO schema_migrations (version) VALUES ('20141222000812');

INSERT INTO schema_migrations (version) VALUES ('20141222000905');

INSERT INTO schema_migrations (version) VALUES ('20141222025048');

INSERT INTO schema_migrations (version) VALUES ('20141223023639');

INSERT INTO schema_migrations (version) VALUES ('20141228235305');

INSERT INTO schema_migrations (version) VALUES ('20141229073359');

INSERT INTO schema_migrations (version) VALUES ('20141229204656');

INSERT INTO schema_migrations (version) VALUES ('20141229214052');

INSERT INTO schema_migrations (version) VALUES ('20141230074732');

INSERT INTO schema_migrations (version) VALUES ('20150101085954');

INSERT INTO schema_migrations (version) VALUES ('20150104203326');

INSERT INTO schema_migrations (version) VALUES ('20150304042856');

INSERT INTO schema_migrations (version) VALUES ('20150306044807');

INSERT INTO schema_migrations (version) VALUES ('20150310035454');

INSERT INTO schema_migrations (version) VALUES ('20150311045825');

INSERT INTO schema_migrations (version) VALUES ('20150316051510');

INSERT INTO schema_migrations (version) VALUES ('20150316222116');

INSERT INTO schema_migrations (version) VALUES ('20150318005323');

INSERT INTO schema_migrations (version) VALUES ('20150318013032');

INSERT INTO schema_migrations (version) VALUES ('20150326034519');

INSERT INTO schema_migrations (version) VALUES ('20150331052313');

INSERT INTO schema_migrations (version) VALUES ('20150414112145');

INSERT INTO schema_migrations (version) VALUES ('20150420043731');

INSERT INTO schema_migrations (version) VALUES ('20150421070443');

INSERT INTO schema_migrations (version) VALUES ('20150428070452');

INSERT INTO schema_migrations (version) VALUES ('20150517093301');

INSERT INTO schema_migrations (version) VALUES ('20151130002659');

INSERT INTO schema_migrations (version) VALUES ('20151130042805');

INSERT INTO schema_migrations (version) VALUES ('20151202235255');

INSERT INTO schema_migrations (version) VALUES ('20160104022624');

INSERT INTO schema_migrations (version) VALUES ('20160104224602');

INSERT INTO schema_migrations (version) VALUES ('20160119035847');

INSERT INTO schema_migrations (version) VALUES ('20160124223036');

INSERT INTO schema_migrations (version) VALUES ('20160125004311');

INSERT INTO schema_migrations (version) VALUES ('20160125005533');

INSERT INTO schema_migrations (version) VALUES ('20160125010654');

INSERT INTO schema_migrations (version) VALUES ('20160125013032');

INSERT INTO schema_migrations (version) VALUES ('20160125025353');

INSERT INTO schema_migrations (version) VALUES ('20160125034722');

INSERT INTO schema_migrations (version) VALUES ('20160125040927');

INSERT INTO schema_migrations (version) VALUES ('20160125041719');

INSERT INTO schema_migrations (version) VALUES ('20160131230313');

INSERT INTO schema_migrations (version) VALUES ('20160208033321');

INSERT INTO schema_migrations (version) VALUES ('20160208051217');

INSERT INTO schema_migrations (version) VALUES ('20160208110210');

INSERT INTO schema_migrations (version) VALUES ('20160214203434');

INSERT INTO schema_migrations (version) VALUES ('20160220005526');

INSERT INTO schema_migrations (version) VALUES ('20160220031719');

INSERT INTO schema_migrations (version) VALUES ('20160220041415');

INSERT INTO schema_migrations (version) VALUES ('20160220043608');

INSERT INTO schema_migrations (version) VALUES ('20160220063324');

INSERT INTO schema_migrations (version) VALUES ('20160221024119');

INSERT INTO schema_migrations (version) VALUES ('20160302014838');

INSERT INTO schema_migrations (version) VALUES ('20160302022525');

INSERT INTO schema_migrations (version) VALUES ('20160302024610');

INSERT INTO schema_migrations (version) VALUES ('20160305043413');

INSERT INTO schema_migrations (version) VALUES ('20160305092059');

INSERT INTO schema_migrations (version) VALUES ('20160305110431');

INSERT INTO schema_migrations (version) VALUES ('20160306011248');

INSERT INTO schema_migrations (version) VALUES ('20160306020406');

INSERT INTO schema_migrations (version) VALUES ('20160405220952');

INSERT INTO schema_migrations (version) VALUES ('20160421074659');

INSERT INTO schema_migrations (version) VALUES ('20160421075858');

INSERT INTO schema_migrations (version) VALUES ('20160422023827');

INSERT INTO schema_migrations (version) VALUES ('20160423052839');

INSERT INTO schema_migrations (version) VALUES ('20160426124713');

INSERT INTO schema_migrations (version) VALUES ('20160426130517');

INSERT INTO schema_migrations (version) VALUES ('20160502050410');

INSERT INTO schema_migrations (version) VALUES ('20160614114831');

INSERT INTO schema_migrations (version) VALUES ('20160615062446');

INSERT INTO schema_migrations (version) VALUES ('20160723061206');

INSERT INTO schema_migrations (version) VALUES ('20160724113805');

INSERT INTO schema_migrations (version) VALUES ('20160915063322');

INSERT INTO schema_migrations (version) VALUES ('20160915113926');

INSERT INTO schema_migrations (version) VALUES ('20161119002434');

INSERT INTO schema_migrations (version) VALUES ('20170327085945');


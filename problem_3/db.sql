--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5 (Debian 13.5-1.pgdg110+1)
-- Dumped by pg_dump version 13.5 (Debian 13.5-1.pgdg110+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: catalog; Type: TABLE; Schema: public; Owner: odoo
--

CREATE TABLE public.catalog (
    catalogid integer NOT NULL,
    catalogname character varying(50) NOT NULL
);


ALTER TABLE public.catalog OWNER TO odoo;

--
-- Name: catalog_catalogid_seq; Type: SEQUENCE; Schema: public; Owner: odoo
--

ALTER TABLE public.catalog ALTER COLUMN catalogid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.catalog_catalogid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: catalogcustomer; Type: TABLE; Schema: public; Owner: odoo
--

CREATE TABLE public.catalogcustomer (
    customerid integer NOT NULL,
    catalogid integer NOT NULL
);


ALTER TABLE public.catalogcustomer OWNER TO odoo;

--
-- Name: catalogproduct; Type: TABLE; Schema: public; Owner: odoo
--

CREATE TABLE public.catalogproduct (
    catalogid integer NOT NULL,
    productid integer NOT NULL
);


ALTER TABLE public.catalogproduct OWNER TO odoo;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: odoo
--

CREATE TABLE public.customer (
    customerid integer NOT NULL,
    customername character varying(50) NOT NULL
);


ALTER TABLE public.customer OWNER TO odoo;

--
-- Name: TABLE customer; Type: COMMENT; Schema: public; Owner: odoo
--

COMMENT ON TABLE public.customer IS 'Basic information
about Customer';


--
-- Name: customer_customerid_seq; Type: SEQUENCE; Schema: public; Owner: odoo
--

ALTER TABLE public.customer ALTER COLUMN customerid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.customer_customerid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: product; Type: TABLE; Schema: public; Owner: odoo
--

CREATE TABLE public.product (
    productid integer NOT NULL,
    visibilityid integer NOT NULL,
    productname character varying(50) NOT NULL,
    productprice numeric(12,2)
);


ALTER TABLE public.product OWNER TO odoo;

--
-- Name: TABLE product; Type: COMMENT; Schema: public; Owner: odoo
--

COMMENT ON TABLE public.product IS 'Basic information
about Product';


--
-- Name: product_productid_seq; Type: SEQUENCE; Schema: public; Owner: odoo
--

ALTER TABLE public.product ALTER COLUMN productid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.product_productid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: visibility; Type: TABLE; Schema: public; Owner: odoo
--

CREATE TABLE public.visibility (
    visibilityid integer NOT NULL,
    visibilityname character varying(50) NOT NULL
);


ALTER TABLE public.visibility OWNER TO odoo;

--
-- Name: visibility_visibilityid_seq; Type: SEQUENCE; Schema: public; Owner: odoo
--

ALTER TABLE public.visibility ALTER COLUMN visibilityid ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.visibility_visibilityid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: catalog; Type: TABLE DATA; Schema: public; Owner: odoo
--

COPY public.catalog (catalogid, catalogname) FROM stdin;
1	Fruits
2	Vegetables
3	Meats
4	Frozen
\.


--
-- Data for Name: catalogcustomer; Type: TABLE DATA; Schema: public; Owner: odoo
--

COPY public.catalogcustomer (customerid, catalogid) FROM stdin;
2	1
2	2
3	2
4	1
4	2
4	3
\.


--
-- Data for Name: catalogproduct; Type: TABLE DATA; Schema: public; Owner: odoo
--

COPY public.catalogproduct (catalogid, productid) FROM stdin;
1	1
1	2
1	3
1	4
1	5
1	6
1	7
1	8
2	9
2	10
3	11
3	12
3	13
3	14
3	15
3	16
3	17
1	18
2	18
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: odoo
--

COPY public.customer (customerid, customername) FROM stdin;
1	Johns Inc\t
2	Kirlin-Rutherford
3	Ullrich Inc
4	Lakin PLC
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: odoo
--

COPY public.product (productid, visibilityid, productname, productprice) FROM stdin;
1	1	Apple	3.00
2	1	Lemon	2.00
3	2	Grapes	4.00
4	1	Watermelon	1.00
5	1	Pineapple	3.00
6	2	Green Apple	3.00
7	2	Bluberries	5.00
8	2	Strawberries	2.00
9	2	Brocoli	4.00
10	2	Cucumber	2.00
11	2	Chicken breast	4.00
12	2	Brisket	8.00
13	2	Loin	6.00
14	2	Pork Belly	8.00
15	2	Pork Leg	10.00
16	2	Chicken thigh	4.00
17	2	Chicken wings	3.00
18	2	Tomato	1.00
\.


--
-- Data for Name: visibility; Type: TABLE DATA; Schema: public; Owner: odoo
--

COPY public.visibility (visibilityid, visibilityname) FROM stdin;
1	default
2	catalog
\.


--
-- Name: catalog_catalogid_seq; Type: SEQUENCE SET; Schema: public; Owner: odoo
--

SELECT pg_catalog.setval('public.catalog_catalogid_seq', 4, true);


--
-- Name: customer_customerid_seq; Type: SEQUENCE SET; Schema: public; Owner: odoo
--

SELECT pg_catalog.setval('public.customer_customerid_seq', 4, true);


--
-- Name: product_productid_seq; Type: SEQUENCE SET; Schema: public; Owner: odoo
--

SELECT pg_catalog.setval('public.product_productid_seq', 18, true);


--
-- Name: visibility_visibilityid_seq; Type: SEQUENCE SET; Schema: public; Owner: odoo
--

SELECT pg_catalog.setval('public.visibility_visibilityid_seq', 2, true);


--
-- Name: customer ak1_customer_customername; Type: CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT ak1_customer_customername UNIQUE (customername);


--
-- Name: product ak1_product_supplierid_productname; Type: CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT ak1_product_supplierid_productname UNIQUE (productname);


--
-- Name: catalog pk_138; Type: CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.catalog
    ADD CONSTRAINT pk_138 PRIMARY KEY (catalogid);


--
-- Name: visibility pk_150; Type: CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.visibility
    ADD CONSTRAINT pk_150 PRIMARY KEY (visibilityid);


--
-- Name: customer pk_customer; Type: CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT pk_customer PRIMARY KEY (customerid);


--
-- Name: product pk_product; Type: CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT pk_product PRIMARY KEY (productid);


--
-- Name: catalog unique_name; Type: CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.catalog
    ADD CONSTRAINT unique_name UNIQUE (catalogname);


--
-- Name: fk_176; Type: INDEX; Schema: public; Owner: odoo
--

CREATE INDEX fk_176 ON public.catalogcustomer USING btree (customerid);


--
-- Name: fk_180; Type: INDEX; Schema: public; Owner: odoo
--

CREATE INDEX fk_180 ON public.catalogcustomer USING btree (catalogid);


--
-- Name: fk_193; Type: INDEX; Schema: public; Owner: odoo
--

CREATE INDEX fk_193 ON public.product USING btree (visibilityid);


--
-- Name: fk_197; Type: INDEX; Schema: public; Owner: odoo
--

CREATE INDEX fk_197 ON public.catalogproduct USING btree (catalogid);


--
-- Name: fk_200; Type: INDEX; Schema: public; Owner: odoo
--

CREATE INDEX fk_200 ON public.catalogproduct USING btree (productid);


--
-- Name: catalogcustomer fk_174; Type: FK CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.catalogcustomer
    ADD CONSTRAINT fk_174 FOREIGN KEY (customerid) REFERENCES public.customer(customerid);


--
-- Name: catalogcustomer fk_178; Type: FK CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.catalogcustomer
    ADD CONSTRAINT fk_178 FOREIGN KEY (catalogid) REFERENCES public.catalog(catalogid);


--
-- Name: product fk_191; Type: FK CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT fk_191 FOREIGN KEY (visibilityid) REFERENCES public.visibility(visibilityid);


--
-- Name: catalogproduct fk_195; Type: FK CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.catalogproduct
    ADD CONSTRAINT fk_195 FOREIGN KEY (catalogid) REFERENCES public.catalog(catalogid);


--
-- Name: catalogproduct fk_198; Type: FK CONSTRAINT; Schema: public; Owner: odoo
--

ALTER TABLE ONLY public.catalogproduct
    ADD CONSTRAINT fk_198 FOREIGN KEY (productid) REFERENCES public.product(productid);


--
-- PostgreSQL database dump complete
--


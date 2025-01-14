PGDMP  8                    |         
   fast_pizza    16.3    16.3 D               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    41641 
   fast_pizza    DATABASE     ~   CREATE DATABASE fast_pizza WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE fast_pizza;
                postgres    false                        2615    41642    pizza_schema    SCHEMA        CREATE SCHEMA pizza_schema;
    DROP SCHEMA pizza_schema;
                postgres    false            i           1247    41653    phone_number_domain    DOMAIN     �   CREATE DOMAIN pizza_schema.phone_number_domain AS character varying(15)
	CONSTRAINT phone_number_domain_check CHECK (((VALUE)::text ~ '^\+\d{1,3}\d{4,10}$'::text));
 .   DROP DOMAIN pizza_schema.phone_number_domain;
       pizza_schema          postgres    false    6            m           1247    41656    postal_code_domain    DOMAIN     �   CREATE DOMAIN pizza_schema.postal_code_domain AS character varying(10)
	CONSTRAINT postal_code_domain_check CHECK (((VALUE)::text ~ '^\d{5}$'::text));
 -   DROP DOMAIN pizza_schema.postal_code_domain;
       pizza_schema          postgres    false    6            q           1247    41659    price_domain    DOMAIN     x   CREATE DOMAIN pizza_schema.price_domain AS numeric(10,2)
	CONSTRAINT price_domain_check CHECK ((VALUE > (0)::numeric));
 '   DROP DOMAIN pizza_schema.price_domain;
       pizza_schema          postgres    false    6            �            1255    41800    check_customer_orders() 	   PROCEDURE     �  CREATE PROCEDURE pizza_schema.check_customer_orders()
    LANGUAGE sql
    AS $_$CREATE OR REPLACE PROCEDURE check_customer_orders(customer_id_input INT)
AS $$
    order_count INT;
BEGIN
    -- Подсчет количества заказов клиента
    SELECT COUNT(*) INTO order_count
    FROM pizza_schema.orders
    WHERE customer_id = customer_id_input;

    -- Условная команда IF-THEN-ELSE
    IF order_count > 0 THEN
        RAISE NOTICE 'Клиент с ID % имеет % заказов.', customer_id_input, order_count;
    ELSE
        RAISE NOTICE 'Клиент с ID % не имеет заказов.', customer_id_input;
    END IF;
END;
$$$_$;
 5   DROP PROCEDURE pizza_schema.check_customer_orders();
       pizza_schema          postgres    false    6            �            1255    41803    check_price_decrease()    FUNCTION       CREATE FUNCTION pizza_schema.check_price_decrease() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.price < OLD.price THEN
        RAISE NOTICE 'Цена пиццы % уменьшена с % до %', OLD.name, OLD.price, NEW.price;
    END IF;
    RETURN NEW;
END;
$$;
 3   DROP FUNCTION pizza_schema.check_price_decrease();
       pizza_schema          postgres    false    6            �            1255    41798    get_customer_info() 	   PROCEDURE     �  CREATE PROCEDURE pizza_schema.get_customer_info()
    LANGUAGE sql
    AS $_$CREATE OR REPLACE PROCEDURE get_customer_info(customer_id_input INT)
AS $$
    customer_record pizza_schema.customers%ROWTYPE;
BEGIN
    -- Использование SELECT INTO с %ROWTYPE для записи строки таблицы в переменную
    SELECT * INTO customer_record
    FROM pizza_schema.customers
    WHERE customer_id = customer_id_input;

    RAISE NOTICE 'Информация о клиенте: ID = %, Имя = %, Телефон = %',
                 customer_record.customer_id,
                 customer_record.name,
                 customer_record.phone;
END;
$$$_$;
 1   DROP PROCEDURE pizza_schema.get_customer_info();
       pizza_schema          postgres    false    6            �            1255    41792    get_total_orders_sum() 	   PROCEDURE     �  CREATE PROCEDURE pizza_schema.get_total_orders_sum()
    LANGUAGE sql
    AS $_$CREATE OR REPLACE PROCEDURE get_total_orders_sum(customer_id_input INT)
LANGUAGE plpgsql
AS $$
DECLARE
    total_sum NUMERIC;
BEGIN
    SELECT SUM(total_price) INTO total_sum
    FROM pizza_schema.orders
    WHERE customer_id = customer_id_input;

    RAISE NOTICE 'Общая сумма заказов клиента с ID %: %', customer_id_input, total_sum;
END;
$$;$_$;
 4   DROP PROCEDURE pizza_schema.get_total_orders_sum();
       pizza_schema          postgres    false    6            �            1255    41791    increase_pizza_prices() 	   PROCEDURE     �  CREATE PROCEDURE pizza_schema.increase_pizza_prices()
    LANGUAGE sql
    AS $_$CREATE OR REPLACE PROCEDURE increase_pizza_prices()
LANGUAGE plpgsql  -- Указание языка процедуры
AS $$
DECLARE
    pizza_record pizza_schema.pizzas%ROWTYPE;
BEGIN
    FOR pizza_record IN (SELECT * FROM pizza_schema.pizzas) LOOP
        -- Увеличение цены на 10%
        UPDATE pizza_schema.pizzas
        SET price = price * 1.1
        WHERE pizza_id = pizza_record.pizza_id;

        RAISE NOTICE 'Цена пиццы "%", обновленная цена: %', pizza_record.name, pizza_record.price * 1.1;
    END LOOP;
END;
$$;$_$;
 5   DROP PROCEDURE pizza_schema.increase_pizza_prices();
       pizza_schema          postgres    false    6            �            1255    41801    increase_prices() 	   PROCEDURE     z  CREATE PROCEDURE pizza_schema.increase_prices()
    LANGUAGE sql
    AS $_$CREATE OR REPLACE PROCEDURE increase_prices()
AS $$
    pizza_record pizza_schema.pizzas%ROWTYPE;
BEGIN
    -- Цикл по всем записям таблицы пицц
    FOR pizza_record IN (SELECT * FROM pizza_schema.pizzas) LOOP
        -- Увеличение цены на 10%
        UPDATE pizza_schema.pizzas
        SET price = price * 1.1
        WHERE pizza_id = pizza_record.pizza_id;

        RAISE NOTICE 'Цена пиццы "%", обновленная цена: %', pizza_record.name, pizza_record.price * 1.1;
    END LOOP;
END;
$$$_$;
 /   DROP PROCEDURE pizza_schema.increase_prices();
       pizza_schema          postgres    false    6            �            1255    41797    update_customer_phone() 	   PROCEDURE     �  CREATE PROCEDURE pizza_schema.update_customer_phone()
    LANGUAGE sql
    AS $_$CREATE OR REPLACE PROCEDURE update_customer_phone(
    customer_id_input pizza_schema.customers.customer_id%TYPE,
    new_phone_input pizza_schema.customers.phone%TYPE
)
AS $$
BEGIN
    UPDATE pizza_schema.customers
    SET phone = new_phone_input
    WHERE customer_id = customer_id_input;

    RAISE NOTICE 'Телефон клиента с ID % обновлен на %', customer_id_input, new_phone_input;
END;
$$$_$;
 5   DROP PROCEDURE pizza_schema.update_customer_phone();
       pizza_schema          postgres    false    6            �            1259    41697 	   customers    TABLE     �   CREATE TABLE pizza_schema.customers (
    customer_id integer NOT NULL,
    name character varying(100) NOT NULL,
    phone pizza_schema.phone_number_domain NOT NULL,
    email character varying(100),
    address character varying(255)
);
 #   DROP TABLE pizza_schema.customers;
       pizza_schema         heap    postgres    false    6    873            �            1259    41696    customers_customer_id_seq    SEQUENCE     �   CREATE SEQUENCE pizza_schema.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE pizza_schema.customers_customer_id_seq;
       pizza_schema          postgres    false    217    6                       0    0    customers_customer_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE pizza_schema.customers_customer_id_seq OWNED BY pizza_schema.customers.customer_id;
          pizza_schema          postgres    false    216            �            1259    41708 	   employees    TABLE       CREATE TABLE pizza_schema.employees (
    employee_id integer NOT NULL,
    name character varying(100) NOT NULL,
    "position" character varying(50) NOT NULL,
    phone pizza_schema.phone_number_domain,
    hire_date date DEFAULT CURRENT_DATE NOT NULL
);
 #   DROP TABLE pizza_schema.employees;
       pizza_schema         heap    postgres    false    6    873            �            1259    41707    employees_employee_id_seq    SEQUENCE     �   CREATE SEQUENCE pizza_schema.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE pizza_schema.employees_employee_id_seq;
       pizza_schema          postgres    false    219    6                       0    0    employees_employee_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE pizza_schema.employees_employee_id_seq OWNED BY pizza_schema.employees.employee_id;
          pizza_schema          postgres    false    218            �            1259    41747    order_items    TABLE     �   CREATE TABLE pizza_schema.order_items (
    order_item_id integer NOT NULL,
    order_id integer NOT NULL,
    pizza_id integer NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
);
 %   DROP TABLE pizza_schema.order_items;
       pizza_schema         heap    postgres    false    6            �            1259    41746    order_items_order_item_id_seq    SEQUENCE     �   CREATE SEQUENCE pizza_schema.order_items_order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE pizza_schema.order_items_order_item_id_seq;
       pizza_schema          postgres    false    225    6                       0    0    order_items_order_item_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE pizza_schema.order_items_order_item_id_seq OWNED BY pizza_schema.order_items.order_item_id;
          pizza_schema          postgres    false    224            �            1259    41727    orders    TABLE       CREATE TABLE pizza_schema.orders (
    order_id integer NOT NULL,
    customer_id integer NOT NULL,
    employee_id integer NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_price pizza_schema.price_domain NOT NULL
);
     DROP TABLE pizza_schema.orders;
       pizza_schema         heap    postgres    false    6    881            �            1259    41726    orders_order_id_seq    SEQUENCE     �   CREATE SEQUENCE pizza_schema.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE pizza_schema.orders_order_id_seq;
       pizza_schema          postgres    false    223    6                       0    0    orders_order_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE pizza_schema.orders_order_id_seq OWNED BY pizza_schema.orders.order_id;
          pizza_schema          postgres    false    222            �            1259    41718    pizzas    TABLE     �   CREATE TABLE pizza_schema.pizzas (
    pizza_id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    price pizza_schema.price_domain NOT NULL
);
     DROP TABLE pizza_schema.pizzas;
       pizza_schema         heap    postgres    false    6    881            �            1259    41717    pizzas_pizza_id_seq    SEQUENCE     �   CREATE SEQUENCE pizza_schema.pizzas_pizza_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE pizza_schema.pizzas_pizza_id_seq;
       pizza_schema          postgres    false    221    6                        0    0    pizzas_pizza_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE pizza_schema.pizzas_pizza_id_seq OWNED BY pizza_schema.pizzas.pizza_id;
          pizza_schema          postgres    false    220            �            1259    41767    seq_customers_id    SEQUENCE        CREATE SEQUENCE pizza_schema.seq_customers_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE pizza_schema.seq_customers_id;
       pizza_schema          postgres    false    6            �            1259    41769    seq_order_items_id    SEQUENCE     �   CREATE SEQUENCE pizza_schema.seq_order_items_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE pizza_schema.seq_order_items_id;
       pizza_schema          postgres    false    6            �            1259    41768    seq_orders_id    SEQUENCE     |   CREATE SEQUENCE pizza_schema.seq_orders_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE pizza_schema.seq_orders_id;
       pizza_schema          postgres    false    6            �            1259    41775    view_employee_orders    VIEW     �   CREATE VIEW pizza_schema.view_employee_orders AS
 SELECT e.name AS employee_name,
    count(o.order_id) AS orders_count
   FROM (pizza_schema.employees e
     LEFT JOIN pizza_schema.orders o ON ((e.employee_id = o.employee_id)))
  GROUP BY e.name;
 -   DROP VIEW pizza_schema.view_employee_orders;
       pizza_schema          postgres    false    219    223    223    219    6            �            1259    41771    view_orders_summary    VIEW     �   CREATE VIEW pizza_schema.view_orders_summary AS
 SELECT o.order_id,
    c.name AS customer_name,
    o.total_price
   FROM (pizza_schema.orders o
     JOIN pizza_schema.customers c ON ((o.customer_id = c.customer_id)));
 ,   DROP VIEW pizza_schema.view_orders_summary;
       pizza_schema          postgres    false    217    217    223    223    223    881    6            �            1259    41779    view_pizza_prices    VIEW     �   CREATE VIEW pizza_schema.view_pizza_prices AS
 SELECT min((price)::numeric) AS min_price,
    max((price)::numeric) AS max_price
   FROM pizza_schema.pizzas;
 *   DROP VIEW pizza_schema.view_pizza_prices;
       pizza_schema          postgres    false    221    6            [           2604    41700    customers customer_id    DEFAULT     �   ALTER TABLE ONLY pizza_schema.customers ALTER COLUMN customer_id SET DEFAULT nextval('pizza_schema.customers_customer_id_seq'::regclass);
 J   ALTER TABLE pizza_schema.customers ALTER COLUMN customer_id DROP DEFAULT;
       pizza_schema          postgres    false    217    216    217            \           2604    41711    employees employee_id    DEFAULT     �   ALTER TABLE ONLY pizza_schema.employees ALTER COLUMN employee_id SET DEFAULT nextval('pizza_schema.employees_employee_id_seq'::regclass);
 J   ALTER TABLE pizza_schema.employees ALTER COLUMN employee_id DROP DEFAULT;
       pizza_schema          postgres    false    219    218    219            a           2604    41750    order_items order_item_id    DEFAULT     �   ALTER TABLE ONLY pizza_schema.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('pizza_schema.order_items_order_item_id_seq'::regclass);
 N   ALTER TABLE pizza_schema.order_items ALTER COLUMN order_item_id DROP DEFAULT;
       pizza_schema          postgres    false    225    224    225            _           2604    41730    orders order_id    DEFAULT     ~   ALTER TABLE ONLY pizza_schema.orders ALTER COLUMN order_id SET DEFAULT nextval('pizza_schema.orders_order_id_seq'::regclass);
 D   ALTER TABLE pizza_schema.orders ALTER COLUMN order_id DROP DEFAULT;
       pizza_schema          postgres    false    223    222    223            ^           2604    41721    pizzas pizza_id    DEFAULT     ~   ALTER TABLE ONLY pizza_schema.pizzas ALTER COLUMN pizza_id SET DEFAULT nextval('pizza_schema.pizzas_pizza_id_seq'::regclass);
 D   ALTER TABLE pizza_schema.pizzas ALTER COLUMN pizza_id DROP DEFAULT;
       pizza_schema          postgres    false    221    220    221            
          0    41697 	   customers 
   TABLE DATA           S   COPY pizza_schema.customers (customer_id, name, phone, email, address) FROM stdin;
    pizza_schema          postgres    false    217   a                 0    41708 	   employees 
   TABLE DATA           Z   COPY pizza_schema.employees (employee_id, name, "position", phone, hire_date) FROM stdin;
    pizza_schema          postgres    false    219   0b                 0    41747    order_items 
   TABLE DATA           X   COPY pizza_schema.order_items (order_item_id, order_id, pizza_id, quantity) FROM stdin;
    pizza_schema          postgres    false    225   &c                 0    41727    orders 
   TABLE DATA           c   COPY pizza_schema.orders (order_id, customer_id, employee_id, order_date, total_price) FROM stdin;
    pizza_schema          postgres    false    223   dc                 0    41718    pizzas 
   TABLE DATA           J   COPY pizza_schema.pizzas (pizza_id, name, description, price) FROM stdin;
    pizza_schema          postgres    false    221   �c       !           0    0    customers_customer_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('pizza_schema.customers_customer_id_seq', 5, true);
          pizza_schema          postgres    false    216            "           0    0    employees_employee_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('pizza_schema.employees_employee_id_seq', 5, true);
          pizza_schema          postgres    false    218            #           0    0    order_items_order_item_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('pizza_schema.order_items_order_item_id_seq', 6, true);
          pizza_schema          postgres    false    224            $           0    0    orders_order_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('pizza_schema.orders_order_id_seq', 13, true);
          pizza_schema          postgres    false    222            %           0    0    pizzas_pizza_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('pizza_schema.pizzas_pizza_id_seq', 5, true);
          pizza_schema          postgres    false    220            &           0    0    seq_customers_id    SEQUENCE SET     E   SELECT pg_catalog.setval('pizza_schema.seq_customers_id', 1, false);
          pizza_schema          postgres    false    226            '           0    0    seq_order_items_id    SEQUENCE SET     G   SELECT pg_catalog.setval('pizza_schema.seq_order_items_id', 1, false);
          pizza_schema          postgres    false    228            (           0    0    seq_orders_id    SEQUENCE SET     B   SELECT pg_catalog.setval('pizza_schema.seq_orders_id', 1, false);
          pizza_schema          postgres    false    227            d           2606    41706    customers customers_email_key 
   CONSTRAINT     _   ALTER TABLE ONLY pizza_schema.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);
 M   ALTER TABLE ONLY pizza_schema.customers DROP CONSTRAINT customers_email_key;
       pizza_schema            postgres    false    217            f           2606    41704    customers customers_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY pizza_schema.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);
 H   ALTER TABLE ONLY pizza_schema.customers DROP CONSTRAINT customers_pkey;
       pizza_schema            postgres    false    217            i           2606    41716    employees employees_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY pizza_schema.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);
 H   ALTER TABLE ONLY pizza_schema.employees DROP CONSTRAINT employees_pkey;
       pizza_schema            postgres    false    219            q           2606    41753    order_items order_items_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY pizza_schema.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);
 L   ALTER TABLE ONLY pizza_schema.order_items DROP CONSTRAINT order_items_pkey;
       pizza_schema            postgres    false    225            n           2606    41735    orders orders_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY pizza_schema.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);
 B   ALTER TABLE ONLY pizza_schema.orders DROP CONSTRAINT orders_pkey;
       pizza_schema            postgres    false    223            k           2606    41725    pizzas pizzas_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY pizza_schema.pizzas
    ADD CONSTRAINT pizzas_pkey PRIMARY KEY (pizza_id);
 B   ALTER TABLE ONLY pizza_schema.pizzas DROP CONSTRAINT pizzas_pkey;
       pizza_schema            postgres    false    221            g           1259    41764    idx_customers_phone    INDEX     P   CREATE INDEX idx_customers_phone ON pizza_schema.customers USING btree (phone);
 -   DROP INDEX pizza_schema.idx_customers_phone;
       pizza_schema            postgres    false    217            o           1259    41766    idx_order_items_order_id    INDEX     Z   CREATE INDEX idx_order_items_order_id ON pizza_schema.order_items USING btree (order_id);
 2   DROP INDEX pizza_schema.idx_order_items_order_id;
       pizza_schema            postgres    false    225            l           1259    41765    idx_orders_order_date    INDEX     T   CREATE INDEX idx_orders_order_date ON pizza_schema.orders USING btree (order_date);
 /   DROP INDEX pizza_schema.idx_orders_order_date;
       pizza_schema            postgres    false    223            v           2620    41807    orders validate_order_price    TRIGGER     �   CREATE TRIGGER validate_order_price BEFORE INSERT ON pizza_schema.orders FOR EACH ROW EXECUTE FUNCTION public.check_min_order_price();
 :   DROP TRIGGER validate_order_price ON pizza_schema.orders;
       pizza_schema          postgres    false    223            t           2606    41754 %   order_items order_items_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY pizza_schema.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES pizza_schema.orders(order_id) ON DELETE CASCADE;
 U   ALTER TABLE ONLY pizza_schema.order_items DROP CONSTRAINT order_items_order_id_fkey;
       pizza_schema          postgres    false    4718    223    225            u           2606    41759 %   order_items order_items_pizza_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY pizza_schema.order_items
    ADD CONSTRAINT order_items_pizza_id_fkey FOREIGN KEY (pizza_id) REFERENCES pizza_schema.pizzas(pizza_id) ON DELETE RESTRICT;
 U   ALTER TABLE ONLY pizza_schema.order_items DROP CONSTRAINT order_items_pizza_id_fkey;
       pizza_schema          postgres    false    4715    225    221            r           2606    41736    orders orders_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY pizza_schema.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES pizza_schema.customers(customer_id) ON DELETE CASCADE;
 N   ALTER TABLE ONLY pizza_schema.orders DROP CONSTRAINT orders_customer_id_fkey;
       pizza_schema          postgres    false    223    4710    217            s           2606    41741    orders orders_employee_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY pizza_schema.orders
    ADD CONSTRAINT orders_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES pizza_schema.employees(employee_id) ON DELETE SET NULL;
 N   ALTER TABLE ONLY pizza_schema.orders DROP CONSTRAINT orders_employee_id_fkey;
       pizza_schema          postgres    false    223    219    4713            
     x�m��J�@���S�]	Mv7n>H/A�"�i�"z-�A���X��m���g����6s�m���7��^�B������(���@iFtq�fg�&M��;��ͱ�$n��ÖCũ�Ɠ��n�r��b��&�j�%��d��B���Xs�K�e�c�V�.�t`o��wl9�g*�	O<����c��n��$IG�Y�vyK��Mp����!|`�x9v_��'���k���C��3*�����Um����q��@         �   x�E��j�@��w�"���;�1�]�01�WK� "-�>@�F��+�y#g�Sa`w�;�7x�G�y.�)�'�r���^^���Ƒ��΅��7�(<:/˒�V���:�5*�k�6���\�cL��t ����H��T�;^�G�y�;��i#�ԁsBm�h�օ��J�����;/E}%b���'
a@DE��Ji�Qt_]��y�-.��>�,�f�< �B�&����         .   x���	 0��UL@��I�ud���:�R���������{$=�_G         {   x�}���0�3�"Ă֘Z��:֟S��5G��0���8��O5nc�̕��V*�`lg4spݗs�9�^؞��%��)Q9BۼiC�K�tMX���1���'}�k�f�%�����:E         �   x�e�A��@EוS�	$���f%�r妑Fe@%���à�ލWhE!3:�+T��߉�(tStU�_���Z:��d8��[>��L2��O��xo�#��%;%��_P��s�h%��8kaԩm&��GC��#��m���0��Խ��Ԭ�}�~A�U���|���x�8.5"�To`Lj�'�ҝ�+˚/����&y3�Y���1}=�'�Q���/~@�]���P��pg��     

CREATE SCHEMA IF NOT EXISTS ngp;
CREATE SEQUENCE IF NOT EXISTS ngp.CAUSE_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.CAMPAIGN_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.DESIGNATION_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.IDENTITY_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.IMPACT_FUND_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.NGO_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.ORG_IDENTITY_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.ORGANIZATION_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.PERSON_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.PROCESSOR_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.TRANSACTION_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.WORKPLACE_PARTNER_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.PAYMENT_TYPE_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.WORKPLACE_IDENTITY_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.NONPROFIT_SEQ START 1000;
CREATE SEQUENCE IF NOT EXISTS ngp.WORKPLACE_ACCT_MGR_SEQ START 1000;


CREATE TABLE IF NOT EXISTS ngp.organization (
                id BIGINT DEFAULT nextval('ngp.ORGANIZATION_SEQ'::regclass) NOT NULL ,
                name VARCHAR(80) NOT NULL,
                dba VARCHAR(80),
                external_id VARCHAR(80),
                created_date DATE NOT NULL,
                last_modified_date DATE,
                created_by BIGINT NOT NULL,
                street VARCHAR(200) NOT NULL,
                street_2 VARCHAR(200),
                city VARCHAR(80) NOT NULL,
                state VARCHAR(80) NOT NULL,
                postal_code VARCHAR(10) NOT NULL,
                postal_code_ext VARCHAR(10),
                country VARCHAR(80) NOT NULL,
                latitude NUMERIC,
                longitude NUMERIC,
                phone VARCHAR(20),
                website VARCHAR(80),
                default_language VARCHAR(20) NOT NULL,
                default_currency VARCHAR(3) NOT NULL,
                time_zone VARCHAR(20) NOT NULL,
                is_processor boolean,
                is_nonprofit boolean,
                is_workplace_partner boolean,
                is_workplace_account_manager boolean,
                CONSTRAINT org_id PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS ngp.impact_fund (
                id BIGINT DEFAULT nextval('ngp.IMPACT_FUND_SEQ'::regclass) NOT NULL ,
                name VARCHAR(200) NOT NULL,
                banner_image TEXT NOT NULL,
                card_image TEXT NOT NULL,
                subheading VARCHAR(200),
                description TEXT NOT NULL,
                cta_text VARCHAR(80),
                cta_link TEXT NOT NULL,
                accounting_code VARCHAR(80) NOT NULL,
                scope TEXT NOT NULL,
                created_by BIGINT NOT NULL,
                created_date DATE NOT NULL,
                last_modified_date DATE NOT NULL,
                processor_id BIGINT NOT NULL,
                org_id BIGINT NOT NULL,
                CONSTRAINT impact_fund_id PRIMARY KEY (id)
);


CREATE INDEX fki_fk_org_if_id
 ON ngp.impact_fund USING BTREE
 ( org_id );

CREATE TABLE IF NOT EXISTS ngp.person (
                Id BIGINT DEFAULT nextval('ngp.PERSON_SEQ'::regclass) NOT NULL,
                salutation VARCHAR(8),
                firstName VARCHAR(80) NOT NULL,
                middleName VARCHAR(80),
                lastName VARCHAR(80) NOT NULL,
                suffix VARCHAR(10),
                nickName VARCHAR(80),
                city VARCHAR(20) NOT NULL,
                state VARCHAR(20) NOT NULL,
                postalCode VARCHAR(20) NOT NULL,
                postalCodeExt VARCHAR(20),
                personalEmail VARCHAR(80) NOT NULL,
                dateOfBirth DATE,
                gender VARCHAR(10),
                personalPhone VARCHAR(20) NOT NULL,
                addressLine1 VARCHAR(80) NOT NULL,
                addressLine2 VARCHAR(80),
                org_id BIGINT NOT NULL,
                CONSTRAINT pk_person_id PRIMARY KEY (Id)
);


CREATE INDEX fki_fk_person_org_id
 ON ngp.person USING BTREE
 ( org_id );

CREATE TABLE IF NOT EXISTS ngp.identity (
                id BIGINT  DEFAULT nextval('ngp.IDENTITY_SEQ'::regclass) NOT NULL,
                user_name VARCHAR(80) NOT NULL,
                person_id BIGINT NOT NULL,
                identity_type VARCHAR(80) NOT NULL,
                CONSTRAINT pk_identity_id PRIMARY KEY (id)
);


CREATE UNIQUE INDEX unique_user_name
 ON ngp.identity USING BTREE
 ( user_name );

CREATE INDEX fki_fk_person_id
 ON ngp.identity USING BTREE
 ( person_id );

CREATE TABLE IF NOT EXISTS ngp.payment_type (
                id BIGINT DEFAULT nextval('ngp.PAYMENT_TYPE_SEQ'::regclass) NOT NULL,
                type VARCHAR(20) NOT NULL,
                CONSTRAINT payment_type_pkey PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS ngp.nonprofit (
                npo_id BIGINT DEFAULT nextval('ngp.NONPROFIT_SEQ'::regclass) NOT NULL,
                name VARCHAR(200) NOT NULL,
                description VARCHAR(200) NOT NULL,
                created_date DATE NOT NULL,
                last_modified_date DATE,
                created_by BIGINT NOT NULL,
                account_code VARCHAR(80),
                org_id BIGINT NOT NULL,
                stripe_connect_id VARCHAR(80)
);


CREATE INDEX fki_fk_npo_org_id
 ON ngp.nonprofit USING BTREE
 ( org_id );

CREATE TABLE IF NOT EXISTS ngp.npo_payment_type (
                payment_type_id BIGINT NOT NULL,
                npo_id BIGINT NOT NULL,
                CONSTRAINT pk_npo_pymnt PRIMARY KEY (payment_type_id, npo_id)
);


CREATE INDEX fki_fk_npo_payment_id
 ON ngp.npo_payment_type USING BTREE
 ( npo_id );

CREATE INDEX fki_fk_npo_pymnt_id
 ON ngp.npo_payment_type USING BTREE
 ( payment_type_id );

CREATE TABLE IF NOT EXISTS ngp.person_pref_nonprofit (
                ngo_id BIGINT NOT NULL,
                person_id BIGINT NOT NULL,
                is_restricted BOOLEAN,
                leader_status TEXT,
                publish_flag BOOLEAN,
                release_flag BOOLEAN,
                CONSTRAINT person_pref_ngo_id PRIMARY KEY (ngo_id, person_id)
);


CREATE INDEX fki_fk_person_pref_ngo_id
 ON ngp.person_pref_nonprofit USING BTREE
 ( ngo_id );

CREATE INDEX fki_fk_person_pref_wp_id
 ON ngp.person_pref_nonprofit USING BTREE
 ( person_id );

CREATE TABLE IF NOT EXISTS ngp.workplace_account_manager (
                wp_acct_mgr_Id BIGINT DEFAULT nextval('ngp.WORKPLACE_ACCT_MGR_SEQ'::regclass)  NOT NULL,
                org_id BIGINT NOT NULL
);


CREATE INDEX fki_fk_wam_org_id
 ON ngp.workplace_account_manager USING BTREE
 ( org_id );

CREATE TABLE IF NOT EXISTS ngp.workplace_pref_nonprofit (
                ngo_id BIGINT NOT NULL,
                workplace_partner_id BIGINT NOT NULL,
                is_restricted BOOLEAN,
                CONSTRAINT wp_pref_ngo_id PRIMARY KEY (ngo_id, workplace_partner_id)
);


CREATE INDEX fki_fk_wp_pref_ngo_id
 ON ngp.workplace_pref_nonprofit USING BTREE
 ( ngo_id );

CREATE INDEX fki_fk_wp_pref_wp_id
 ON ngp.workplace_pref_nonprofit USING BTREE
 ( workplace_partner_id );

CREATE TABLE IF NOT EXISTS ngp.processor (
                stripe_connect_id VARCHAR(80),
                is_active BOOLEAN NOT NULL,
                processor_id BIGINT DEFAULT nextval('ngp.PROCESSOR_SEQ'::regclass) NOT NULL,
                org_id BIGINT NOT NULL
);


CREATE INDEX fki_fk_org_id
 ON ngp.processor USING BTREE
 ( org_id );

CREATE TABLE IF NOT EXISTS ngp.campaign (
                id BIGINT DEFAULT nextval('ngp.CAMPAIGN_SEQ'::regclass) NOT NULL,
                name VARCHAR(200) NOT NULL,
                banner_image TEXT NOT NULL,
                card_image TEXT NOT NULL,
                subheading VARCHAR(200),
                description TEXT NOT NULL,
                cta_text VARCHAR(80),
                cta_link TEXT NOT NULL,
                fundraising_goal NUMERIC,
                currency VARCHAR(20) NOT NULL,
                start_date DATE NOT NULL,
                end_date DATE,
                created_by BIGINT NOT NULL,
                created_date DATE NOT NULL,
                last_modified_date DATE NOT NULL,
                one_time_ask_ladder VARCHAR(200) NOT NULL,
                recurring_time_ask_ladder VARCHAR(200) NOT NULL,
                allow_specified_funds BOOLEAN NOT NULL,
                allow_npo_designation BOOLEAN NOT NULL,
                allow_localized_funds BOOLEAN NOT NULL,
                processor_id BIGINT NOT NULL,
                scope TEXT,
                CONSTRAINT campaign_id PRIMARY KEY (id)
);


CREATE INDEX fki_fk_campaign_processor
 ON ngp.campaign USING BTREE
 ( processor_id );

CREATE TABLE IF NOT EXISTS ngp.campaign_funds (
                impact_fund_id BIGINT NOT NULL,
                campaign_id BIGINT NOT NULL,
                CONSTRAINT pk_cf PRIMARY KEY (impact_fund_id, campaign_id)
);


CREATE UNIQUE INDEX camp_impact_fund_id
 ON ngp.campaign_funds USING BTREE
 ( impact_fund_id, campaign_id );

CREATE INDEX fki_fk_imp_fund_camp_id
 ON ngp.campaign_funds USING BTREE
 ( campaign_id );

CREATE TABLE IF NOT EXISTS ngp.workplace_partner (
                acct_manager_id BIGINT NOT NULL,
                reseller BIGINT NOT NULL,
                divison TEXT,
                workplace_partner_id BIGINT DEFAULT nextval('ngp.WORKPLACE_PARTNER_SEQ'::regclass) NOT NULL,
                org_id BIGINT NOT NULL,
                default_processor BIGINT NOT NULL,
                CONSTRAINT pk_wp_id PRIMARY KEY (acct_manager_id)
);


CREATE INDEX fki_fk_wp_org_id
 ON ngp.workplace_partner USING BTREE
 ( org_id );

CREATE INDEX fki_fk_acct_mgr_id
 ON ngp.workplace_partner USING BTREE
 ( acct_manager_id );

CREATE INDEX fki_fk_processor
 ON ngp.workplace_partner USING BTREE
 ( default_processor );

CREATE TABLE IF NOT EXISTS ngp.org_identity (
                id BIGINT DEFAULT nextval('ngp.ORG_IDENTITY_SEQ'::regclass) NOT NULL,
                title TEXT,
                emp_id VARCHAR(80) NOT NULL,
                employer_id BIGINT NOT NULL,
                department VARCHAR(80),
                office VARCHAR(80),
                region VARCHAR(80),
                manager_emp_id VARCHAR(80),
                annual_pay_period VARCHAR(80),
                primary_luw VARCHAR(80),
                where_raised_luw VARCHAR(80),
                identity_id BIGINT NOT NULL,
                is_active BOOLEAN,
                start_date DATE NOT NULL,
                end_date DATE,
                org_id BIGINT NOT NULL,
                CONSTRAINT pk_wp_identity_id PRIMARY KEY (id)
);


CREATE INDEX fki_fk_identity_id
 ON ngp.org_identity USING BTREE
 ( identity_id );

CREATE INDEX fki_fk_wp_partner_id
 ON ngp.org_identity USING BTREE
 ( employer_id );

CREATE INDEX fki_fk_org_identity_id
 ON ngp.org_identity USING BTREE
 ( org_id );

CREATE UNIQUE INDEX uk_org_id
 ON ngp.org_identity USING BTREE
 ( org_id );

CREATE TABLE IF NOT EXISTS ngp.transaction (
                id BIGINT DEFAULT nextval('ngp.TRANSACTION_SEQ'::regclass) NOT NULL,
                tx_date DATE NOT NULL,
                total_amount BIGINT,
                campaign_id BIGINT NOT NULL,
                processor_id BIGINT NOT NULL,
                person_id BIGINT NOT NULL,
                recurring_amount NUMERIC,
                recurring_frequency NUMERIC,
                number_of_installments NUMERIC,
                recurring_start_date DATE,
                recurring_end_date DATE,
                release_flag BOOLEAN,
                publish_flag BOOLEAN,
                check_number NUMERIC,
                check_date DATE,
                payment_status TEXT NOT NULL,
                workplace_partner_id BIGINT NOT NULL,
                CONSTRAINT transaction_id PRIMARY KEY (id)
);


CREATE INDEX fki_fk_processor_id
 ON ngp.transaction USING BTREE
 ( processor_id );

CREATE INDEX fki_fk_tx_campaign_id
 ON ngp.transaction USING BTREE
 ( campaign_id );

CREATE INDEX fki_fk_tx_person_id
 ON ngp.transaction USING BTREE
 ( person_id );

CREATE INDEX fki_fk_tx_wp_id
 ON ngp.transaction USING BTREE
 ( workplace_partner_id );

CREATE TABLE IF NOT EXISTS ngp.designation (
                id BIGINT DEFAULT nextval('ngp.DESIGNATION_SEQ'::regclass) NOT NULL,
                designee BIGINT NOT NULL,
                transaction_id BIGINT NOT NULL,
                allocation_amount NUMERIC,
                allocation_percent NUMERIC,
                CONSTRAINT designation_id PRIMARY KEY (id, designee)
);


CREATE INDEX fki_fk_desig_tx_id
 ON ngp.designation USING BTREE
 ( transaction_id );

CREATE TABLE IF NOT EXISTS ngp.campaign_payment_type (
                payment_type_id BIGINT NOT NULL,
                campaign_id BIGINT NOT NULL
);


CREATE UNIQUE INDEX campaign_payment_id
 ON ngp.campaign_payment_type USING BTREE
 ( payment_type_id, campaign_id );

CREATE INDEX fki_fk_pymnt_campaign_id
 ON ngp.campaign_payment_type USING BTREE
 ( campaign_id );

CREATE INDEX fki_payment_id
 ON ngp.campaign_payment_type USING BTREE
 ( payment_type_id );

CREATE TABLE IF NOT EXISTS ngp.cause (
                id BIGINT DEFAULT nextval('ngp.CAUSE_SEQ'::regclass) NOT NULL,
                name VARCHAR(200) NOT NULL,
                description VARCHAR(200) NOT NULL,
                created_date DATE NOT NULL,
                last_modified_date DATE,
                created_by BIGINT NOT NULL,
                account_code VARCHAR(80),
                CONSTRAINT pk_cause_id PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS ngp.workplace_pref_cause (
                cause_id BIGINT NOT NULL,
                workplace_partner_id BIGINT NOT NULL,
                is_restricted BOOLEAN,
                CONSTRAINT wp_pref_cause_id PRIMARY KEY (cause_id, workplace_partner_id)
);


CREATE INDEX fki_fk_wp_pref_cc_id
 ON ngp.workplace_pref_cause USING BTREE
 ( cause_id );

CREATE INDEX fki_fk_wp_pref_wp__cause_id
 ON ngp.workplace_pref_cause USING BTREE
 ( workplace_partner_id );

CREATE TABLE IF NOT EXISTS ngp.person_pref_cause (
                cause_id BIGINT NOT NULL,
                person_id BIGINT NOT NULL,
                is_restricted BOOLEAN,
                CONSTRAINT pk_person_pref_cause_id PRIMARY KEY (cause_id, person_id)
);


CREATE INDEX fki_fk_per_cause_id
 ON ngp.person_pref_cause USING BTREE
 ( cause_id );

CREATE INDEX fki_fk_pref_person_id
 ON ngp.person_pref_cause USING BTREE
 ( person_id );

ALTER TABLE ngp.processor ADD CONSTRAINT fk_org_id
FOREIGN KEY (org_id)
REFERENCES ngp.organization (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.workplace_account_manager ADD CONSTRAINT fk_wam_org_id
FOREIGN KEY (org_id)
REFERENCES ngp.organization (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.workplace_partner ADD CONSTRAINT fk_org_id
FOREIGN KEY (org_id)
REFERENCES ngp.organization (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.nonprofit ADD CONSTRAINT fk_npo_org_id
FOREIGN KEY (org_id)
REFERENCES ngp.organization (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.org_identity ADD CONSTRAINT fk_org_identity_id
FOREIGN KEY (org_id)
REFERENCES ngp.organization (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.person ADD CONSTRAINT fk_person_org_id
FOREIGN KEY (org_id)
REFERENCES ngp.organization (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.impact_fund ADD CONSTRAINT fk_org_if_id
FOREIGN KEY (org_id)
REFERENCES ngp.organization (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.campaign_funds ADD CONSTRAINT fk_camp_imp_fund_id
FOREIGN KEY (impact_fund_id)
REFERENCES ngp.impact_fund (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.identity ADD CONSTRAINT fk_person_id
FOREIGN KEY (person_id)
REFERENCES ngp.person (Id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.person_pref_cause ADD CONSTRAINT fk_pref_person_id
FOREIGN KEY (person_id)
REFERENCES ngp.person (Id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.transaction ADD CONSTRAINT fk_tx_person_id
FOREIGN KEY (person_id)
REFERENCES ngp.person (Id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.person_pref_nonprofit ADD CONSTRAINT fk_person_pref_person_id
FOREIGN KEY (person_id)
REFERENCES ngp.person (Id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.org_identity ADD CONSTRAINT fk_identity_id
FOREIGN KEY (identity_id)
REFERENCES ngp.identity (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.campaign_payment_type ADD CONSTRAINT payment_id
FOREIGN KEY (payment_type_id)
REFERENCES ngp.payment_type (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.npo_payment_type ADD CONSTRAINT fk_npo_pymnt_id
FOREIGN KEY (payment_type_id)
REFERENCES ngp.payment_type (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.workplace_pref_nonprofit ADD CONSTRAINT fk_wp_pref_ngo_id
FOREIGN KEY (ngo_id)
REFERENCES ngp.nonprofit (npo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.person_pref_nonprofit ADD CONSTRAINT fk_person_pref_ngo_id
FOREIGN KEY (ngo_id)
REFERENCES ngp.nonprofit (npo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.designation ADD CONSTRAINT fk_desig_npo_id
FOREIGN KEY (designee)
REFERENCES ngp.nonprofit (npo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.npo_payment_type ADD CONSTRAINT fk_npo_payment_id
FOREIGN KEY (npo_id)
REFERENCES ngp.nonprofit (npo_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.workplace_partner ADD CONSTRAINT fk_acct_mgr_id
FOREIGN KEY (acct_manager_id)
REFERENCES ngp.workplace_account_manager (wp_acct_mgr_Id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.workplace_partner ADD CONSTRAINT fk_processor
FOREIGN KEY (default_processor)
REFERENCES ngp.processor (processor_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.transaction ADD CONSTRAINT fk_tx_processor_id
FOREIGN KEY (processor_id)
REFERENCES ngp.processor (processor_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.campaign ADD CONSTRAINT fk_campaign_processor
FOREIGN KEY (processor_id)
REFERENCES ngp.processor (processor_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.campaign_payment_type ADD CONSTRAINT fk_pymnt_campaign_id
FOREIGN KEY (campaign_id)
REFERENCES ngp.campaign (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.transaction ADD CONSTRAINT fk_tx_campaign_id
FOREIGN KEY (campaign_id)
REFERENCES ngp.campaign (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.campaign_funds ADD CONSTRAINT fk_imp_fund_camp_id
FOREIGN KEY (campaign_id)
REFERENCES ngp.campaign (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.transaction ADD CONSTRAINT fk_tx_wp_id
FOREIGN KEY (workplace_partner_id)
REFERENCES ngp.workplace_partner (workplace_partner_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.workplace_pref_cause ADD CONSTRAINT fk_wp_pref_wp_id
FOREIGN KEY (workplace_partner_id)
REFERENCES ngp.workplace_partner (workplace_partner_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.org_identity ADD CONSTRAINT fk_wp_partner_id
FOREIGN KEY (employer_id)
REFERENCES ngp.workplace_partner (workplace_partner_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.designation ADD CONSTRAINT fk_desig_tx_id
FOREIGN KEY (transaction_id)
REFERENCES ngp.transaction (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.person_pref_cause ADD CONSTRAINT fk_per_cause_id
FOREIGN KEY (cause_id)
REFERENCES ngp.cause (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE ngp.workplace_pref_cause ADD CONSTRAINT fk_wp_pref_cause_id
FOREIGN KEY (cause_id)
REFERENCES ngp.cause (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
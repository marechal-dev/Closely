CREATE EXTENSION IF NOT EXISTS postgis;

CREATE EXTENSION IF NOT EXISTS pg_uuidv7;

CREATE OR REPLACE FUNCTION calculate_haversine_distance(
    lat1 FLOAT,
    lon1 FLOAT,
    lat2 FLOAT,
    lon2 FLOAT
) RETURNS FLOAT AS $$
DECLARE
    -- Earth's radius in kilometers
    R CONSTANT FLOAT := 6371;

    -- Convert degrees to radians
    lat1_rad FLOAT := radians(lat1);
    lon1_rad FLOAT := radians(lon1);
    lat2_rad FLOAT := radians(lat2);
    lon2_rad FLOAT := radians(lon2);

    -- Differences in coordinates
    dlat FLOAT := lat2_rad - lat1_rad;
    dlon FLOAT := lon2_rad - lon1_rad;

    -- Haversine formula components
    a FLOAT;
    c FLOAT;
    distance FLOAT;
BEGIN
    -- Haversine formula calculation
    a := sin(dlat/2)^2 +
         cos(lat1_rad) * cos(lat2_rad) *
         sin(dlon/2)^2;

    c := 2 * atan2(sqrt(a), sqrt(1-a));

    -- Calculate the distance in kilometers and convert to meters
    distance := R * c * 1000;

    RETURN distance;
END;
$$ LANGUAGE plpgsql;

CREATE TYPE "discount_kind" AS ENUM (
  'fixed',
  'percentage'
);

CREATE TYPE "entity_kind" AS ENUM (
  'company',
  'customer'
);

CREATE TABLE "companies" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v7()),
  "title" text NOT NULL,
  "legal_entity_id" text UNIQUE NOT NULL,
  "location" geography(Point,4326) NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "modified_at" timestamp DEFAULT null,
  "deleted_at" timestamp DEFAULT null
);

CREATE TABLE "customers" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v7()),
  "full_name" text NOT NULL,
  "citizen_id" varchar(11) UNIQUE NOT NULL,
  "username" varchar(24) UNIQUE NOT NULL,
  "email" text UNIQUE NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "modified_at" timestamp DEFAULT null,
  "deleted_at" timestamp DEFAULT null
);

CREATE TABLE "customers_discount_tickers_usages" (
  "user_citizen_id" uuid NOT NULL,
  "discount_ticket_id" uuid NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  PRIMARY KEY ("user_citizen_id", "discount_ticket_id")
);

CREATE TABLE "discount_tickets" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v7()),
  "description" text NOT NULL,
  "type" discount_kind NOT NULL,
  "discount_value" decimal NOT NULL,
  "max_number_of_usages" integer,
  "start_date" timestamp NOT NULL,
  "end_date" timestamp,
  "company_id" uuid NOT NULL,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "modified_at" timestamp DEFAULT null,
  "deleted_at" timestamp DEFAULT null
);

CREATE TABLE "profile_pictures" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (uuid_generate_v7()),
  "entity_id" uuid NOT NULL,
  "entity_type" entity_kind NOT NULL,
  "url" text DEFAULT null,
  "created_at" timestamp NOT NULL DEFAULT (now()),
  "modified_at" timestamp DEFAULT null,
  "deleted_at" timestamp DEFAULT null
);

CREATE INDEX "idx_companies_location" ON "companies" USING GIST ("location");

CREATE INDEX "idx_discount_ticket_id" ON "customers_discount_tickers_usages" USING BTREE ("discount_ticket_id");

CREATE INDEX "idx_company_id" ON "discount_tickets" ("company_id");

CREATE INDEX "idx_active_entity_type_id" ON "profile_pictures" ("entity_type", "entity_id") WHERE deleted_at IS NULL;

COMMENT ON COLUMN "profile_pictures"."entity_id" IS 'This column alongside with entity_type makes this table polymorphic, which saves us some space, this is why it does not have any FK constraints.';

ALTER TABLE "customers_discount_tickers_usages" ADD FOREIGN KEY ("user_citizen_id") REFERENCES "customers" ("citizen_id");

ALTER TABLE "customers_discount_tickers_usages" ADD FOREIGN KEY ("discount_ticket_id") REFERENCES "discount_tickets" ("id");

ALTER TABLE "companies" ADD FOREIGN KEY ("id") REFERENCES "discount_tickets" ("company_id");

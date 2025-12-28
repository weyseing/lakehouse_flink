-- =========================
-- LOCAL / PROD CATALOG SETUP
-- =========================

-- Default source Kafka catalog
USE CATALOG default_catalog;
USE default_database;

-- -------------------------
-- Source Table (Kafka)
-- -------------------------
CREATE TABLE IF NOT EXISTS source_table (
  id INT,
  product STRING,
  amount INT,
  buyer_id INT,
  create_date STRING,
  update_date STRING,
  row_time BIGINT,
  PRIMARY KEY (id) NOT ENFORCED
) WITH (
  'connector' = 'upsert-kafka',
  'topic' = 'stream_order_intake',
  -- PROD Kafka bootstrap (replace with env later)
  'properties.bootstrap.servers' = 'broker:9092',
  'key.format' = 'json',
  'value.format' = 'json'
);

-- =========================
-- ICEBERG / LAKEHOUSE CATALOG
-- =========================

-- ----- Local MinIO + Iceberg REST -----
CREATE CATALOG IF NOT EXISTS local_catalog WITH (
  'type'='iceberg',
  'catalog-impl'='org.apache.iceberg.rest.RESTCatalog',
  'uri'='http://lakehouse_catalog:8181',
  'warehouse'='s3a://lakehouse/',
  'io-impl'='org.apache.iceberg.aws.s3.S3FileIO',
  'property-version'='1',
  'access-key'='admin',
  'secret-key'='12345678',
  's3.endpoint'='http://lakehouse_storage:9000',
  's3.region'='ap-southeast-1'
);

-- ----- PROD Glue Catalog -----
CREATE CATALOG IF NOT EXISTS glue_catalog WITH (
  'type'='iceberg',
  'catalog-impl'='org.apache.iceberg.aws.glue.GlueCatalog',
  'warehouse'='s3://poc-iceberg-20251123/iceberg-warehouse/',
  'io-impl'='org.apache.iceberg.aws.s3.S3FileIO'
);

-- =========================
-- USE CATALOG / DATABASE
-- =========================

-- Local / prod toggle: pick the catalog to use
-- USE local_catalog;  -- uncomment for local
-- USE glue_catalog;   -- uncomment for prod

-- Database
CREATE DATABASE IF NOT EXISTS lakehouse_db;
USE lakehouse_db;

-- =========================
-- Sink Table (Iceberg)
-- =========================
CREATE TAB

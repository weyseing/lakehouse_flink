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
  'topic' = 'lakehouse_txn_stream_txn_metadata',
  'properties.bootstrap.servers' = 'broker:29092',
  'key.format' = 'json',
  'value.format' = 'json'
);

-- =========================
-- ICEBERG / LAKEHOUSE CATALOG
-- =========================

-- ----- Local MinIO + Iceberg REST -----
CREATE CATALOG local_catalog WITH (
  'type'='iceberg',
  'catalog-impl'='org.apache.iceberg.rest.RESTCatalog',
  'uri'='http://lakehouse_catalog:8181',
  'warehouse'='s3://lakehouse/'
);

-- ----- PROD Glue Catalog -----
-- CREATE CATALOG IF NOT EXISTS glue_catalog WITH (
--   'type'='iceberg',
--   'catalog-impl'='org.apache.iceberg.aws.glue.GlueCatalog',
--   'warehouse'='s3://poc-iceberg-20251123/iceberg-warehouse/',
--   'io-impl'='org.apache.iceberg.aws.s3.S3FileIO'
-- );

-- =========================
-- USE CATALOG / DATABASE
-- =========================

-- TOGGLE: Choose your environment here
USE CATALOG local_catalog;  -- Use this for Local MinIO
-- USE CATALOG glue_catalog;   -- Use this for AWS EMR/Glue

-- Create the Database in the active catalog
CREATE DATABASE IF NOT EXISTS lakehouse_db;
USE lakehouse_db;

-- =========================
-- Sink Table (Iceberg)
-- =========================
CREATE TABLE IF NOT EXISTS sink_order_iceberg (
  `id` INT,
  `product` STRING,
  `amount` INT,
  `buyer_id` INT,
  `create_date` STRING,
  `update_date` STRING,
  `row_time` BIGINT,  -- Match the source schema
  PRIMARY KEY (`id`) NOT ENFORCED
) WITH (
  'format-version' = '2',
  'write.upsert.enabled' = 'true'
);

-- =========================
-- Flink Job Settings
-- =========================
SET 'pipeline.name' = 'job_upsert_order_iceberg';
SET 'execution.checkpointing.interval' = '10s'; -- Critical for Iceberg commits
SET 'execution.checkpointing.mode' = 'EXACTLY_ONCE';

-- =========================
-- INSERT (Streaming Job)
-- =========================
-- We use full paths to be absolutely sure where data is coming from/going to
INSERT INTO sink_order_iceberg
SELECT 
    id, 
    product, 
    amount, 
    buyer_id, 
    create_date, 
    update_date, 
    row_time
FROM default_catalog.default_database.source_table;
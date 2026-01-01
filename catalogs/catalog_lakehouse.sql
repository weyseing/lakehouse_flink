CREATE CATALOG catalog_lakehouse WITH (
  'type'='iceberg',
  'catalog-impl'='org.apache.iceberg.rest.RESTCatalog',
  'uri'='http://lakehouse-catalog:8181',
  'warehouse'='s3://confluent-kafka-rms/lakehouse/storage',
  's3.endpoint'='http://lakehouse-storage:9000',
  's3.path-style-access'='true',
  's3.access-key'='admin',
  's3.secret-key'='12345678',
  'client.region'='ap-southeast-1'
);
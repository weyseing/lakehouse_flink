CREATE CATALOG awsdatacatalog WITH (
  'type'='iceberg',
  'catalog-impl'='${CATALOG_IMPL}',
  'warehouse'='s3://${ICEBERG_S3_BUCKET}/${CATALOG_AWSDATACATALOG_STORAGE}',
  'client.region'='${ICEBERG_S3_REGION}',
  'uri'='${CATALOG_URI}',
  's3.endpoint'='${S3_ENDPOINT}',
  's3.path-style-access'='${S3_PATH_STYLE}'
);
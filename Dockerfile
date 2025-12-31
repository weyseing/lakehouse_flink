FROM flink:1.20.0-scala_2.12

# flink lib jars
COPY lib_jars/lib/*.jar /opt/flink/lib/

# work dir
WORKDIR /lakehouse_flink/cli

# entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

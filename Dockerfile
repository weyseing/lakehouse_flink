FROM flink:1.20.0-scala_2.12

# Create a directory for global custom JARs
RUN mkdir -p /opt/flink/usrlib

# Copy your JARs into the global lib path
COPY lib/*.jar /opt/flink/lib/

# Set entrypoint to Flink
ENTRYPOINT ["/docker-entrypoint.sh"]

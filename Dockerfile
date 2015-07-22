FROM java:7-jre
MAINTAINER Piyush Mattoo <Piyush.Mattoo@software.dell.com> (@pmattoo)

# Download Doradus logstash
ENV LOGSTASH_HOME /opt/logstash
ENV LOGSTASH_VERSION='1.5.0'
ENV LOGSTASH_NAME="logstash-${LOGSTASH_VERSION}"
ENV LOGSTASH_URL="https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/${LOGSTASH_NAME}.tar.gz?raw"
ENV tableName="$(echo 'logs_'${DOCKER_APP_NAME}'_'${DOCKER_NAMESPACE})"
ENV data="{\"LoggingApplication\":{\"key\":\"LoggingApp\", \"tables\": {\"$tableName\": { \"fields\": {\"Timestamp\": {\"type\": \"timestamp\"},\"LogLevel\": {\"type\": \"text\"},\"Message\": {\"type\": \"text\"}, \"Source\": {\"type\": \"text\"}}}}}}"

RUN mkdir ${LOGSTASH_HOME} && \
    cd ${LOGSTASH_HOME} && \
    wget https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/logstash-1.5.0.tar.gz?raw && \
    tar -xzf logstash-1.5.0.tar.gz?raw && \
	mv ${LOGSTASH_NAME} logstash && \
    rm logstash-1.5.0.tar.gz?raw
	
# Create Logging Doradus Table
RUN curl -X POST -H "content-type: application/json" -u ${DOCKER_DORADUS_USER}:${DOCKER_DORADUS_PWD} -d "$data" http://${DORADUS_HOST}:${DORADUS_PORT}/_applications?tenant=${DOCKER_DORADUS_TENANT}

RUN chmod +x /bin/boot
	
# Creates the volume to a container created from that image
VOLUME ["/host/var/log"]

# Start logstash
ENTRYPOINT ["/bin/boot"]

# Valid commands: `agent`, `web`, `configtest`
# Default (empty command) runs the ELK stack
CMD []
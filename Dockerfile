FROM java:7-jre
MAINTAINER Piyush Mattoo <Piyush.Mattoo@software.dell.com> (@pmattoo)

# Download Doradus logstash
ENV LOGSTASH_HOME /opt/logstash
ENV LOGSTASH_VERSION='1.5.0'
ENV LOGSTASH_NAME="logstash-${LOGSTASH_VERSION}"
ENV LOGSTASH_URL="https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/${LOGSTASH_NAME}.tar.gz?raw"

RUN mkdir ${LOGSTASH_HOME} && \
    cd ${LOGSTASH_HOME} && \
    wget https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/logstash-1.5.0.tar.gz?raw && \
    tar -xzf logstash-1.5.0.tar.gz?raw && \
	mv ${LOGSTASH_NAME} logstash && \
    rm logstash-1.5.0.tar.gz?raw
	
# Creates the volume to a container created from that image
VOLUME ["/host/var/log"]

WORKDIR /opt/logstash
COPY ./boot /

# Add executable permission to boot script
RUN chmod +x /boot

# Start logstash
ENTRYPOINT ["/boot"]

# Valid commands: `agent`, `web`, `configtest`
CMD ["agent"]
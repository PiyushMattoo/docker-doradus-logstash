FROM java:7-jre
MAINTAINER Piyush Mattoo <Piyush.Mattoo@software.dell.com> (@pmattoo)

# Download Doradus logstash
ENV LOGSTASH_HOME /opt/logstash

RUN mkdir ${LOGSTASH_HOME} && \
    cd ${LOGSTASH_HOME} && \
    wget https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/logstash-1.5.0.tar.gz?raw && \
    tar -xzf logstash-1.5.0.tar.gz?raw && \
    rm logstash-1.5.0.tar.gz?raw

	
# Creates the volume to a container created from that image
VOLUME ["/host/var/log"]

# Start logstash
ENTRYPOINT ["/app/bin/boot"]

# Valid commands: `agent`, `web`, `configtest`
# Default (empty command) runs the ELK stack
CMD []
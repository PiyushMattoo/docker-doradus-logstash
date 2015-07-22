FROM java:7-jre
MAINTAINER Piyush Mattoo <Piyush.Mattoo@software.dell.com> (@pmattoo)

# Download Doradus logstash
ENV LOGSTASH_HOME /opt/logstash

RUN mkdir ${LOGSTASH_HOME} && \
    cd /tmp && \
    wget https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/logstash-1.5.0.tar.gz?raw && \
    tar -xzf ./logstash-1.5.0.tar.gz && \
    mv ./logstash-1.5.0 /opt/logstash && \
    rm ./logstash-1.5.0.tar.gz && \

	
# Creates the volume to a container created from that image
VOLUME ["/host/var/log"]

# Valid commands: `agent`, `web`, `configtest`
# Default (empty command) runs the ELK stack
CMD []
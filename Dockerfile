FROM java:7-jre
MAINTAINER Piyush Mattoo <Piyush.Mattoo@software.dell.com> (@pmattoo)

# Download Doradus logstash
RUN cd /tmp && \
    wget https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/logstash-1.5.0.tar.gz?raw && \
    tar -xzvf ./logstash-1.5.0.tar.gz && \
    mv ./logstash-1.5.0 /opt/logstash && \
    rm ./logstash-1.5.0.tar.gz

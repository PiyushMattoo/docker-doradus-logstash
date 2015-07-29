# Doradus Logstash Dockerfile

This is a highly configurable Doradus Logstash image running logstash and a custom Doradus GEM.  The docker container logs are read by mounting `/var/log/` inside the docker-doradus-logstash container. The doradus-docker-logstash container monitors the mounted directory, tailing the log files, queueing up batches of records and when it either reaches the maximum batch size or when the maximum idle time has elapsed then docker-doradus-logstash would then write the log events to Doradus for enhanced performance reasons. The image employs the Doradus-logstash GEM to interact with Doradus which is characterized by batch_size, batch_wait and can be viewed at https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse

## Environment Variables

Runtime behavior of docker-doradus-logstash can be modified by passing the below environment to `docker run` :

 * **`DORADUS_HOST`**: URL of the Doradus hosting server. 
 * **`DORADUS_PORT`**: Port-number of the Doradus service. 
 * **`DOCKER_APP_NAME`**: Docker app name. 
 * **`DOCKER_NAMESPACE`**: Docker namespace.  
 * **`DOCKER_DORADUS_USER`**: Doradus User.
 * **`DOCKER_DORADUS_PWD`**: Doradus Password.
 
## How to build the image

`sudo docker build -t pmattoo/docker-doradus-logstash .`

## How to use this image

`docker run -i -t -v /var/log:/host/var/log --name <your-container-name> pmattoo/docker-doradus-logstash`
`/usr/bin/docker-doradus-logstash.sh agent`
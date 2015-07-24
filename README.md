# Doradus Logstash Dockerfile

This is a highly configurable Doradus Logstash image running logstash and a custom Doradus GEM.  The docker conatiner logs are read by mounting `/var/lib/docker/containers` inside the docker-doradus-logstash container. The docker image monitors the mounted directory, tailing the log files, queueing up batches of records and when it either reaches the maximum batch size or when the maximum idle time has elapsed then docker-doradus-logstash would then write the log events to Doradus for enhanced performance reasons. The image employs the Doradus-logstash GEM to interact with Doradus which is characterized by batch_size, batch_wait and can be viewed at https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse

## Environment Variables

Runtime behavior of docker-doradus-logstash can be modified by passing the below environment to `docker run` :

 * **`DORADUS_HOST`**: URL of the Doradus hosting server. 
 * **`DORADUS_PORT`**: Port-number of the Doradus service. 
 * **`DOCKER_APP_NAME`**: Docker app name. 
 * **`DOCKER_NAMESPACE`**: Docker namespace. 
 * **`DOCKER_DORADUS_TENANT`**: Docker Dradus Tenant. 
 * **`DOCKER_DORADUS_USER`**: Doradus User.
 * **`DOCKER_DORADUS_PWD`**: Doradus Password.
 
## How to build the image

`sudo docker build -t pmattoo/docker-doradus-logstash .`

## How to use this image

`docker run -i -t -e DORADUS_HOST=<Doradus_HOST> -e DORADUS_PORT=<DORADUS_PORT> -e DOCKER_APP_NAME=<DOCKER_APP_NAME> -e DOCKER_NAMESPACE=<DOCKER_NAMESPACE> -e DOCKER_DORADUS_TENANT=<DOCKER_DORADUS_TENANT> –e DOCKER_DORADUS_USER=<DOCKER_DORADUS_USER> –e DOCKER_DORADUS_PWD=<DOCKER_DORADUS_PWD> -v <HOST_DIR>:/host/var/log pmattoo/docker-doradus-logstash`

## Logstash configuration

There are currently two supported ways of including your Logstash config files in your container:

  * Download your config files from the Internet
  * Mount a volume on the host machine containing your config files

> Any files in `/opt/logstash/conf.d` with the `.conf` extension will get loaded by logstash.

#### Download your config files from the Internet

To use your own hosted config files, your config files must be one of the following two file types:

  * A monolithic config file (`*.conf`)
  * A tarball containing your config files (`*.tar`, `*.tar.gz`, or `*.tgz`)

By default, if `LOGSTASH_CONFIG_URL` isn't defined, an example [logstash.conf][2] will be downloaded and used in your container.

> The default `logstash.conf` only listens on `file` inputs. If you wish to configure `tcp` and/or `udp` input, use your own logstash configuration files and expose the ports yourself. See [logstash documentation][10] for config syntax and more information.

# Doradus Logstash Dockerfile

This is a highly configurable Doradus Logstash image running logstash and a custom Doradus GEM.

## How to build the image

sudo docker build -t pmattoo/docker-doradus-logstash .

## How to use this image

`docker run -i -t -e DORADUS_HOST=<Doradus_HOST> -e DORADUS_PORT=<DORADUS_PORT> -e DOCKER_APP_NAME=<DOCKER_APP_NAME> -e DOCKER_NAMESPACE=<DOCKER_NAMESPACE> -e DOCKER_DORADUS_TENANT=<DOCKER_DORADUS_TENANT> –e DOCKER_DORADUS_USER=<DOCKER_DORADUS_USER> –e DOCKER_DORADUS_PWD=<DOCKER_DORADUS_PWD> -v /var/log:/host/var/log pmattoo/docker-doradus-logstash`

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

> The default `logstash.conf` only listens on `stdin` and `file` inputs. If you wish to configure `tcp` and/or `udp` input, use your own logstash configuration files and expose the ports yourself. See [logstash documentation][10] for config syntax and more information.

## Contributing

1. Fork it
2. Checkout the develop branch (`git checkout -b develop`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## License

This application is distributed under the [Apache License, Version 2.0][5].

#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

LOGSTASH_SRC_DIR='/opt/logstash'

##Test
DOCKER_DORADUS_USER=SuperDory
DOCKER_DORADUS_PWD=Alpha1
DORADUS_HOST=ec2-52-2-103-189.compute-1.amazonaws.com
DORADUS_PORT=8080
#DOCKER_DORADUS_TENANT=MattooPiyush
DOCKER_APP_NAME=test
DOCKER_NAMESPACE=service



# If you don't provide a value for the LOGSTASH_CONFIG_URL env
# var, your install will default to our very basic logstash.conf file.
#
LOGSTASH_DEFAULT_CONFIG_URL='https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/logstash.conf?raw'
#LOGSTASH_CONFIG_URL=${LOGSTASH_CONFIG_URL:-${LOGSTASH_DEFAULT_CONFIG_URL}}
LOGSTASH_CONFIG_DIR="${LOGSTASH_SRC_DIR}/conf.d"
LOGSTASH_CONFIG_PATH="${LOGSTASH_CONFIG_DIR}/**/*.conf"

LOGSTASH_LOG_DIR='/var/log/logstash'
LOGSTASH_LOG_FILE="${LOGSTASH_LOG_DIR}/logstash.log"
tableName="$(echo 'logs_'${DOCKER_APP_NAME}'_'${DOCKER_NAMESPACE})"
data="{\"LoggingApplication\":{\"key\":\"LoggingApp\", \"tables\": {\"$tableName\": { \"fields\": {\"Timestamp\": {\"type\": \"timestamp\"},\"LogLevel\": {\"type\": \"text\"},\"Message\": {\"type\": \"text\"}, \"Source\": {\"type\": \"text\"}}}}}}"


function logstash_create_log_dir() {
    local log_dir="$LOGSTASH_LOG_DIR"

    if ! mkdir -p "${log_dir}" ; then
        echo "Unable to create ${log_dir}" >&2
    fi
}

# Create the logstash conf dir if it doesn't already exist
#
function logstash_create_config_dir() {
    local config_dir="$LOGSTASH_CONFIG_DIR"

    if ! mkdir -p "${config_dir}" ; then
        echo "Unable to create ${config_dir}" >&2
    fi
}


function create_doradus_table() {
   curl -X POST -H "content-type: application/json" -u ${DOCKER_DORADUS_USER}:${DOCKER_DORADUS_PWD} -d "$data" http://${DORADUS_HOST}:${DORADUS_PORT}/_applications
}

function logstash_start_agent() {
    local config_path="$LOGSTASH_CONFIG_DIR/logstash.conf"
    local log_file="$LOGSTASH_LOG_FILE"
 
    case "$1" in
    # run just the agent
    'agent')
        exec "$binary" \
             agent \
             --config "$config_path" \
             --log "$log_file" \
             --
        ;;
    # test the logstash configuration
    'configtest')
        exec "$binary" \
             agent \
             --config "$config_path" \
             --log "$log_file" \
             --configtest \
             --
        ;;
    esac
}

#logstash_create_config_dir

#logstash_download_config

logstash_create_log_dir
	
create_doradus_table

logstash_start_agent

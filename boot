#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

# Disable LOGSTASH_TRACE if it hasn't been defined
: "${LOGSTASH_TRACE:=false}"

# Set LOGSTASH_TRACE to enable debugging
[[ $LOGSTASH_TRACE ]] && set -x

SCRIPT_ROOT=$(readlink -f "$(dirname "$0")"/..)
export SCRIPT_ROOT

. "${SCRIPT_ROOT}/logstash.sh" || exit 1

function main() {

    logstash_create_config_dir

    logstash_download_config

    logstash_create_log_dir
	
	create_doradus_table

    # Fire up logstash!
    #
    logstash_start_agent "$@"
}

main "$@"

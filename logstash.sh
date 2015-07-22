#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

LOGSTASH_SRC_DIR='/opt/logstash'
LOGSTASH_BINARY="${LOGSTASH_SRC_DIR}/bin/logstash"

# If you don't provide a value for the LOGSTASH_CONFIG_URL env
# var, your install will default to our very basic logstash.conf file.
#
LOGSTASH_DEFAULT_CONFIG_URL='https://git.labs.dell.com/projects/BD/repos/logstash-output-batched_http/browse/artifacts/logstash.conf?raw'
LOGSTASH_CONFIG_URL=${LOGSTASH_CONFIG_URL:-${LOGSTASH_DEFAULT_CONFIG_URL}}
LOGSTASH_CONFIG_DIR="${LOGSTASH_SRC_DIR}/conf.d"
LOGSTASH_CONFIG_PATH="${LOGSTASH_CONFIG_DIR}/**/*.conf"

LOGSTASH_LOG_DIR='/var/log/logstash'
LOGSTASH_LOG_FILE="${LOGSTASH_LOG_DIR}/logstash.log"

# Download single config file. Source file extension must be .conf
#
function __download_config() {
    local config_url="$1"
    local config_dir="$2"

    cd "${config_dir}" \
        && curl -Os "${config_url}"
}

# Download and extract config file(s) using a tarball. Source file extension
# must be either .tar, .tar.gz, or .tgz.
#
function __download_tar() {
    local config_url="$1"
    local config_dir="$2"

    pushd "${config_dir}" > /dev/null
    curl -SL "${config_url}" \
        | tar -xzC "${config_dir}" --strip-components=1
    popd > /dev/null
}

# Download and extract config file(s) using a zipball. Source file extension
# must be .zip.
#
function __download_zip() {
    : # no-op
}

# Download config file(s) from a git repository. Source file extension
# must be .git.
#
function __download_git() {
    : # no-op
}

# Create the logstash conf dir if it doesn't already exist
#
function logstash_create_config_dir() {
    local config_dir="$LOGSTASH_CONFIG_DIR"

    if ! mkdir -p "${config_dir}" ; then
        echo "Unable to create ${config_dir}" >&2
    fi
}

# Download the logstash configs if the config directory is empty
#
function logstash_download_config() {
    local config_url="$LOGSTASH_CONFIG_URL"
    local config_dir="$LOGSTASH_CONFIG_DIR"

    if [ ! "$(ls -A $config_dir)" ]; then
        case "$config_url" in
            *.conf)
                __download_config "$config_url" "$config_dir"
                ;;
            *.tar|*.tar.gz|*.tgz)
                __download_tar "$config_url" "$config_dir"
                ;;
            *.war|*.zip)
                __download_zip "$config_url" "$config_dir"
                ;;
            *.git)
                __download_git "$config_url" "$config_dir"
                ;;
        esac

    fi
}

function logstash_create_log_dir() {
    local log_dir="$LOGSTASH_LOG_DIR"

    if ! mkdir -p "${log_dir}" ; then
        echo "Unable to create ${log_dir}" >&2
    fi
}

function logstash_start_agent() {
    local binary="$LOGSTASH_BINARY"
    local config_path="$LOGSTASH_CONFIG_PATH"
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
    # run just the web
    'web')
        exec "$binary" \
             web
        ;;
    # run agent+web (default operation)
    *)
        exec "$binary" \
             agent \
             --config "$config_path" \
             --log "$log_file" \
             -- \
             web
        ;;
    esac
}
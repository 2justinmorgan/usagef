#!/bin/bash

export DOCKER_IMG_WORKDIR_PATH="/usagef_code"
export DOCKER_IMG_NAME_PREFIX="usagef"
export DOCKER_IMG_NAME_TESTING="${DOCKER_IMG_NAME_PREFIX}-testing:1"

export DIR_BUILD_NAME="build"
export DIR_BUILD="${DIR_BUILD_NAME}"
export DIR_SRC_NAME="src"
export DIR_SRC="${DIR_SRC_NAME}"
export DIR_TOOLS_NAME="tools"
export DIR_TOOLS="${DIR_TOOLS_NAME}"
export DIR_TOOLS_SHELL_TESTING="${DIR_TOOLS}/shell/testing"
export DIR_TESTS_NAME="tests"
export DIR_TESTS="${DIR_TESTS_NAME}"
export DIR_TESTS_MISC="${DIR_TESTS}/misc"
export DIR_TESTS_OUTPUT="${DIR_TESTS}/output"
export DIR_TESTS_TMP="${DIR_TESTS}/tmp"
export DIR_TESTS_OUTPUT_EXPECTED="${DIR_TESTS_OUTPUT}/expected"

export REGEX_USAGEF_VERSION='^[0-9]+\.[0-9]+\.[0-9]+$'

# used to verify the contents of this file have been sourced
function check_sourced_strings() {
	:
}

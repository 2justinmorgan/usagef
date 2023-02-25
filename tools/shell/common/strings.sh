#!/bin/bash

export ERR_ARGV_NEEDED="args are needed"
export ERR_ARGV_EXTRA="excessive args (please remove)"
export ERR_ARGV_ARG="invalid arg"

export DOCKERFILE_TARGET_TESTING="testing"
export DOCKERFILE_TARGET_PACKAGING="packaging"
export DOCKER_IMG_WORKDIR_PATH="/usagef_code"
export DOCKER_IMG_NAME_PREFIX="usagef"
export DOCKER_IMG_NAME_TESTING="${DOCKER_IMG_NAME_PREFIX}-${DOCKERFILE_TARGET_TESTING}:1"
export DOCKER_IMG_NAME_PACKAGING="${DOCKER_IMG_NAME_PREFIX}-${DOCKERFILE_TARGET_PACKAGING}:1"

export DIR_BUILD_NAME="build"
export DIR_BUILD="${DIR_BUILD_NAME}"
export DIR_SRC_NAME="src"
export DIR_SRC="${DIR_SRC_NAME}"
export DIR_TOOLS_NAME="tools"
export DIR_TOOLS="${DIR_TOOLS_NAME}"
export DIR_TOOLS_TOOLCHAINS="${DIR_TOOLS}/toolchains"
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

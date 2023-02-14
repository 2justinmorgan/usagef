#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh

function exit_err_test_fail() {
	echo >&2 "test fail: $(caller)"
	exit 1
}

function get_unique_num() {
	echo "${RANDOM}${RANDOM}" | xargs | tr ' ' '0'
}

function get_temp_path() {
	local path_orig="$1"
	local path_temp
	local num

	check_sourced_strings || exit 1

	num="$(get_unique_num)"
	path_temp="${DIR_TESTS_TMP}/usagef_test_file_$(tr '/' '_' <<<"$path_orig")_$num"
	echo "$path_temp"
}

function test_usagef_output() {
	local argv="$1"
	local output_path="$2"

	echo "testing output with argv \"$argv\""

	check_sourced_functions || exit 1
	check_sourced_strings || exit_err

	build_usagef >/dev/null || exit_err

	"$DIR_BUILD"/$argv >"$output_path"
}

function build_usagef_testing() {
	local cmake_args="$@"

	check_sourced_functions || exit 1
	build_usagef $cmake_args -D IS_DEV_SETUP=1 || exit_err
}

# used to verify the contents of this file have been sourced
function check_sourced_functions_testing() {
	:
}

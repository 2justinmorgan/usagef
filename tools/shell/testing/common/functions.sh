#!/bin/bash

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
	path_temp="${DIR_TESTS_OUTPUT_ACTUAL}/usagef_test_file_$(tr '/' '_' <<<"$path_orig")_$num"
	echo "$path_temp"
}

# used to verify the contents of this file have been sourced
function check_sourced_functions_testing() {
	:
}

#!/bin/bash

function exit_err_test_fail() {
	echo >&2 "test fail: $(caller)"
	exit 1
}

function get_unique_num() {
	echo "${RANDOM}${RANDOM}" | xargs | tr ' ' '0'
}

# used to verify the contents of this file have been sourced
function check_sourced_functions_testing() {
	:
}

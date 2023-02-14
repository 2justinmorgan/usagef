#!/bin/bash

function exit_err_test_fail() {
	echo >&2 "test fail: $(caller)"
	exit 1
}

# used to verify the contents of this file have been sourced
function check_sourced_functions_testing() {
	:
}

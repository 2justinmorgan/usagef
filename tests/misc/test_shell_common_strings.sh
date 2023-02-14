#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh
. tools/shell/testing/common/functions.sh

function check_string_values() {
	echo "checking string values"
	[ "$DIR_BUILD" == "build" ] || exit_err_test_fail
	[ "$DIR_TESTS" == "tests" ] || exit_err_test_fail
	[ "$DIR_TESTS_MISC" == "${DIR_TESTS}/misc" ] || exit_err_test_fail
	echo "all string values are as expected"
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit_err
	check_sourced_functions_testing || exit_err
}

function main() {
	check_sources
	check_string_values
}

main

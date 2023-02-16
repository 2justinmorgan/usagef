#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh
. tools/shell/testing/common/functions.sh

function run_tests() {
	local path
	build_usagef_testing &&
		for path in $(list_unit_tests_paths); do
			valgrind \
				--error-exitcode=1 \
				--leak-check=full \
				./"$path" || exit 1
		done
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit 1
	check_sourced_functions_testing || exit 1
}

function main() {
	check_sources
	run_tests
}

main

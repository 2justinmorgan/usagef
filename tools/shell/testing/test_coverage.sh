#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh
. tools/shell/testing/common/functions.sh

function output_unsuccessful_unit_tests_msg() {
	local hline="****************************************************"
	echo >&2 ""
	echo >&2 ""
	echo >&2 "$hline"
	echo >&2 "    AN ERROR OCCURRED WHILE RUNNING UNIT TESTS"
	echo >&2 "          - OR -"
	echo >&2 "    ONE OR MORE UNIT TESTS HAVE FAILED"
	echo >&2 "$hline"
	echo >&2 ""
}

function run_tests() {
	local exit_code_build
	local exit_code_unit
	local exit_code_coverage
	local unit_failed=0
	local path

	build_usagef_testing -D CMAKE_BUILD_TYPE=PROFILE
	exit_code_build=$?
	for path in $(list_unit_tests_paths); do
		./"$path"
		exit_code_unit="$?"
		[ "$exit_code_unit" -ne 0 ] && unit_failed=1
	done
	if [ "$exit_code_build" -ne 0 ] || [ "$unit_failed" -ne 0 ]; then
		output_unsuccessful_unit_tests_msg
	fi
	gcovr \
		--branches \
		--exclude="${DIR_SRC}/usagef.c" \
		--fail-under-line 100 \
		--root "$DIR_SRC" \
		"$DIR_BUILD"
	exit_code_coverage=$?
	if [ "$exit_code_build" -ne 0 ] || [ "$unit_failed" -ne 0 ]; then
		output_unsuccessful_unit_tests_msg
	fi
	if [ "$exit_code_coverage" -ne 0 ]; then exit 1; fi
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit_err
	check_sourced_functions_testing || exit_err
}

function main() {
	check_sources
	run_tests
}

main

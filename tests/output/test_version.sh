#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh
. tools/shell/testing/common/functions.sh

function test_output_with_vars() {
	local argv="$1"
	local actual
	local actual_trimmed
	local exit_code
	build_usagef >/dev/null || exit_err

	# shellcheck disable=SC2086 # reason: word splitting is intended with this argv var
	actual="$("${DIR_BUILD}"/$argv)"

	exit_code="$?"
	actual_trimmed="$(xargs <<<"$actual")"

	[ "$exit_code" -eq 0 ] || exit_err_test_fail
	[ -n "$actual_trimmed" ] || exit_err_test_fail
	[ "$actual" == "$actual_trimmed" ] || exit_err_test_fail
	[[ "$actual" =~ $REGEX_USAGEF_VERSION ]] || exit_err_test_fail
}

function test_output_with_files() {
	local argv="$1"
	local output_path
	local exit_code

	output_path="$(get_temp_path "version")"

	test_usagef_output "$argv" "$output_path"

	exit_code="$?"

	[ "$exit_code" -eq 0 ] || exit_err_test_fail
	[ "$(wc -l <"$output_path")" -eq 1 ] || exit_err_test_fail
	[[ "$(cat "$output_path")" =~ $REGEX_USAGEF_VERSION ]] || exit_err_test_fail
	rm "$output_path"
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit_err
	check_sourced_functions_testing || exit_err
}

function run_tests() {
	local argv="$1"
	test_output_with_vars "$argv"
	test_output_with_files "$argv"
}

function main() {
	local argv_to_test

	argv_to_test="usagef --version"

	check_sources

	run_tests "$argv_to_test"
}

main

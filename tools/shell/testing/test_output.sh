#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh

function test_output() {
	local output_test_script_name="$1"

	if "${DIR_TESTS_OUTPUT}/$output_test_script_name"; then
		return
	fi

	exit 1
}

function test_outputs() {
	echo "testing usagef output"

	test_output test_usage_message.sh
	test_output test_version.sh

	echo "all usagef output is as expected"
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit_err
}

function main() {
	check_sources || exit 1
	test_outputs
}

main

#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh

function test_misc() {
	local misc_test_script_name="$1"
	local err_msg="$2"

	if "${DIR_TESTS_MISC}/$misc_test_script_name"; then
		return
	fi

	echo >&2 "$err_msg"
	exit 1
}

function test_misc_all() {
	echo "testing all misc tests"

	test_misc \
		test_is_valid_branch_name.sh \
		"a branch name is not valid"

	test_misc \
		test_shell_common_strings.sh \
		"a common shell tool string does not have an expected value"
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit_err
}

function main() {
	check_sources
	test_misc_all
}

main

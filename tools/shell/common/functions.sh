#!/bin/bash

function is_valid_branch_name() {
	local branch_name="$1"

	if grep "^\(feat\|fix\|devenv\)-[a-z-]\+$" <<<"$branch_name" >/dev/null; then
		echo 1
		return
	fi

	echo 0
}

function exit_err_test_fail() {
	echo >&2 "error $(caller)"
	exit 1
}

# used to verify the contents of this file have been sourced
function check_sourced_functions() {
	:
}

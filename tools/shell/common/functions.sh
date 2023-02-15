#!/bin/bash

. tools/shell/common/strings.sh

function exit_err() {
	echo >&2 "error: $(caller)"
	exit 1
}

function is_valid_branch_name() {
	local branch_name="$1"

	if grep "^\(feat\|fix\|devenv\)-[a-z-]\+$" <<<"$branch_name" >/dev/null; then
		echo 1
		return
	fi

	echo 0
}

function build_usagef() {
	local cmake_args="$@"

	check_sourced_strings || exit_err
	rm -rf "$DIR_BUILD" || exit_err
	cmake $cmake_args -B "$DIR_BUILD" -S . || exit_err
	make -C "$DIR_BUILD" || exit_err
}

# used to verify the contents of this file have been sourced
function check_sourced_functions() {
	:
}

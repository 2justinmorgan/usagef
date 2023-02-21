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
	local cmake_args="$*"

	check_sourced_strings || exit_err
	rm -rf "$DIR_BUILD" || exit_err
	# shellcheck disable=SC2086 # reason: cmake args are not detected if the var is surrounded by strings
	cmake $cmake_args -B "$DIR_BUILD" -S . || exit_err
	make -C "$DIR_BUILD" || exit_err
}

function err_argv() {
	local usage_msg="$1"
	local error_description="$2"
	local argv_content="$3"

	echo >&2 -e "$usage_msg"
	[ -n "$argv_content" ] && echo >&2 -n "'$argv_content' "
	echo >&2 -e "$error_description"
	exit 1
}

# used to verify the contents of this file have been sourced
function check_sourced_functions() {
	:
}

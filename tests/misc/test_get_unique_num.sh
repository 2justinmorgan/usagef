#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/testing/common/functions.sh

function test_get_unique_num() {
	local actual_1
	local actual_2
	echo "testing get_unique_num"
	actual_1="$(get_unique_num)"
	actual_2="$(get_unique_num)"
	[[ "$actual_1" =~ ^[0-9]+$ ]] || exit_err
	[[ "$actual_2" =~ ^[0-9]+$ ]] || exit_err
	[ "$actual_1" -ne "$actual_2" ] || exit_err
	echo "all get_unique_num tests have passed"
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_functions_testing || exit_err
}

function main() {
	check_sources
	test_get_unique_num
}

main

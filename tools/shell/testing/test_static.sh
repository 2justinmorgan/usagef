#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh
. tools/shell/testing/common/functions.sh

function run_tests_files_md() {
	local paths
	local path
	local path_temp
	echo "checking format of .md files"

	paths=$(find ./* | grep -v "/${DIR_BUILD}/" | grep "\.md$")
	for path in $paths; do
		echo "$path"
		if mdformat --check "$path"; then continue; fi
		path_temp="$(get_temp_path "$path")"
		cp "$path" "$path_temp"

		mdformat "$path_temp"

		diff "$path" "$path_temp"
		rm "$path_temp"
		exit_err_test_fail
	done
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit_err
	check_sourced_functions_testing || exit_err
}

function main() {
	check_sources
	run_tests_files_md
}

main

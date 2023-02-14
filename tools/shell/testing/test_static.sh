#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh
. tools/shell/testing/common/functions.sh

function run_tests_sh() {
	local sh_file_paths
	local path

	sh_file_paths=$(find ./* | grep -v "/${DIR_BUILD_NAME}/" | grep "\.sh$")
	echo "checking sh files formatting"
	for path in $sh_file_paths; do
		echo "$path"
		shfmt --diff "$path" ||
			exit_err_test_fail
	done

	echo "linting sh files"
	for path in $sh_file_paths; do
		echo "$path"
		shellcheck "$path" ||
			exit_err_test_fail
	done
}

function run_tests_cmake() {
	local cmake_files_paths
	local path
	local path_temp

	cmake_files_paths="$(find ./* | grep -v "${DIR_BUILD_NAME}/" | grep "CMakeLists\.txt$\|\.cmake$")"

	echo "checking cmake files formatting"
	for path in $cmake_files_paths; do
		echo "$path"
		if cmake-format --check "$path"; then continue; fi
		path_temp="$(get_temp_path "$path")"
		cp "$path" "$path_temp"
		cmake-format --in-place "$path_temp"
		diff "$path" "$path_temp"
		rm "$path_temp"
		exit_err_test_fail
	done

	echo "linting cmake files"
	for path in $cmake_files_paths; do
		echo "$path"
		cmake-lint "$path" || exit_err_test_fail
	done
}

function run_tests_md() {
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
	run_tests_md
	run_tests_cmake
	run_tests_sh
}

main

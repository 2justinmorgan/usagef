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

function run_tests_c() {
	local filter_c
	local filter_h
	local paths_c
	local paths_h
	local paths
	local path
	local msg_prefix

	filter_c="\.c$"
	filter_h="\.h$"
	paths_c="$(find "$DIR_SRC" | grep "$filter_c") $(find "$DIR_TESTS" | grep "$filter_c")"
	paths_h="$(find "$DIR_SRC" | grep "$filter_h") $(find "$DIR_TESTS" | grep "$filter_h")"
	paths="$paths_c $paths_h"
	msg_prefix="checking .c and .h files:"

	echo "$msg_prefix check format ${DIR_SRC_NAME}/ and ${DIR_TESTS_NAME}/"
	for path in $paths; do
		echo "$path"
		clang-format --dry-run -Werror "$path" ||
			exit_err_test_fail
	done

	echo "$msg_prefix lint .c and .h files"
	# shellcheck disable=SC2086 # reason: clang-tidy needs discrete paths
	clang-tidy $paths_h 2>/dev/null || exit_err_test_fail
	build_usagef_testing -D IS_STATIC_CHECKING=1 || exit_err_test_fail
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
	run_tests_c
}

main

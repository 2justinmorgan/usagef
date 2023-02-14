#!/bin/bash

. tools/shell/common/functions.sh

function check_sources() {
	check_sourced_functions || exit 1
}

function main() {
	check_sources
	build_usagef || exit_err
}

main

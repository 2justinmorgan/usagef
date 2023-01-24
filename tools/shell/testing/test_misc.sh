#!/bin/bash

function test_is_valid_branch_name() {
	if ./tests/misc/test_is_valid_branch_name.sh; then return; fi
	echo >&2 "an is_valid_branch_name test failed"
	exit 1
}

function test_misc_all() {
	echo "testing all misc tests"
	test_is_valid_branch_name
}

function main() {
	test_misc_all
}

main

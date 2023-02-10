#!/bin/bash

export DIR_BUILD="build"
export DIR_TESTS="tests"
export DIR_TESTS_MISC="${DIR_TESTS}/misc"
export DIR_TESTS_OUTPUT="${DIR_TESTS}/output"
export DIR_TESTS_OUTPUT_ACTUAL="${DIR_TESTS_OUTPUT}/actual"
export DIR_TESTS_OUTPUT_EXPECTED="${DIR_TESTS_OUTPUT}/expected"

# used to verify the contents of this file have been sourced
function check_sourced_strings() {
	:
}

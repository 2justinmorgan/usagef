#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh

function check_args() {
	local argc="$1"
	local prog_path="$2"
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_tests_types=($3)

	local argv=()
	local i=0 j
	for ((j = "${#BASH_ARGV[@]}"; j >= 0; j--)); do
		argv["$i"]="${BASH_ARGV[$j]}" && i="$((i + 1))"
	done && argv[0]="$prog_path"

	local tests_type
	local tests_type_index=1
	local usage_msg
	usage_msg="Usage: $(basename "${argv[0]}") <<[--docker] <tests_type>> | <--types|--docker-build>>"

	[ "$argc" -lt 2 ] && err_argv "$usage_msg" "$ERR_ARGV_NEEDED"

	if [ "${argv[1]}" == "--types" ] || [ "${argv[1]}" == "--docker-build" ]; then
		[ "$argc" -gt 2 ] && err_argv "$usage_msg" "$ERR_ARGV_EXTRA" "${argv[*]:2}"
		return
	fi

	[ "${argv[1]}" == "--docker" ] && tests_type_index=$((tests_type_index + 1))
	[ "$argc" -gt "$((tests_type_index + 1))" ] &&
		err_argv "$usage_msg" "$ERR_ARGV_EXTRA" "${argv[*]:$((tests_type_index + 1))}"

	tests_type="${argv[$tests_type_index]}"

	[ -z "$tests_type" ] && err_argv "$usage_msg" "please specify a value for <tests_type>"

	for item in "${valid_tests_types[@]}"; do
		[[ "$tests_type" == "$item" ]] && return
	done

	err_argv \
		"$usage_msg" \
		"tests type is not one of [${valid_tests_types[*]}]" \
		"$tests_type"
}

function output_types() {
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_tests_types=($1)
	local tests_type

	for tests_type in "${valid_tests_types[@]}"; do
		echo "$tests_type"
	done
}

function run_test_script() {
	local script_name="$1"
	"${DIR_TOOLS_SHELL_TESTING}"/"$script_name" || exit_err
}

function run_tests() {
	local tests_type="$1"
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_tests_types=($2)
	local index
	local test_script_names=(
		test_static.sh
		test_units.sh
		test_coverage.sh
		test_valgrind.sh
		test_output.sh
		test_misc.sh
	)

	index="$(get_index_of "$tests_type" "${valid_tests_types[*]}")"
	[[ "$index" -eq -1 ]] && exit_err
	[[ "${test_script_names[$index]}" =~ $tests_type ]] || exit_err

	run_test_script "${test_script_names[$index]}"
}

function test_with_docker() {
	local is_only_build_img="$1"
	local container_id
	local container_exit_code

	build_docker_image "$DOCKER_IMG_NAME_TESTING" "$DOCKERFILE_TARGET_TESTING" || exit_err

	if [[ "$is_only_build_img" -eq 1 ]]; then return; fi

	echo "testing with docker..."

	container_id=$(docker run -itd "$DOCKER_IMG_NAME_TESTING")
	docker cp . "${container_id}":"$DOCKER_IMG_WORKDIR_PATH"
	docker exec "${container_id}" \
		bash -c "\"${DIR_TOOLS_SHELL_TESTING}\"/test.sh $tests_type || exit 1"

	container_exit_code=$?

	docker rm --force "${container_id}" >/dev/null

	if [[ "$container_exit_code" -ne 0 ]]; then
		exit_err
	fi
}

function apply_args() {
	local argc="$1"
	local prog_path="$2"
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_tests_types=($3)

	local argv=()
	local i=0 j
	for ((j = "${#BASH_ARGV[@]}"; j >= 0; j--)); do
		argv["$i"]="${BASH_ARGV[$j]}" && i="$((i + 1))"
	done && argv[0]="$prog_path"

	local tests_type="${argv[$((argc - 1))]}"

	case "${argv[1]}" in
	"--types")
		output_types "${valid_tests_types[*]}"
		;;
	"--docker-build")
		test_with_docker 1
		;;
	"--docker")
		test_with_docker 0
		;;
	*)
		run_tests "$tests_type" "${valid_tests_types[*]}"
		;;
	esac
}

function check_sources() {
	check_sourced_functions || exit 1
	check_sourced_strings || exit_err
}

function main() {
	local argc="$(($1 + 1))"
	local prog_path="$2"

	local argv=()
	local i=0 j
	for ((j = "${#BASH_ARGV[@]}"; j >= 0; j--)); do
		argv["$i"]="${BASH_ARGV[$j]}" && i="$((i + 1))"
	done && argv[0]="$prog_path"

	local valid_tests_types
	local tests_type

	check_sources

	valid_tests_types=(static unit coverage valgrind output misc)

	check_args \
		"$argc" \
		"${argv[0]}" \
		"${valid_tests_types[*]}"

	apply_args \
		"$argc" \
		"${argv[0]}" \
		"${valid_tests_types[*]}"
}

main "${#BASH_ARGV[@]}" "$0"

#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh

function check_args() {
	local argc="$1"
	local prog_path="$2"
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_targets=($3)

	local argv=()
	local i=0 j
	for ((j = "${#BASH_ARGV[@]}"; j >= 0; j--)); do
		argv["$i"]="${BASH_ARGV[$j]}" && i="$((i + 1))"
	done && argv[0]="$prog_path"

	local target
	local usage_msg
	usage_msg="Usage: $(basename "${argv[0]}") <--targets | <target>>"

	[ "$argc" -lt 2 ] && err_argv "$usage_msg" "$ERR_ARGV_NEEDED"
	[ "$argc" -gt 2 ] && err_argv "$usage_msg" "$ERR_ARGV_EXTRA" "${argv[*]:2}"

	target="${argv[1]}"

	for valid_target in "${valid_targets[@]}"; do
		[[ "$target" == "$valid_target" ]] && return
	done

	[ "${argv[1]}" != "--targets" ] &&
		err_argv \
			"$usage_msg" \
			"target is not one of [${valid_targets[*]}]" \
			"${argv[1]}"
}

function delete_container() {
	local container_id="$1"
	docker rm --force "${container_id}" >/dev/null || exit_err
}

function exit_err_container() {
	local container_id="$1"

	echo >&2 "error $(caller)"
	delete_container "$container_id"
	exit_err
}

function output_image_tag() {
	local usagef_version
	usagef_version="$(output_usagef_version)"
	if [ -z "$usagef_version" ]; then
		echo >&2 -e "error getting usagef version for image tag\n$(caller)"
		exit_err
	fi
	echo "$usagef_version"
}

function copy_local_files() {
	local container_id="$1"

	docker cp "$DIR_SRC" "${container_id}:${DOCKER_IMG_WORKDIR_PATH}"
	docker cp "$DIR_TOOLS" "${container_id}:${DOCKER_IMG_WORKDIR_PATH}"
	docker cp CMakeLists.txt "${container_id}:${DOCKER_IMG_WORKDIR_PATH}"
}

function build_executable() {
	local container_id="$1"
	local path_toolchain="$2"
	local toolchain_arg

	toolchain_arg="-DCMAKE_TOOLCHAIN_FILE=${DOCKER_IMG_WORKDIR_PATH}/${path_toolchain}"
	docker exec "$container_id" bash -c ". tools/shell/common/functions.sh && build_usagef $toolchain_arg" ||
		exit_err_container "$container_id"
}

function strip_executable() {
	local container_id="$1"
	local path_executable="$2"
	local path_executable_copy
	local strippers
	local stripper

	path_executable_copy="${path_executable}_copy"
	strippers=(
		/usr/bin/arm-linux-gnueabi-strip
		/usr/bin/aarch64-linux-gnu-strip
		/usr/bin/x86_64-w64-mingw32-strip
		/opt/osxcross/bin/x86_64-apple-darwin18-strip
		/usr/bin/x86_64-linux-gnu-strip
		/usr/bin/strip
	)

	for stripper in "${strippers[@]}"; do
		docker exec "$container_id" cp "$path_executable" "$path_executable_copy"

		if docker exec "$container_id" "$stripper" "$path_executable_copy" && ! docker exec "$container_id" diff "$path_executable" "$path_executable_copy"; then
			docker exec "$container_id" "$stripper" "$path_executable" ||
				exit_err_container "$container_id"
			echo "stripped '$path_executable' with '$stripper'"
			docker exec "$container_id" rm "$path_executable_copy"
			return
		fi
	done

	echo >&2 "unable to strip '$path_executable'"
	exit_err_container "$container_id"
}

function get_executable() {
	local path_toolchain="$1"

	build_docker_image "$DOCKER_IMG_NAME_PACKAGING" "$DOCKERFILE_TARGET_PACKAGING" || exit_err

	echo "building usagef with toolchain '$path_toolchain'"
	rm -rf "$DIR_BUILD"

	container_id=$(docker run -itd "${DOCKER_IMG_NAME_PACKAGING}") || exit_err
	copy_local_files "$container_id" || exit_err_container "$container_id"

	build_executable \
		"$container_id" \
		"$path_toolchain" ||
		exit_err_container "$container_id"

	strip_executable \
		"$container_id" \
		"$(docker exec "$container_id" bash -c ". tools/shell/common/functions.sh && get_built_executable_path")" ||
		exit_err_container "$container_id"

	docker cp \
		"${container_id}:${DOCKER_IMG_WORKDIR_PATH}/${DIR_BUILD}" \
		"$DIR_BUILD" ||
		exit_err_container "$container_id"
	echo "built executable at '$(pwd)/$(get_built_executable_path)'"
	delete_container "$container_id"
}

function output_targets() {
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_targets=($1)
	local target

	for target in "${valid_targets[@]}"; do
		echo "$target"
	done
}

function apply_args() {
	local argv_1="$1"
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_targets=($2)
	local toolchain_file_names
	local index

	toolchain_file_names=(
		aarch64-linux-gnu.cmake
		arm-linux-gnueabi.cmake
		x86_64-linux-gnu.cmake
		x86_64-apple-darwin18.cmake
		x86_64-w64-mingw32.cmake
	)

	case "$argv_1" in
	"--targets")
		output_targets "${valid_targets[*]}" || exit_err
		;;
	"${valid_targets[0]}")
		build_usagef || exit_err
		;;
	*)
		index="$(get_index_of "$argv_1" "${valid_targets[*]}")"
		[[ "$index" -eq -1 ]] && exit_err
		get_executable "${DIR_TOOLS_TOOLCHAINS}/${toolchain_file_names[$((index - 1))]}" || exit_err
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

	local valid_targets

	check_sources

	valid_targets=(
		"local"
		linux-arm64
		linux-arm32
		linux-x64
		darwin-x64
		windows-x64
	)

	check_args \
		"$argc" \
		"${argv[0]}" \
		"${valid_targets[*]}"

	apply_args \
		"${argv[1]}" \
		"${valid_targets[*]}"
}

main "${#BASH_ARGV[@]}" "$0"

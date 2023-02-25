#!/bin/bash

. tools/shell/common/functions.sh
. tools/shell/common/strings.sh

function check_args() {
	local argc="$1"
	local prog_path="$2"
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_package_types=($3)
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_targets=($4)

	local argv=()
	local i=0 j
	for ((j = "${#BASH_ARGV[@]}"; j >= 0; j--)); do
		argv["$i"]="${BASH_ARGV[$j]}" && i="$((i + 1))"
	done && argv[0]="$prog_path"

	local package_type
	local target
	local usage_msg
	usage_msg="Usage: $(basename "${argv[0]}") <package_type> <target>"

	[ "$argc" -lt 3 ] && err_argv "$usage_msg" "$ERR_ARGV_NEEDED"
	[ "$argc" -gt 3 ] && err_argv "$usage_msg" "$ERR_ARGV_EXTRA" "${argv[*]:3}"

	package_type="${argv[1]}"
	target="${argv[2]}"

	[[ "$(for valid_type in "${valid_package_types[@]}"; do [[ "$package_type" != "$valid_type" ]] || echo 1; done)" -eq 1 ]] ||
		err_argv \
			"$usage_msg" \
			"package type is not one of [${valid_package_types[*]}]" \
			"${argv[1]}"

	[[ "$(for valid_target in "${valid_targets[@]}"; do [[ "$target" != "$valid_target" ]] || echo 1; done)" -eq 1 ]] ||
		err_argv \
			"$usage_msg" \
			"target is not one of [${valid_targets[*]}]" \
			"${argv[2]}"
}

function package_precompiled() {
	local target="$1"
	local path_executable="$2"
	local usagef_version="$3"
	local dir_precompiled
	local path_readme

	# shellcheck disable=SC2001 # reason: a "variable" is not used here
	dir_precompiled="$(sed 's/-/_/g' <<<"./usagef-v${usagef_version}-${target}")"

	rm -rf "$dir_precompiled"
	mkdir "$dir_precompiled"
	path_readme="${dir_precompiled}/README.txt"

	{
		echo "      This is a precompiled usagef binary."
		echo "     https://github.com/2justinmorgan/usagef"
		echo
		echo "    usagef is a tool to print formatted usage"
		echo "  and help messages for your terminal programs."
		echo "      It is licensed under the MIT license."
		echo
		echo "=================== examples ==================="
		echo "   $ $(basename "$path_executable") --version"
		echo "   $usagef_version"
		echo
		echo "===================  commit  ==================="
		git log -1
	} >"$path_readme"

	cp LICENSE.txt "$dir_precompiled"
	cp "$path_executable" "$dir_precompiled"

	if [[ "$(tail -c 5 <<<"$path_executable")" == ".exe" ]]; then
		zip -r "${dir_precompiled}.zip" "$dir_precompiled" || exit_err
	else
		tar cfJ "${dir_precompiled}.tar.xz" "$dir_precompiled" || exit_err
	fi
	rm -rf "$dir_precompiled"
	# shellcheck disable=SC2010 # reason: ls is better for sorting by date modified
	echo "packaged '$(ls -tr1 | grep "^usagef" | tail -1)'"
}

function package() {
	local package_type="$1"
	local target="$2"
	# shellcheck disable=SC2206 # reason: read -a does not create a local var
	local valid_package_types=($3)
	local path_executable
	local usagef_version

	tools/shell/build.sh "$target" || exit_err

	echo "packaging usagef as a '$package_type' package for target '$target'"

	path_executable="$(get_built_executable_path)" || exit_err
	usagef_version="$(grep "define CONFIG_USAGEF_VERSION " "${DIR_BUILD}/usagef_config.h" | cut -d' ' -f3 | sed 's/"//g')" ||
		exit_err

	case "$package_type" in
	"${valid_package_types[0]}")
		package_precompiled "$target" "$path_executable" "$usagef_version"
		;;
	*)
		echo >&2 "package type '$package_type' not caught"
		exit_err
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

	local valid_package_types
	local valid_targets

	check_sources

	# shellcheck disable=SC2207 # reason: read -a does not create a local var
	valid_targets=($(tools/shell/build.sh --targets | tr '\n' ' '))
	valid_package_types=(
		precompiled
	)

	check_args \
		"$argc" \
		"${argv[0]}" \
		"${valid_package_types[*]}" \
		"${valid_targets[*]}"

	package \
		"${argv[1]}" \
		"${argv[2]}" \
		"${valid_package_types[*]}"
}

main "${#BASH_ARGV[@]}" "$0"

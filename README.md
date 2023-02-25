# usagef

`usagef` is a tool to print formatted usage and help messages for your terminal programs

```
Usage: usagef --version
```

## Examples

```
$ usagef --version
0.1.0
```

## Build

`tools/shell/build.sh` is the script that cross-compiles `usagef` executables for multiple target architectures and operating systems such as:

- aarch64-linux-gnu
- arm-linux-gnueabi
- x86_64-apple-darwin18
- x86_64-linux-gnu
- x86_64-w64-mingw32

```
Usage: build.sh <--targets | <target>>
```

target "local" will build a `usagef` executable for your system

## Install

`usagef` is currently available as precompiled executables for

- [macOS, x64](https://github.com/2justinmorgan/usagef/releases/latest/download/usagef_v0.1.0_darwin_x64.tar.xz)
- [Linux, arm32](https://github.com/2justinmorgan/usagef/releases/latest/download/usagef_v0.1.0_linux_arm32.tar.xz) (statically linked)
- [Linux, arm64](https://github.com/2justinmorgan/usagef/releases/latest/download/usagef_v0.1.0_linux_arm64.tar.xz) (statically linked)
- [Linux, x64](https://github.com/2justinmorgan/usagef/releases/latest/download/usagef_v0.1.0_linux_x64.tar.xz) (statically linked)
- [Windows, x64](https://github.com/2justinmorgan/usagef/releases/latest/download/usagef_v0.1.0_windows_x64.zip)

[GitHub Releases](https://github.com/2justinmorgan/usagef/releases) contains specific `usagef` versions

# Developers

This remaining section outlines information for developers that want to contribute to the `usagef` project

## Testing

`tools/shell/testing/test.sh` is the script that runs all static, unit, coverage, valgrind, and output checks and tests for all code of this repository

```
Usage: test.sh <<[--docker] <tests_type>> | <--types|--docker-build>>
```

#### examples

```
$ tools/shell/testing/test.sh --types
static
unit
coverage
valgrind
output
misc
```

#### types

- **static** checks include linting and format-checking of all `.c`, `.h`, `.sh`, and `CMakeLists.txt` files\
  all `README.md` files are also format-checked
- **unit** tests test individual functions that exist in `.c` files in `src/usagef/`
- **coverage** checks verify that unit tests execute 100% of all lines of code in `src/usagef/`
- **valgrind** checks verify that unit tests contain zero memory leaks from code written in `src/usagef/`
- **output** checks test, in an end-to-end fashion, the terminal output of `usagef` commands
- **misc** tests test miscellaneous things such as how the current usagef version number is retrieved

#### tools used

- [clang-tidy](https://clang.llvm.org/extra/clang-tidy/) is linting `.c` and `.h` files in `src/`
- [cppcheck](https://cppcheck.sourceforge.io/) is linting `.c` and `.h` files in `test/`
- [shellcheck](https://www.shellcheck.net/) is linting all `.sh` files
- [cmake-lint](https://cmake-format.readthedocs.io/en/latest/cmake-lint.html) is linting all `CMakeLists.txt` files
- [clang-format](https://clang.llvm.org/docs/ClangFormat.html) is checking the formatting of all `.c` and `.h` files
- [shfmt](https://github.com/mvdan/sh) is checking the formatting of all `.sh` files
- [cmake-format](https://cmake-format.readthedocs.io/en/latest/cmake-format.html) is checking the formatting of all `CMakeLists.txt` files
- [mdformat](https://pypi.org/project/mdformat/) is checking the formatting of all `README.md` files
- [gcovr](https://gcovr.com/en/stable/) is checking unit tests' coverage of code in `src/usagef/`
- [valgrind](https://valgrind.org/) is checking for memory leaks when unit testing code in `src/usagef/`

#### Docker

[Docker](https://www.docker.com/) can be used for testing on your machine if you are experiencing environment or dependency issues

`--docker-build` will start the building of an image needed to run containerized tests

```
$ tools/shell/testing/test.sh --docker-build
```

`--docker` will enable containerized testing of the specified `<tests_type>`

```
$ tools/shell/testing/test.sh --docker valgrind
```

## Git

#### branch naming

Branch names shall contain only lower-case letters, dashes '-', and one of the following prefixes:

- `feat-` for new user-related features that may increment the `<major>` or `<minor>` version of the semver pattern `<major>.<minor>.<patch>`
- `fix-` for user-related bugfixes that may increment the `<patch>` version of the semver pattern `<major>.<minor>.<patch>`
- `devenv-` for developer-related changes, e.g. documentation or testing, that have no direct effect to the user

#### hooks

Check for branch name validity by setting either of your local `.git/hooks/pre-commit` or `.git/hooks/pre-push` hooks with this content:

```
#!/bin/bash

. tools/shell/common/functions.sh

branch_name="$(git branch | grep "^* " | tr '*' ' ' | xargs)"

[[ "$(is_valid_branch_name "$branch_name")" -eq "1" ]] && exit 0

echo >&2 "branch name '$branch_name' does not resemble the required regex pattern (see README)"
exit 1
```

#### pushing to main

Branches will be "squashed" to one commit, using the branch name as the commit message, before being merged into the main branch

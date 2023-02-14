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

# Developers

This remaining section outlines information for developers that want to contribute to the `usagef` project

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

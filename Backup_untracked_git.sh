#!/usr/bin/env bash

# This script backups untracked git files to another git repository.
# Creates directory ../ansible_webserver_private
# If you need another directory, create symlink or pass
# your path as an argument.

# See 'man bash', chapter 'Parameter Expansion' to understand
# how to set default values.
# No need in quotes here!
BACKUPDIR=${1:-../ansible_webserver_private}
echo "${BACKUPDIR}"
test -d "${BACKUPDIR}" || mkdir -vp "${BACKUPDIR}"
git ls-files --others -z | xargs -0 cp --parents -p -t "${BACKUPDIR}"
cd "${BACKUPDIR}"
git status

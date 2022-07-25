#!/usr/bin/bash

cd "$HOME"/lazygit-remote || return 1

git_commit="$(git rev-list -1 HEAD)"

short_git_commit="${git_commit:0:5}"

git_tag=$(git describe --tags --abbrev=0)

build_date="$(date +%Y-%m-%d)"

build_source="fromSource"

echo "commit hash: $git_commit"
echo "short commit hash: $short_git_commit"
echo "release tag: $git_tag"
echo "build date: $build_date"
echo "build source: $build_source"
# - -s -w -X main.version={{.Version}} -X main.commit={{.Commit}} -X main.date={{.Date}} -X main.buildSource=binaryRelease

go install -ldflags "-s -w -X main.version=$git_tag -X main.commit=$short_git_commit  \
    -X main.date=$build_date -X main.buildSource=$build_source"

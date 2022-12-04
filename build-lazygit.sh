#!/usr/bin/bash

# add git_work_tree variable
export GIT_WORK_TREE="$HOME"/lazygit-remote/

cd "$GIT_WORK_TREE" && git pull

git_tag=$(git describe --tags --abbrev=0)

# checkout latest release tag
git checkout "$git_tag"

git_commit="$(git rev-list -1 HEAD)"

short_git_commit="${git_commit:0:5}"

build_date="$(date +%Y-%m-%d)"

build_source="fromSource"

echo "Building lazygit version $git_tag"
echo "commit hash: $git_commit"
echo "short commit hash: $short_git_commit"
echo "release tag: $git_tag"
echo "build date: $build_date"
echo "build source: $build_source"

# - -s -w -X main.version={{.Version}} -X main.commit={{.Commit}} -X main.date={{.Date}} -X main.buildSource=binaryRelease

gum spin --spinner="monkey" --show-output --title="installing lazygit..." -- go install -ldflags \
	"-s -w -X main.version=$git_tag  \
    -X main.commit=$short_git_commit  \
    -X main.date=$build_date -X main.buildSource=$build_source"

# unset git_work_tree variable
unset GIT_WORK_TREE

# checkout previous HEAD
git switch -

echo "🎊 done building lazygit!"

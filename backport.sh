#!/usr/bin/env bash

#Usage: USERNAME=<username> GITHUB_ACCESS_TOKEN=access_token COMMIT_SHA=1234w MAJOR_RELEASE_NUMBER=18 ./backport.sh

# Delete all local release branches
git checkout master
git branch -D $(git branch --list "release-${MAJOR_RELEASE_NUMBER}*")

# Add upstream to point to gocd/docs.go.cd with personal access token.
git remote show upstream
if test $? != 0; then
git remote add upstream https://${USERNAME}:${GITHUB_ACCESS_TOKEN}@github.com/gocd/docs.go.cd.git
fi

# Fetch all branches
git fetch upstream


# For all upstream release branches, create a local branch off of master, cherry-pick the commit, push to upstream
for i in $(git branch -r --list "upstream/release-${MAJOR_RELEASE_NUMBER}*"); do git checkout -b ${i##*/} -t $i && git cherry-pick ${COMMIT_SHA} && git push; done

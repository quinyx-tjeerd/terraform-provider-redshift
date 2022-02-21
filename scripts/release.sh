#!/usr/bin/env bash

set -e # autofail on first error

VERSION=$(cat VERSION | tr -d "\n")

if grep -q $VERSION CHANGELOG.md; then
  echo "Already found changelog entry for $VERSION"
else
  echo "What is the version prior to $VERSION?"
  read prior_version
  prior_content=$(grep -v "^# CHANGELOG" CHANGELOG.md)
  new_commits=$(git log $prior_version..HEAD --pretty=format:" - %s (%an)")
  new_changelog="# CHANGELOG\n\n## $VERSION\n\n$new_commits\n\n$prior_content"

  echo -e "$new_changelog" > CHANGELOG.md
fi

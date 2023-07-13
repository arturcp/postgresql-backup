#!/bin/bash

# Check if gem version argument is provided
if [ -z "$1" ]; then
  echo "Gem version argument is required."
  exit 1
fi

# Remove the gem file
gem_version="$1"
gem_file="postgresql-backup-$gem_version.gem"

if [ -f "$gem_file" ]; then
  echo "Removing gem file: $gem_file"
  rm -f "$gem_file"
else
  echo "Gem file $gem_file doesn't exist."
fi

# Remove local tag
if git rev-parse "$gem_version" >/dev/null 2>&1; then
  echo "Removing local tag: $gem_version"
  git tag -d "$gem_version"
else
  echo "Local tag $gem_version doesn't exist."
fi

# Remove remote tag
if git ls-remote --exit-code --tags origin "$gem_version" >/dev/null 2>&1; then
  echo "Removing remote tag: $gem_version"
  git push --delete origin "$gem_version"
else
  echo "Remote tag $gem_version doesn't exist."
fi

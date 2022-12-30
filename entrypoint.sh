#!/bin/bash

# Parse the tag we're on, do nothing if there isn't one
TAG=$(echo ${GITHUB_REF} | grep tags | grep -o "[^/]*$")
if [[ -z "${TAG}" ]]; then
    echo "Not a tag push, skipping"
    exit 0
fi

# Validate the version string we're building
if ! echo "${TAG}" | grep -P --quiet '^(v)?\d+\.\d+\.\d+$'; then
    echo "Bad version, needs to be (v)%u.%u.%u"
    exit 1
fi

# Strip "v" if it is prepended to the semver
if [[ "${TAG:0:1}" == "v" ]]; then
  GIT_TAG="${TAG}"
  TAG="${TAG:1}"
else
  GIT_TAG="${TAG}"
fi

echo "TAG: ${TAG}"
echo "GIT_TAG: ${GIT_TAG}"

INFO_VERSION=$(jq -r '.version' info.json)
# Make sure the info.json is parseable and has the expected version number
if ! [[ "${INFO_VERSION}" == "${TAG}" ]]; then
    echo "Tag version doesn't ${TAG} match info.json version ${INFO_VERSION} (or info.json is invalid), failed"
    exit 1
fi
# Pull the mod name from info.json
NAME=$(jq -r '.name' info.json)

# Create the zip
if [[ -z "${GIT_TAG}" ]]; then
    echo "Needs a tag set before the archive can be built"
    exit 0
fi
echo git archive --prefix "${NAME}/" -o "/github/workspace/${NAME}_$INFO_VERSION.zip" "${GIT_TAG}"
git archive --prefix "${NAME}_$INFO_VERSION/" -o "/github/workspace/${NAME}_$INFO_VERSION.zip" "${GIT_TAG}"
FILESIZE=$(stat --printf="%s" "${NAME}_${TAG}.zip")
echo "File zipped, ${FILESIZE} bytes"
unzip -v "${NAME}_${TAG}.zip"

# Copy it into dist folder
rm -rf dist
mkdir dist/
cp "${NAME}_${TAG}.zip" dist/

# Print out some info on the bundle
PACKAGE_NAME="$(pwd)/dist/${NAME}_${TAG}.zip"
echo $PACKAGE_NAME
echo "asset_path=${PACKAGE_NAME}" >> $GITHUB_OUTPUT

echo "Creation of ${PACKAGE_NAME} completed"

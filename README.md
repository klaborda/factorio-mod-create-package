# GitHub Action to automatically package a Factorio mod

Builds a zipped package of the Factorio mod

## Inspiration

https://github.com/Penguin-Spy/factorio-mod-portal-publish

https://github.com/Roang-zero1/factorio-mod-package

## Usage

Currently, this action expects a flat repo structure with exactly one complete mod in the git repo (with a valid info.json in the repo's root).

It also expects tag names to match the Factorio mod version numbering scheme - three numbers separated by periods, eg. `1.15.0`. Versions prefixed with a "v" will also be processed.

Non-tag pushes will be ignored, but when a tag is pushed that is valid and matches the version number in info.json, the mod will be zipped up.

An example workflow to publish tagged releases:

    on: push
    name: Publish
    jobs:
      publish:
        runs-on: ubuntu-latest
        steps:
        - uses: actions/checkout@master
        - name: Publish Mod
          uses: klaborda/factorio-mod-create-package@master

A valid `.gitattributes` file is required to filter .git*/* directories. This file must be checked in and tagged to filter during a git-archive operation. It should contain the following entries:

    .gitattributes export-ignore
    .gitignore export-ignore
    .github export-ignore

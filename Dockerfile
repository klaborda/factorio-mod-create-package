FROM debian:11-slim

LABEL "com.github.actions.name"="Factorio Mod Create Package"
LABEL "com.github.actions.description"="Creates a zipped package of a Factorio mod for GitHub releases"
LABEL "com.github.actions.icon"="settings"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/klaborda/factorio-mod-create-package"
LABEL "maintainer"="Kevin Laborda"

RUN apt-get update && apt-get -y install curl zip jq git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

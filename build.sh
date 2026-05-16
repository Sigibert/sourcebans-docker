#!/usr/bin/zsh
#
# Builds Sourcebans Docker images locally

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <docker|podman>"
    exit 1
fi

TOOL=$1

if [ "$TOOL" != "docker" ] && [ "$TOOL" != "podman" ]; then
    echo "Invalid argument: $TOOL. Use 'docker' or 'podman'."
    exit 1
fi

function get_latest_release_tag() {
    SB_TAG=$(curl https://api.github.com/repos/sbpp/sourcebans-pp/releases -s | jq -r '.[0].tag_name')
    echo $SB_TAG
}

SB_TAG=$(get_latest_release_tag)

$TOOL build -t crinis/sourcebans:sb-${SB_TAG} -t crinis/sourcebans:latest --build-arg CHECKOUT="${SB_TAG}" .
$TOOL build -t crinis/sourcebans:sb-dev --build-arg CHECKOUT="main" .

#!/bin/sh -e

VERSION=1.20.1
LATEST_BUILD=$(curl "https://api.papermc.io/v2/projects/paper/versions/${VERSION}/builds" | jq ".builds[-1].build")

curl "https://api.papermc.io/v2/projects/paper/versions/${VERSION}/builds/${LATEST_BUILD}/downloads/paper-${VERSION}-${LATEST_BUILD}.jar" \
  -Lo ./papermc_latest.jar
